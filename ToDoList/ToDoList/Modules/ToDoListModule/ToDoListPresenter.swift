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
    func navigateToDetailsVC(with selectedToDo: ToDo)
    func navigateToEditTask(with selectedToDo: ToDo)
    func navigateToAddTaskScreen()
    func triggerDataLoading()
    func deleteTaskFromArray(itemToDelete: ToDo)
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

    func navigateToDetailsVC(with selectedToDo: ToDo) {
        router?.navigateToDetailsVC(with: selectedToDo)
    }

    func navigateToEditTask(with selectedToDo: ToDo) {
        router?.navigateToEditTask(with: selectedToDo)
    }

    func navigateToAddTaskScreen() {
        router?.navigateToAddTaskScreen()
    }

    func triggerDataLoading() {
        interactor?.fetchData()
    }

    func deleteTaskFromArray(itemToDelete: ToDo) {
        guard var model = toDoListModel else { return }

        model.todos.removeAll { $0.id == itemToDelete.id }
        model.total = model.todos.count

        toDoListModel = model

        view?.showToDoList()
    }
}
