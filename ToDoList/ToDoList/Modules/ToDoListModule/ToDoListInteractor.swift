//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

protocol ToDoListInteractorProtocol: AnyObject {
    // TODO: add needed methods
}

final class ToDoListInteractor: ToDoListInteractorProtocol {

    weak var presenter: ToDoListPresenterProtocol?

    required init(presenter: ToDoListPresenterProtocol) {
        self.presenter = presenter
    }
}
