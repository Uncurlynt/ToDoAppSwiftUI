//
//  ToDoAppSwiftUIApp.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 29.05.2025.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    @StateObject private var coreData = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TaskListView()
            }
            .environmentObject(coreData)
            .task { await coreData.bootstrapIfNeeded() }
        }
    }
}

