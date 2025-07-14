//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

import Foundation

protocol ToDoListInteractorProtocol: AnyObject {
    func fetchData()
}

final class ToDoListInteractor: ToDoListInteractorProtocol {

    private let networkService: NetworkServiceProtocol?
    weak var presenter: ToDoListPresenterProtocol?

    required init(presenter: ToDoListPresenterProtocol, networkService: NetworkServiceProtocol) {
        self.presenter = presenter
        self.networkService = networkService
    }

    func fetchData() {
        networkService?.fetchData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let toDos):
                DispatchQueue.main.async {
                    self.presenter?.configureView(with: toDos)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.fetchFailed(with: error)
                }
            }
        }
    }
}
