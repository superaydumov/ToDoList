//
//  DetailsConfigurator.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 30.06.2025.
//

protocol DetailsConfiguratorProtocol: AnyObject {
    func configure(with viewController: DetailsViewController)
}

final class DetailsConfigurator: DetailsConfiguratorProtocol {

    func configure(with viewController: DetailsViewController) {
        let presenter = DetailsPresenter(view: viewController)
        let interactor = DetailsInteractor(presenter: presenter)
        let router = DetailsRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
