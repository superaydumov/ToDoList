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

    func configureView(with networkModel: NetworkToDoListModel)
    func configureView(with localToDos: [LocalToDoModel])
    func navigateToDetailsVC(with selectedToDo: LocalToDoModel)
    func navigateToEditTask(with selectedToDo: LocalToDoModel)
    func navigateToAddTaskScreen()
    func triggerDataLoading()
    func fetchFailed(with error: NetworkErrors)
    func deleteTaskFromArray(itemToDelete: LocalToDoModel)
    func updateToDo(itemToUpdate: LocalToDoModel)
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleToDoListChange),
            name: .toDoListDidChange,
            object: nil
        )
    }

    // MARK: - Pubic methods
    func configureView(with networkModel: NetworkToDoListModel) {
        networkModel.todos.forEach {
            let todo = LocalToDoModel(
                id: UUID(),
                header: "Задача \($0.id)",
                description: $0.todo,
                date: Date().convertDateToString(),
                isCompleted: $0.completed
            )
            CoreDataManager.shared.saveToDo(todo)
            toDos.append(todo)
        }
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.view?.showToDoList()
        }
    }

    func configureView(with localToDos: [LocalToDoModel]) {
        toDos = localToDos
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
        view?.hideLoading()
        view?.showError(message: error.userMessage) { [weak self] in
            guard let self else { return }
            self.triggerDataLoading()
        }
    }

    func deleteTaskFromArray(itemToDelete: LocalToDoModel) {
        toDos.removeAll { $0.id == itemToDelete.id }
        filteredToDos.removeAll { $0.id == itemToDelete.id }
        interactor?.deleteItemFromCoreData(item: itemToDelete)
        DispatchQueue.main.async {
            self.view?.showToDoList()
        }
    }

    func updateToDo(itemToUpdate: LocalToDoModel) {
        interactor?.updateItemInCoreData(item: itemToUpdate)
    }

    @objc private func handleToDoListChange() {
        toDos = CoreDataManager.shared.fetchToDos()
        DispatchQueue.main.async {
            self.view?.showToDoList()
        }
    }
}
