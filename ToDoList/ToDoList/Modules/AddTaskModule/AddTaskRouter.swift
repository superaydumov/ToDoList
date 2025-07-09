//
//  AddTaskRouter.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 09.07.2025.
//

protocol AddTaskRouterProtocol: AnyObject {
    func dismissVC()
}

final class AddTaskRouter: AddTaskRouterProtocol {

    // MARK: - Constants
    weak var viewController: AddTaskViewController?

    // MARK: - Initializers
    required init(viewController: AddTaskViewController) {
        self.viewController = viewController
    }

    // MARK: Public methods
    func dismissVC() {
        viewController?.dismiss(animated: true)
    }
}
