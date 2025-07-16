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

extension LocalToDoModel {
    init?(entity: ToDoEntity) {
        guard let id = entity.value(forKey: "id") as? UUID,
              let header = entity.value(forKey: "header") as? String,
              let description = entity.value(forKey: "toDoDescription") as? String,
              let date = entity.value(forKey: "date") as? String
        else {
            return nil
        }

        self.id = id
        self.header = header
        self.description = description
        self.date = date
        self.isCompleted = entity.isCompleted
    }
}

extension ToDoEntity {
    func update(from model: LocalToDoModel) {
        self.id = model.id
        self.header = model.header
        self.toDoDescription = model.description
        self.date = model.date
        self.isCompleted = model.isCompleted
    }
}
