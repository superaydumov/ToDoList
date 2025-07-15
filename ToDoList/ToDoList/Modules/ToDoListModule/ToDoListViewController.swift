//
//  ViewController.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 25.06.2025.
//
// swiftlint:disable file_length

import UIKit

protocol ToDoListViewControllerProtocol: AnyObject {
    func showToDoList()
    func showError(message: String, retry: @escaping () -> Void)
    func startLoadingIndicator()
    func hideLoading()
}

private enum PlugState {
    case emptyList
    case notFound
    case hidden
}

final class ToDoListViewController: UIViewController {

    // MARK: - Stored properties
    var presenter: ToDoListPresenterProtocol?
    let configurator: ToDoListConfiguratorProtocol = ToDoListConfigurator()

    private var searchController: UISearchController?
    private var bottomLabelText: String?
    private var isFiltering: Bool {
        return (searchController?.isActive ?? true) && !(searchController?.searchBar.text?.isEmpty ?? true)
    }

    // MARK: - Computed properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .clear
        tableView.separatorColor = .appWhiteOpacity
        tableView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            ToDoListTableViewCell.self,
            forCellReuseIdentifier: ToDoListTableViewCell.reuseIdentifier
        )
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )

        return tableView
    }()

    private lazy var bottomView: UIView = {
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.appWhiteOpacity.cgColor
        topBorder.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: 1
        )

        let view = UIView()
        view.backgroundColor = .appGrayBackground
        view.layer.addSublayer(topBorder)

        return view
    }()

    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .appWhite
        label.textAlignment = .natural
//        label.text = "\(presenter?.toDos.count ?? .zero) "

        return label
    }()

    private lazy var bottomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.bottomButton, for: .normal)
        button.addTarget(self, action: #selector(bottomButtonDidTap), for: .touchUpInside)

        return button
    }()

    private lazy var plugView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var plugLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .appWhite
        label.textAlignment = .natural
        label.text = "Список задач пуст"

        return label
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center

        return stack
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.color = .appAccent

        return indicator
    }()

    private lazy var loadingContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.appBackground.withAlphaComponent(0.8)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true

        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground

        configurator.configure(with: self)

        navBarSetup()
        setupSubViews()
        setupConstraints()
        updatePlugs(.emptyList)
        presenter?.triggerDataLoading()
    }
}

// MARK: - Private methods
private extension ToDoListViewController {

    func setupSubViews() {
        [
            verticalStack,
            tableView,
            bottomView,
            loadingContainer
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [plugView, plugLabel].forEach {
            verticalStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [bottomLabel, bottomButton].forEach {
            bottomView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        loadingContainer.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            plugView.widthAnchor.constraint(equalToConstant: 200),
            plugView.heightAnchor.constraint(equalToConstant: 200),

            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),

            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),

            bottomLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.5),
            bottomLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15.5),

            bottomButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15.5),
            bottomButton.centerYAnchor.constraint(equalTo: bottomLabel.centerYAnchor),
            bottomButton.heightAnchor.constraint(equalToConstant: 22),
            bottomButton.widthAnchor.constraint(equalToConstant: 22),

            loadingContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingContainer.widthAnchor.constraint(equalToConstant: 60),
            loadingContainer.heightAnchor.constraint(equalToConstant: 60),

            loadingIndicator.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingContainer.centerYAnchor)
        ])
    }

    func navBarSetup() {
        guard let navBar = navigationController?.navigationBar else { return }
        title = "Задачи"
        navBar.prefersLargeTitles = true
        navBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.appWhite
        ]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.appWhite]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appWhite]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .appAccent

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

    func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
            guard let toDo = self.presenter?.toDos[indexPath.row] else { return }
            self.presenter?.navigateToEditTask(with: toDo)
            addHapticFeedback()
        }

        let shareAction = UIAction(
            title: "Поделиться",
            image: UIImage(
                systemName: "square.and.arrow.up"
            )
        ) { [weak self] _ in
            guard let self else { return }
            let itemToShare = "Посмотри на эту задачу \(indexPath.row)"

            let activityVC = UIActivityViewController(activityItems: [itemToShare], applicationActivities: nil)
            if let popoverController = activityVC.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }

            self.present(activityVC, animated: true)
            addHapticFeedback()
        }

        let deleteAction = UIAction(
            title: "Удалить",
            image: UIImage(systemName: "trash"),
            attributes: .destructive) { _ in
                guard let toDo = self.presenter?.toDos[indexPath.row] else { return }
                self.presenter?.deleteTaskFromArray(itemToDelete: toDo)
                addHapticFeedback()

                // TODO: add code sync with CoreData (inside presenter)
            }

        return UIMenu(
            children: [
                editAction,
                shareAction,
                deleteAction
            ]
        )
    }

    func getIndexPathFromConfiguration(with configuration: UIContextMenuConfiguration) -> IndexPath? {
        guard let identifier = configuration.identifier as? String else { return nil }
        let components = identifier.components(separatedBy: ":")

        guard let rowString = components.first,
              let sectionString = components.last,
              let row = Int(rowString),
              let section = Int(sectionString) else { return nil }

        return IndexPath(row: row, section: section)
    }

    func updatePlugs(_ state: PlugState) {
        switch state {
        case .emptyList:
            plugView.image = .emptyPlug
            plugLabel.text = "Список задач пуст"
            verticalStack.isHidden = false
            tableView.isHidden = true

        case .notFound:
            plugView.image = .notFoundPlug
            plugLabel.text = "Таких задач не найдено"
            verticalStack.isHidden = false
            tableView.isHidden = true

        case .hidden:
            plugView.image = nil
            plugLabel.text = nil
            verticalStack.isHidden = true
            tableView.isHidden = false
        }
    }

    // MARK: - Actions
    @objc func bottomButtonDidTap() {
        presenter?.navigateToAddTaskScreen()
        addHapticFeedback()
    }
}

    // MARK: - ToDoListViewControllerProtocol
