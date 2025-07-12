//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

protocol ToDoListRouterProtocol: AnyObject {
    func navigateToDetailsVC(with selectedToDo: LocalToDoModel)
    func navigateToEditTask(with selectedToDo: LocalToDoModel)
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
    func navigateToDetailsVC(with selectedToDo: LocalToDoModel) {
        let detailsVC = DetailsViewController(selectedToDo: selectedToDo, isEditingVC: false)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }

    func navigateToEditTask(with selectedToDo: LocalToDoModel) {
        let detailsVC = DetailsViewController(selectedToDo: selectedToDo, isEditingVC: true)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }

    func navigateToAddTaskScreen() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.modalPresentationStyle = .pageSheet

        if let sheet = addTaskVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        viewController?.present(addTaskVC, animated: true)
    }
}
