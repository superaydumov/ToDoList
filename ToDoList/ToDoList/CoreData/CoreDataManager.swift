//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 15.07.2025.
//

import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    private let context: NSManagedObjectContext

    private init() {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed loading store: \(error)")
            }
        }
        self.context = container.viewContext
    }

    func saveToDo(_ model: LocalToDoModel) {
        let entity = ToDoEntity(context: context)
        entity.update(from: model)
        saveContext()
    }

    func fetchToDos() -> [LocalToDoModel] {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        guard let result = try? context.fetch(request) else { return [] }

        return result.compactMap { LocalToDoModel(entity: $0) }
    }

    func deleteToDo(_ model: LocalToDoModel) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)

        if let result = try? context.fetch(request), let entity = result.first {
            context.delete(entity)
            saveContext()
        }
    }

    func updateToDo(_ model: LocalToDoModel) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)

        if let result = try? context.fetch(request), let entity = result.first {
            entity.update(from: model)
            saveContext()
        }
    }

    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
