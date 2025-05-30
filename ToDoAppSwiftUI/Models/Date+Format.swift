//
//  Date+Format.swift
//  ToDoAppSwiftUI
//
//  Created by Артемий Андреев  on 30.05.2025.
//

import Foundation

extension Date {
    static let todoFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = .init(identifier: "ru_RU")
        df.dateFormat = "dd/MM/yy"
        return df
    }()

    var shortString: String { Self.todoFormatter.string(from: self) }
}
