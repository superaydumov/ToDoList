//
//  AddTaskPresenter.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 09.07.2025.
//

protocol AddTaskPresenterProtocol: AnyObject {
    var router: AddTaskRouterProtocol? { get set }
    func dismissViewController()
    func saveNewToDo(todo: NewToDoModel)
}

final class AddTaskPresenter: AddTaskPresenterProtocol {

    // MARK: - Constants
    weak var view: AddTaskViewControllerProtocol?
    var router: AddTaskRouterProtocol?
    var interactor: AddTaskInteractorProtocol?

    // MARK: - Initializers
    required init(view: AddTaskViewControllerProtocol) {
        self.view = view
    }

    // MARK: - Pubic methods
    func dismissViewController() {
        router?.dismissVC()
    }

    func saveNewToDo(todo: NewToDoModel) {
        // TODO: add saving to CoreData
        print(todo)
    }
}
