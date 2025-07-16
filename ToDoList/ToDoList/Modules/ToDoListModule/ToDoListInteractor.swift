//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 26.06.2025.
//

import Foundation

protocol ToDoListInteractorProtocol: AnyObject {
    func fetchData()
    func deleteItemFromCoreData(item: LocalToDoModel)
}

final class ToDoListInteractor: ToDoListInteractorProtocol {

    private let networkService: NetworkServiceProtocol?
    weak var presenter: ToDoListPresenterProtocol?

    required init(presenter: ToDoListPresenterProtocol, networkService: NetworkServiceProtocol) {
        self.presenter = presenter
        self.networkService = networkService
    }

    func shouldLoadTodos() -> Bool {
        return !UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasLoadedToDos)
    }

    func fetchData() {
        switch shouldLoadTodos() {
        case true:
            networkService?.fetchData { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let toDos):
                    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasLoadedToDos)
                    DispatchQueue.main.async {
                        self.presenter?.configureView(with: toDos)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presenter?.fetchFailed(with: error)
                    }
                }
            }
        case false:
            let savedToDos = CoreDataManager.shared.fetchToDos()
            DispatchQueue.main.async {
                self.presenter?.configureView(with: savedToDos)
            }
        }
    }

    func deleteItemFromCoreData(item: LocalToDoModel) {
        CoreDataManager.shared.deleteToDo(item)
    }
}
