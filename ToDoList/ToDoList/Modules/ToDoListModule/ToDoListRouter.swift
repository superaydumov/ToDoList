//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

protocol ToDoListRouterProtocol: AnyObject {
    func navigateToDetailsVC()
}

final class ToDoListRouter: ToDoListRouterProtocol {

    // MARK: - Constants
    weak var viewController: ToDoListViewController?

    // MARK: - Initializers
    required init(viewController: ToDoListViewController) {
        self.viewController = viewController
    }

    // MARK: - Public methods
    func navigateToDetailsVC() {
        let detailsVC = DetailsViewController()
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
        print("\(String(describing: viewController?.navigationController))")
    }
}
