//
//  DetailsPresenter.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 30.06.2025.
//

protocol DetailsPresenterProtocol: AnyObject {
    var router: DetailsRouterProtocol? { get set}
    func configureView()
}

final class DetailsPresenter: DetailsPresenterProtocol {

    // MARK: - Constants
    weak var view: DetailsViewControllerProtocol?
    var router: DetailsRouterProtocol?
    var interactor: DetailsInteractorProtocol?

    // MARK: - Initializers
    required init(view: DetailsViewControllerProtocol) {
        self.view = view
    }

    // MARK: - Pubic methods
    func configureView() {
        view?.showDetails()
    }
}
