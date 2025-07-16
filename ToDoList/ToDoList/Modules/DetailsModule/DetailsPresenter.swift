//
//  DetailsPresenter.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 30.06.2025.
//

import Foundation

protocol DetailsPresenterProtocol: AnyObject {
    func updateToDo(itemToUpdate: LocalToDoModel)
}

final class DetailsPresenter: DetailsPresenterProtocol {

    // MARK: - Constants
    var interactor: DetailsInteractorProtocol?

    // MARK: - Pubic methods
    func updateToDo(itemToUpdate: LocalToDoModel) {
        interactor?.updateItemInCoreData(item: itemToUpdate)
        NotificationCenter.default.post(name: .toDoListDidChange, object: nil)
    }
}
