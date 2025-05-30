//
//  TodosResponse.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 30.05.2025.
//

struct TodosResponse: Decodable {
    let todos: [TodoItem]
}

struct TodoItem: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
