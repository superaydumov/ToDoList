//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

protocol ToDoListRouterProtocol: AnyObject {
    func navigateToDetailsVC(with selectedToDo: ToDo)
    func navigateToAddTaskScreen()
}

final class ToDoListRouter: ToDoListRouterProtocol {

    // MARK: - Constants
    weak var viewController: ToDoListViewController?

    // MARK: - Initializers
    required init(viewController: ToDoListViewController) {
        self.viewController = viewController
    }

    // MARK: - Public methods
    func navigateToDetailsVC(with selectedToDo: ToDo) {
        let detailsVC = DetailsViewController(selectedToDo: selectedToDo, isEditingVC: true)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }

    func navigateToAddTaskScreen() {
        let addTaskVC = AddTaskViewController()
        viewController?.present(addTaskVC, animated: true)
    }
}
