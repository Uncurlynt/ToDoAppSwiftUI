//
//  TaskRowView.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 30.05.2025.
//

import SwiftUI
import CoreData

struct TaskRowView: View {
    let task: TaskModel
    let onToggle : () -> Void
    let onEdit   : () -> Void
    let onDelete : () -> Void

    private var shareText: String {
        task.taskDescription.isEmpty
          ? task.title
          : "\(task.title)\n\n\(task.taskDescription)"
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button(action: onToggle) {
                Image(systemName: task.isDone ? "checkmark.circle" : "circle")
                    .foregroundStyle(task.isDone ? .yellow : .secondary)
                    .font(.system(size: 22))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isDone)
                    .foregroundStyle(task.isDone ? .secondary : .primary)

                if !task.taskDescription.isEmpty {
                    Text(task.taskDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Text(task.createdAt.shortString)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
        .contextMenu {
            Button("Редактировать", systemImage: "pencil") { onEdit() }
            ShareLink(item: shareText) {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }
            Divider()
            Button(role: .destructive, action: onDelete) {
                Label("Удалить", systemImage: "trash")
            }
        }
    }
}
