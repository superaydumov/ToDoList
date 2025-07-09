//
//  NewToDoModel.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 10.07.2025.
//

struct NewToDoModel: Codable {
    let header: String
    let description: String
    let date: String
    let isCompleted: Bool
}
