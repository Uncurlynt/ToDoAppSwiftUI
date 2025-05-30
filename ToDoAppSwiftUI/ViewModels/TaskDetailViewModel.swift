//
//  TaskDetailViewModel.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 30.05.2025.
//

import SwiftUI
import CoreData

@MainActor
final class TaskDetailViewModel: ObservableObject {

    private var original: TaskModel?

    @Published var title: String = ""
    @Published var desc : String = ""
    @Published var isDone: Bool  = false

    var isNew: Bool { original == nil }

    var onSave  : ((TaskModel)          -> Void)?
    var onDelete: ((NSManagedObjectID) -> Void)?

    private let core = CoreDataManager.shared

    init(task: TaskModel? = nil) {
        self.original = task
        if let t = task {
            title  = t.title
            desc   = t.taskDescription
            isDone = t.isDone
        }
    }
    
    var createdAtString: String {
        (original?.createdAt ?? .now).shortString
    }

    func save() async -> Bool {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return false }

        if var t = original {
            t.title           = trimmed
            t.taskDescription = desc
            t.isDone          = isDone
            try? core.update(t)
            onSave?(t)
        } else {
            if let created = try? core.addTask(title: trimmed,
                                               desc: desc,
                                               isDone: isDone) {
                onSave?(created)
            }
        }
        return true
    }

    func delete() {
        guard let id = original?.id else { return }
        try? core.delete(id: id)
        onDelete?(id)
    }
    
    func autoSaveIfPossible() {
            guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            Task { _ = await save() }
        }
}
