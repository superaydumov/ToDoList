//
//  ToDoListConfigurator.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

protocol ToDoListConfiguratorProtocol: AnyObject {
    func configure(with viewController: ToDoListViewController)
}

final class ToDoListConfigurator: ToDoListConfiguratorProtocol {

    func configure(with viewController: ToDoListViewController) {
        let presenter = ToDoListPresenter(view: viewController)
        let networkService = NetworkService()
        let interactor = ToDoListInteractor(presenter: presenter, networkService: networkService)
        let router = ToDoListRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
