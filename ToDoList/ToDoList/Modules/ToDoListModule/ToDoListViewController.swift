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

    private var searchController: UISearchController?

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
        view.backgroundColor = .appBackground

        configurator.configure(with: self)
        presenter?.configureView()

        navBarSetup()
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

    private func navBarSetup() {
        guard let navBar = navigationController?.navigationBar else { return }
        title = "Задачи"
        navBar.prefersLargeTitles = true
        navBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.appWhite
        ]

        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.tintColor = UIColor.appAccent

        guard let textField = searchController?.searchBar.searchTextField else { return }
        textField.delegate = self
        textField.backgroundColor = UIColor.appGrayBackground

        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.appWhiteOpacity]
        )
        textField.keyboardAppearance = .dark

        if let leftIconView = textField.leftView as? UIImageView {
            leftIconView.tintColor = UIColor.appWhiteOpacity
            leftIconView.image = leftIconView.image?.withRenderingMode(.alwaysTemplate)
        }

        if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
            clearButton.tintColor = UIColor.appWhiteOpacity
            if let image = clearButton.image(for: .normal) {
                clearButton.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        }

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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

    // MARK: - UISearchController
extension ToDoListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text

        // TODO: add code to filter data
    }
}

    // MARK: - UITextFieldDelegate
extension ToDoListViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        textField.textColor = UIColor.appWhite
        return true
    }
}
