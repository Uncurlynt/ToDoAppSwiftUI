//
//  CoreDataManager.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 30.05.2025.
//

import CoreData
import SwiftUI

@MainActor
final class CoreDataManager: ObservableObject {

    static let shared = CoreDataManager()

    private let container: NSPersistentContainer
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoModel")
        if inMemory {
            let desc = NSPersistentStoreDescription()
            desc.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [desc]
        }
        container.loadPersistentStores { _, error in
            if let error { fatalError("CoreData error: \(error)") }
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    var viewContext: NSManagedObjectContext { container.viewContext }
    
    @discardableResult
    func addTask(title: String,
                 desc: String,
                 isDone: Bool = false) throws -> TaskModel {

        let entity = TaskEntity(context: viewContext)
        entity.title     = title
        entity.desc      = desc
        entity.createdAt = .now
        entity.isDone    = isDone
        try viewContext.save()
        return TaskModel(entity: entity)
    }

    func fetchAll() throws -> [TaskModel] {
        let req: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        req.sortDescriptors = [.init(key: "createdAt", ascending: false)]
        return try viewContext
            .fetch(req)
            .map(TaskModel.init)
    }

    func update(_ model: TaskModel) throws {
        guard let obj = try? viewContext.existingObject(with: model.id) as? TaskEntity else { return }
        obj.title  = model.title
        obj.desc   = model.taskDescription
        obj.isDone = model.isDone
        try viewContext.save()
    }

    func delete(id: NSManagedObjectID) throws {
        if let obj = try? viewContext.existingObject(with: id) {
            viewContext.delete(obj)
            try viewContext.save()
        }
    }

    private var hasData: Bool {
        (try? viewContext.count(for: TaskEntity.fetchRequest())) ?? 0 > 0
    }

    func bootstrapIfNeeded() async {
        guard !hasData else { return }
        do {
            let todos = try await NetworkService.shared.fetchTodos()
            _ = try todos.compactMap {
                try? addTask(title: $0.todo,
                             desc: "",
                             isDone: $0.completed)
            }
        } catch {
            print("Bootstrap error:", error)
        }
    }
}
