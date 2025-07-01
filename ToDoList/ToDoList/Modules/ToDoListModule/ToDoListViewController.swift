//
//  ViewController.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 25.06.2025.
//

import UIKit

protocol ToDoListViewControllerProtocol: AnyObject {
    func showToDoList()
}

final class ToDoListViewController: UIViewController {

    // MARK: - Constants
    var presenter: ToDoListPresenterProtocol?
    let configurator: ToDoListConfiguratorProtocol = ToDoListConfigurator()

    // MARK: - Computed properties
    private lazy var testButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Second VC", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray

        configurator.configure(with: self)
        presenter?.configureView()
        setupSubViews()
        setupConstraints()
    }

    // MARK: - Private methods
    private func setupSubViews() {
        [
            testButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            testButton.widthAnchor.constraint(equalToConstant: 150),
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func buttonDidTap() {
        presenter?.navigateToDetailsVC()
    }
}

    // MARK: - ToDoListViewControllerProtocol
extension ToDoListViewController: ToDoListViewControllerProtocol {

    func showToDoList() {
        // TODO: add code to update ToDoList
    }
}
