//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 06.07.2025.
//

import Foundation

struct ToDoListModel: Codable {
    var todos: [ToDo]
    var total: Int
    let skip: Int
    let limit: Int
}

struct ToDo: Codable {
    let id: Int
    let todo: String
    var completed: Bool
    let userId: Int
}
