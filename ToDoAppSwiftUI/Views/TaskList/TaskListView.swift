//
//  TaskListView.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 30.05.2025.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var vm = TaskListViewModel()

    // выбор строки для навигации
    @State private var selected: TaskModel?
    @State private var showNew  = false

    var body: some View {
        List {
            ForEach(vm.filtered) { task in
                TaskRowView(
                    task: task,
                    onToggle: { vm.toggleDone(task) },
                    onEdit:   { selected = task },
                    onDelete: {
                        if let idx = vm.filtered.firstIndex(of: task) {
                            vm.delete(at: IndexSet(integer: idx))
                        }
                    }
                )
                .contentShape(Rectangle())
                .onTapGesture { selected = task }
            }
            .onDelete { vm.delete(at: $0) }
        }
        .listStyle(.plain)

        .navigationTitle("Задачи")
        .navigationBarTitleDisplayMode(.large)

        .searchable(text: $vm.searchText, prompt: "Поиск")

        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Text(vm.countText).foregroundStyle(.secondary)
                Spacer()
                Button { showNew = true } label: {
                    Image(systemName: "square.and.pencil")
                }
                .tint(.yellow)
            }
        }
        .navigationDestination(item: $selected) { task in
            TaskDetailView(
                task: task,
                onSave:   { vm.updateTask($0) },
                onDelete: { _ in Task { await vm.loadTasks() } }
            )
        }
        .sheet(isPresented: $showNew) {
            NavigationStack {
                TaskDetailView(onSave: { vm.addTask($0) })
            }
        }
    }
}
