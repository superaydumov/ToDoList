//
//  ToDoListPresenterProtocol.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

protocol ToDoListPresenterProtocol: AnyObject {
    var router: ToDoListRouterProtocol? { get set}
    func configureView()
    func navigateToDetailsVC()
    func navigateToAddTaskScreen()
}

final class ToDoListPresenter: ToDoListPresenterProtocol {

    // MARK: - Constants
    weak var view: ToDoListViewControllerProtocol?
    var router: ToDoListRouterProtocol?
    var interactor: ToDoListInteractorProtocol?

    // MARK: - Initializers
    required init(view: ToDoListViewControllerProtocol) {
        self.view = view
    }

    // MARK: - Pubic methods
    func configureView() {
        view?.showToDoList()
    }

    func navigateToDetailsVC() {
        router?.navigateToDetailsVC()
    }

    func navigateToAddTaskScreen() {
        router?.navigateToAddTaskScreen()
    }
}
