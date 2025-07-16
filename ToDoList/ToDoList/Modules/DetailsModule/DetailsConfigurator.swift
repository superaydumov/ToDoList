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
        let presenter = DetailsPresenter()
        let interactor = DetailsInteractor(presenter: presenter)

        viewController.presenter = presenter
        presenter.interactor = interactor
    }
}
