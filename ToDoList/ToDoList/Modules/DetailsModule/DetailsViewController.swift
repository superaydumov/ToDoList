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

    // MARK: - Stored properties
    var presenter: DetailsPresenterProtocol?
    var selectedToDo: LocalToDoModel
    var isEditingVC: Bool
    let configurator: DetailsConfiguratorProtocol = DetailsConfigurator()

    // MARK: - Computed properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true

        return scrollView
    }()

    private lazy var upperTextView: UITextView = {
        let view = UITextView()
        view.inputAccessoryView = toolbar
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 34, weight: .bold)
        view.textColor = .appWhite
        view.backgroundColor = .clear
        view.tintColor = .appAccent
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0

        return view
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .appWhiteOpacity
        label.tintColor = .appAccent

        return label
    }()

    private lazy var bottomTextView: UITextView = {
        let view = UITextView()
        view.inputAccessoryView = toolbar
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 16)
        view.textColor = .appWhite
        view.backgroundColor = .clear
        view.tintColor = .appAccent
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0

        return view
    }()

    private lazy var toolbar = UIToolbar(
        frame: CGRect(
            x: 0,
            y: view.bounds.height,
            width: view.bounds.width,
            height: 48
        )
    )

    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appAccent
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.appGray, for: .normal)
        button.addTarget(
            self,
            action: #selector(enterButtonDidTap(sender:)),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        navigationItem.largeTitleDisplayMode = .never

        configurator.configure(with: self)
        presenter?.configureView()

        setupSubviews()
        setupConstraints()
        configureVCData()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Initializers
    init(selectedToDo: LocalToDoModel, isEditingVC: Bool) {
        self.selectedToDo = selectedToDo
        self.isEditingVC = isEditingVC
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func configureVCData() {
        dateLabel.text = selectedToDo.date
        upperTextView.text = selectedToDo.header
        bottomTextView.text = selectedToDo.description

        switch isEditingVC {
        case true:
            upperTextView.isEditable = true
            bottomTextView.isEditable = true
            bottomTextView.becomeFirstResponder()
        case false:
            upperTextView.isEditable = false
            bottomTextView.isEditable = false
        }
    }

    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        if isEditingVC {
            toolbar.addSubview(enterButton)
            enterButton.translatesAutoresizingMaskIntoConstraints = false
        }

        [
            upperTextView,
            dateLabel,
            bottomTextView
        ].forEach {
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    // swiftlint:disable line_length

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            upperTextView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            upperTextView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            upperTextView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            upperTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),

            dateLabel.topAnchor.constraint(equalTo: upperTextView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            dateLabel.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),

            bottomTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            bottomTextView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            bottomTextView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            bottomTextView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            bottomTextView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])

        if isEditingVC {
            NSLayoutConstraint.activate([
                enterButton.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor),
                enterButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor),
                enterButton.topAnchor.constraint(equalTo: toolbar.topAnchor),
                enterButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor)
            ])
        }
    }

    // swiftlint:enable line_length

    // MARK: - Actions

    @objc func enterButtonDidTap(sender: AnyObject) {
        let modelToUpdate = LocalToDoModel(
            id: selectedToDo.id,
            header: upperTextView.text ?? "",
            description: bottomTextView.text ?? "",
            date: selectedToDo.date,
            isCompleted: selectedToDo.isCompleted
        )
        presenter?.updateToDo(itemToUpdate: modelToUpdate)
        upperTextView.resignFirstResponder()
        bottomTextView.resignFirstResponder()
        addHapticFeedback()
    }
}

    // MARK: - DetailsViewControllerProtocol
extension DetailsViewController: DetailsViewControllerProtocol {

    func showDetails() {
        // TODO: add code to update ToDoList
    }
}