extension ToDoListViewController: ToDoListViewControllerProtocol {

    func showToDoList() {
        let count = presenter?.toDos.count ?? 0

        if count == 0 {
            updatePlugs(.emptyList)
        } else {
            updatePlugs(.hidden)
        }

        bottomLabel.text = "\(count) \(pluralizedTaskWord(for: count))"
        tableView.reloadData()
    }

    func showError(message: String, retry: @escaping () -> Void) {
        showAlert(message: message, retryAction: retry)
    }

    func startLoadingIndicator() {
        loadingContainer.isHidden = false
        loadingIndicator.startAnimating()
    }

    func hideLoading() {
        loadingIndicator.stopAnimating()
        loadingContainer.isHidden = true
    }
}

    // MARK: - UISearchController
extension ToDoListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let presenter,
              let searchText = searchController.searchBar.text?.lowercased()
        else { return }

        let isSearching = !searchText.isEmpty

        if isSearching {
            presenter.filteredToDos = presenter.toDos.filter {
                $0.header.lowercased().contains(searchText) ||
                $0.description.lowercased().contains(searchText) ||
                $0.date.lowercased().contains(searchText)
            }

            updatePlugs(presenter.filteredToDos.isEmpty ? .notFound : .hidden)
        } else {
            presenter.filteredToDos = presenter.toDos

            let isEmpty = presenter.toDos.isEmpty
            updatePlugs(isEmpty ? .emptyList : .hidden)
        }

        tableView.reloadData()
    }
}

    // MARK: - UITextFieldDelegate
extension ToDoListViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        textField.textColor = .appWhite
        return true
    }
}

    // MARK: - UITableViewDataSource
extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { return .zero }
        return isFiltering ? presenter.filteredToDos.count : presenter.toDos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoListTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ToDoListTableViewCell else { return UITableViewCell() }

        var viewModel: LocalToDoModel
        if isFiltering {
            viewModel = presenter?.filteredToDos[indexPath.row] ?? LocalToDoModel(
                id: UUID(),
                header: "",
                description: "",
                date: "",
                isCompleted: false
            )
        } else {
            viewModel = presenter?.toDos[indexPath.row] ?? LocalToDoModel(
                id: UUID(),
                header: "",
                description: "",
                date: "",
                isCompleted: false
            )
        }

        cell.configureCell(with: viewModel)

        cell.checkMarkButtonTapped = { [weak self] in
            guard let self else { return }
            viewModel.isCompleted.toggle()
            self.presenter?.toDos[indexPath.row] = viewModel
            // TODO: notify presenter to save updated data

            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        return cell
    }
}

    // MARK: - UITableViewDelegate
extension ToDoListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let selectedToDo = presenter?.toDos[indexPath.row] else { return }
        presenter?.navigateToDetailsVC(with: selectedToDo)
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.row):\(indexPath.section)" as NSString

        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            return self.makeContextMenu(for: indexPath)
        }
    }

    func tableView(
        _ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = getIndexPathFromConfiguration(with: configuration),
              let cell = tableView.cellForRow(at: indexPath) as? ToDoListTableViewCell
        else { return nil }

        cell.setPreviewActive(true)

        return UITargetedPreview(view: cell.preview)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplayContextMenu configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        guard let indexPath = getIndexPathFromConfiguration(with: configuration),
              let cell = tableView.cellForRow(at: indexPath) as? ToDoListTableViewCell
        else { return }

        animator?.addAnimations {
            cell.setPreviewActive(true)
            cell.preview.alpha = 0.0
            cell.preview.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

            UIView.animate(withDuration: 0.5) {
                cell.preview.alpha = 1.0
                cell.preview.transform = .identity
            }
        }
    }

    // swiftlint:disable multiple_closures_with_trailing_closure

    func tableView(
        _ tableView: UITableView,
        willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        guard let indexPath = getIndexPathFromConfiguration(with: configuration),
              let cell = tableView.cellForRow(at: indexPath) as? ToDoListTableViewCell
        else { return }

        animator?.addAnimations {
            UIView.animate(withDuration: 0.7, animations: {
                cell.preview.alpha = 0.0
                cell.preview.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                cell.setPreviewActive(false)
                cell.preview.alpha = 1.0
                cell.preview.transform = .identity
            }
        }
    }

    // swiftlint:enable multiple_closures_with_trailing_closure

}
