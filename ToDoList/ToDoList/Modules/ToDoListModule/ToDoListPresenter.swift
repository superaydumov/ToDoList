//
//  ToDoListPresenterProtocol.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

protocol ToDoListPresenterProtocol: AnyObject {
    var router: ToDoListRouterProtocol? { get set}
    var toDoListModel: ToDoListModel? { get set }

    func configureView(with todos: ToDoListModel)
    func navigateToDetailsVC()
    func navigateToAddTaskScreen()
    func triggerDataLoading()
}

final class ToDoListPresenter: ToDoListPresenterProtocol {

    // MARK: - Constants
    weak var view: ToDoListViewControllerProtocol?
    var router: ToDoListRouterProtocol?
    var interactor: ToDoListInteractorProtocol?
    var toDoListModel: ToDoListModel?

    // MARK: - Initializers
    required init(view: ToDoListViewControllerProtocol) {
        self.view = view
    }

    // MARK: - Pubic methods
    func configureView(with todos: ToDoListModel) {
        toDoListModel = todos
        view?.showToDoList()
    }

    func navigateToDetailsVC() {
        router?.navigateToDetailsVC()
    }

    func navigateToAddTaskScreen() {
        router?.navigateToAddTaskScreen()
    }

    func triggerDataLoading() {
        interactor?.fetchData()
    }
}
