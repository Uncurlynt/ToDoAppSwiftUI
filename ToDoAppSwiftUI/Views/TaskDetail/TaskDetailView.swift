//
//  TaskDetailView.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 30.05.2025.
//

import SwiftUI
import CoreData

struct TaskDetailView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: TaskDetailViewModel

    init(task: TaskModel? = nil,
         onSave:   ((TaskModel) -> Void)? = nil,
         onDelete: ((NSManagedObjectID) -> Void)? = nil) {

        let m = TaskDetailViewModel(task: task)
        m.onSave   = onSave
        m.onDelete = onDelete
        _vm = StateObject(wrappedValue: m)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                ZStack(alignment: .topLeading) {
                    if vm.title.isEmpty {
                        Text("Название")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $vm.title)
                        .font(.system(size: 28, weight: .bold))
                        .frame(minHeight: 40)
                        .padding(.horizontal, -5)
                        .padding(.top, -8)
                        .scrollContentBackground(.hidden)
                }

                Text(vm.createdAtString)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Divider().padding(.vertical, 4)

                ZStack(alignment: .topLeading) {
                    if vm.desc.isEmpty {
                        Text("Текст заметки")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $vm.desc)
                        .font(.system(size: 18))
                        .frame(minHeight: 160)
                        .scrollContentBackground(.hidden)
                }
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .onDisappear { vm.autoSaveIfPossible() }
        .navigationBarBackButtonHidden(true)

        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Задачи")
                    }
                }
                .foregroundColor(.yellow)
            }

        }
    }
}
