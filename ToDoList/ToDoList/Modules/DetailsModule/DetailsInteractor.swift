//
//  DetailsInteractor.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 30.06.2025.
//

protocol DetailsInteractorProtocol: AnyObject {
    func updateItemInCoreData(item: LocalToDoModel)
}

final class DetailsInteractor: DetailsInteractorProtocol {

    weak var presenter: DetailsPresenterProtocol?

    required init(presenter: DetailsPresenterProtocol) {
        self.presenter = presenter
    }

    func updateItemInCoreData(item: LocalToDoModel) {
        CoreDataManager.shared.updateToDo(item)
    }
}
