//
//  DetailsRouter.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 30.06.2025.
//

protocol DetailsRouterProtocol: AnyObject {
    // TODO: add needed methods
}

final class DetailsRouter: DetailsRouterProtocol {

    // MARK: - Constants
    weak var viewController: DetailsViewController?

    // MARK: - Initializers
    required init(viewController: DetailsViewController) {
        self.viewController = viewController
    }
}
