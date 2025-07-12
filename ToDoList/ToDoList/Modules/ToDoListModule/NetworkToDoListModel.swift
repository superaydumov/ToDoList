//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 06.07.2025.
//

import Foundation

struct NetworkToDoListModel: Codable {
    var todos: [NetworkToDo]
    var total: Int
    let skip: Int
    let limit: Int
}

struct NetworkToDo: Codable {
    let id: Int
    let todo: String
    var completed: Bool
    let userId: Int
}
