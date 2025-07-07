//
//  DetailsViewController.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 27.06.2025.
//

import UIKit

protocol DetailsViewControllerProtocol: AnyObject {
    func showDetails()
}

final class DetailsViewController: UIViewController {

    var presenter: DetailsPresenterProtocol?
    var selectedToDo: ToDo
    let configurator: DetailsConfiguratorProtocol = DetailsConfigurator()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        configurator.configure(with: self)
        presenter?.configureView()
        print(selectedToDo)
    }

    init(selectedToDo: ToDo) {
        self.selectedToDo = selectedToDo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    // MARK: - DetailsViewControllerProtocol
extension DetailsViewController: DetailsViewControllerProtocol {

    func showDetails() {
        // TODO: add code to update ToDoList
    }
}
