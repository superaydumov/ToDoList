//
//  AddTaskConfigurator.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 09.07.2025.
//

protocol AddTaskConfiguratorProtocol: AnyObject {
    func configure(with viewController: AddTaskViewController)
}

final class AddTaskConfigurator: AddTaskConfiguratorProtocol {

    func configure(with viewController: AddTaskViewController) {
        let presenter = AddTaskPresenter(view: viewController)
        let interactor = AddTaskInteractor(presenter: presenter)
        let router = AddTaskRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
