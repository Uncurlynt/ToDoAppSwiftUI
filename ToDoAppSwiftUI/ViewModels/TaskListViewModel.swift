//
//  TaskListViewModel.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 30.05.2025.
//

import SwiftUI
import CoreData

@MainActor
final class TaskListViewModel: ObservableObject {

    @Published private(set) var tasks: [TaskModel] = []
    @Published var searchText = ""

    private let core = CoreDataManager.shared

    init() { Task { await loadTasks() } }

    var filtered: [TaskModel] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return tasks }
        let q = searchText.lowercased()
        return tasks.filter {
            $0.title.lowercased().contains(q) ||
            $0.taskDescription.lowercased().contains(q)
        }
    }

    var countText: String { "\(tasks.count) задач" }

    func loadTasks() async {
        do { tasks = try core.fetchAll() }
        catch { print("Load error:", error) }
    }

    func addTask(_ model: TaskModel) {
        tasks.insert(model, at: 0)
    }

    func updateTask(_ model: TaskModel) {
        guard let idx = tasks.firstIndex(where: { $0.id == model.id }) else { return }
        tasks[idx] = model
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach {
            let id = filtered[$0].id
            try? core.delete(id: id)
        }
        Task { await loadTasks() }
    }

    func toggleDone(_ model: TaskModel) {
        var m = model; m.isDone.toggle()
        try? core.update(m)
        updateTask(m)
    }
}
