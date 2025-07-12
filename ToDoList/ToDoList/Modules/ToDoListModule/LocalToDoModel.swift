//
//  NewToDoModel.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 10.07.2025.
//

import Foundation

struct LocalToDoModel: Codable, Equatable {
    let id: UUID
    var header: String
    var description: String
    let date: String
    var isCompleted: Bool
}
