//
//  TaskModel.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 30.05.2025.
//

import CoreData

struct TaskModel: Identifiable, Equatable, Hashable {
    let id: NSManagedObjectID
    var title: String
    var taskDescription: String
    var createdAt: Date
    var isDone: Bool

    init(entity: TaskEntity) {
        id              = entity.objectID
        title           = entity.title ?? ""
        taskDescription = entity.desc  ?? ""
        createdAt       = entity.createdAt ?? .now
        isDone          = entity.isDone
    }
}
