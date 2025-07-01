//
//  DetaailsInteractor.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 30.06.2025.
//

protocol DetailsInteractorProtocol: AnyObject {
    // TODO: add needed methods
}

final class DetailsInteractor: DetailsInteractorProtocol {

    weak var presenter: DetailsPresenterProtocol?

    required init(presenter: DetailsPresenterProtocol) {
        self.presenter = presenter
    }
}
