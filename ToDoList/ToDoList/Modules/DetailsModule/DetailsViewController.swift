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
    let configurator: DetailsConfiguratorProtocol = DetailsConfigurator()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        configurator.configure(with: self)
        presenter?.configureView()
    }
}

    // MARK: - DetailsViewControllerProtocol
extension DetailsViewController: DetailsViewControllerProtocol {

    func showDetails() {
        // TODO: add code to update ToDoList
    }
}
