//
//  AddTaskInteractorProtocol.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 09.07.2025.
//

protocol AddTaskInteractorProtocol: AnyObject {
    func saveItemToCoreData(item: LocalToDoModel)
}

final class AddTaskInteractor: AddTaskInteractorProtocol {

    weak var presenter: AddTaskPresenterProtocol?

    required init(presenter: AddTaskPresenterProtocol) {
        self.presenter = presenter
    }

    func saveItemToCoreData(item: LocalToDoModel) {
        CoreDataManager.shared.saveToDo(item)
    }
}
