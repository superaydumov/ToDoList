//
//  DetailsPresenter.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 30.06.2025.
//

import Foundation

protocol DetailsPresenterProtocol: AnyObject {
    var router: DetailsRouterProtocol? { get set }
    func configureView()
    func updateToDo(itemToUpdate: LocalToDoModel)
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

    func updateToDo(itemToUpdate: LocalToDoModel) {
        interactor?.updateItemInCoreData(item: itemToUpdate)
        NotificationCenter.default.post(name: .toDoListDidChange, object: nil)
    }
}
