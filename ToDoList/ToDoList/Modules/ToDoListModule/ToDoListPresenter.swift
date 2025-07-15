//
//  ToDoListPresenterProtocol.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

import Foundation

protocol ToDoListPresenterProtocol: AnyObject {
    var router: ToDoListRouterProtocol? { get set}
    var toDos: [LocalToDoModel] { get set }
    var filteredToDos: [LocalToDoModel] { get set }

    func configureView(with todos: NetworkToDoListModel)
    func navigateToDetailsVC(with selectedToDo: LocalToDoModel)
    func navigateToEditTask(with selectedToDo: LocalToDoModel)
    func navigateToAddTaskScreen()
    func triggerDataLoading()
    func fetchFailed(with error: NetworkErrors)
    func deleteTaskFromArray(itemToDelete: LocalToDoModel)
}

final class ToDoListPresenter: ToDoListPresenterProtocol {

    // MARK: - Constants
    weak var view: ToDoListViewControllerProtocol?
    var router: ToDoListRouterProtocol?
    var interactor: ToDoListInteractorProtocol?
    var toDos = [LocalToDoModel]()
    var filteredToDos = [LocalToDoModel]()

    // MARK: - Initializers
    required init(view: ToDoListViewControllerProtocol) {
        self.view = view
    }

    // MARK: - Pubic methods
    func configureView(with todos: NetworkToDoListModel) {
        todos.todos.forEach {
            let todo = LocalToDoModel(
                id: UUID(),
                header: "Задача \($0.id)",
                description: $0.todo,
                date: Date().convertDateToString(),
                isCompleted: $0.completed
            )
            toDos.append(todo)
        }
        view?.hideLoading()
        view?.showToDoList()
    }

    func navigateToDetailsVC(with selectedToDo: LocalToDoModel) {
        router?.navigateToDetailsVC(with: selectedToDo)
    }

    func navigateToEditTask(with selectedToDo: LocalToDoModel) {
        router?.navigateToEditTask(with: selectedToDo)
    }

    func navigateToAddTaskScreen() {
        router?.navigateToAddTaskScreen()
    }

    func triggerDataLoading() {
        view?.startLoadingIndicator()
        interactor?.fetchData()
    }

    func fetchFailed(with error: NetworkErrors) {
        view?.showError(message: error.userMessage) { [weak self] in
            guard let self else { return }
            self.triggerDataLoading()
        }
    }

    func deleteTaskFromArray(itemToDelete: LocalToDoModel) {
        toDos.removeAll { $0.id == itemToDelete.id }
        view?.showToDoList()
    }
}
