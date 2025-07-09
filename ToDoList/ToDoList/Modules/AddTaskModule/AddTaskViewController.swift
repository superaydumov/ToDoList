//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 04.07.2025.
//

import UIKit

protocol AddTaskViewControllerProtocol: AnyObject {
    // TODO: add needed methods
}

final class AddTaskViewController: UIViewController {

    // MARK: - Stored properties
    var presenter: AddTaskPresenter?
    let configurator = AddTaskConfigurator()

    private var headerCharactersNumber = 0
    private var descriptionCharactersNumber = 0
    private let headerMinNumber = 5
    private let descriptionMinNumber = 10
    private var selectedDate: String? {
        didSet {
            enterButtonUpdate()
        }
    }

    // MARK: - Computed propertie

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .appWhite
        label.textAlignment = .center
        label.text = "Создание новой задачи"

        return label
    }()

    private lazy var headerTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название",
            attributes: [.foregroundColor: UIColor.appGray]
        )
        textField.textColor = .appBackground
        textField.tintColor = .appAccent
        textField.backgroundColor = .appWhite
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 16)
        textField.indentSize(leftSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        textField.delegate = self

        return textField
    }()

    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Добавьте описание",
            attributes: [.foregroundColor: UIColor.appGray]
        )
        textField.textColor = .appBackground
        textField.tintColor = .appAccent
        textField.backgroundColor = .appWhite
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 16)
        textField.indentSize(leftSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        textField.delegate = self

        return textField
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .appWhite
        label.textAlignment = .natural
        label.text = "Выберите дату:"

        return label
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ru_RUS")
        datePicker.layer.backgroundColor = UIColor.white.cgColor
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.layer.cornerRadius = 16
        datePicker.layer.masksToBounds = true
        datePicker.tintColor = .appAccent

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(didTapDateButton(sender:)), for: .valueChanged)

        return datePicker
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill

        return stack
    }()

    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitle("Сохранить", for: .normal)
        button.layer.cornerRadius = 16
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
        view.backgroundColor = .appGrayBackground

        configurator.configure(with: self)
        setupSubViews()
        setupConstraints()
        enterButtonUpdate()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Private methods

    private func setupSubViews() {
        [
            nameLabel,
            headerTextField,
            descriptionTextField,
            stackView,
            enterButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [dateLabel, datePicker].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),

            headerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            headerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            headerTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            headerTextField.heightAnchor.constraint(equalToConstant: 48),

            descriptionTextField.leadingAnchor.constraint(equalTo: headerTextField.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: headerTextField.trailingAnchor),
            descriptionTextField.topAnchor.constraint(equalTo: headerTextField.bottomAnchor, constant: 32),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 48),

            stackView.leadingAnchor.constraint(equalTo: headerTextField.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 32),

            enterButton.leadingAnchor.constraint(equalTo: headerTextField.leadingAnchor),
            enterButton.trailingAnchor.constraint(equalTo: headerTextField.trailingAnchor),
            enterButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 48),
            enterButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func enterButtonUpdate() {
        let headerCount = headerTextField.text?.count ?? 0
        let descriptionCount = descriptionTextField.text?.count ?? 0

        if headerCount >= headerMinNumber, descriptionCount >= descriptionMinNumber, selectedDate != nil {
            enterButton.isEnabled = true
            enterButton.backgroundColor = .appAccent
            enterButton.setTitleColor(.appGray, for: .normal)
        } else {
            enterButton.isEnabled = false
            enterButton.backgroundColor = .appGray
            enterButton.setTitleColor(.appWhiteOpacity, for: .normal)
        }
    }

    // MARK: - Actions
    @objc private func textFieldDidChange(sender: UITextField) {
        guard let textCount = sender.text?.count else { return }

        switch sender {
        case headerTextField:
            headerCharactersNumber = textCount
            sender.validateText(
                textField: sender,
                textCount: textCount,
                minCount: headerMinNumber,
                borderWidth: 2
            )
        case descriptionTextField:
            descriptionCharactersNumber = textCount
            sender.validateText(
                textField: sender,
                textCount: textCount,
                minCount: descriptionMinNumber,
                borderWidth: 2
            )
        default:
            break
        }

        enterButtonUpdate()
    }

    @objc private func didTapDateButton(sender: UIDatePicker) {
        selectedDate = sender.date.convertDateToString()
    }

    @objc func enterButtonDidTap(sender: AnyObject) {
        let modelToSave = NewToDoModel(
            header: headerTextField.text ?? "",
            description: descriptionTextField.text ?? "",
            date: selectedDate ?? "",
            isCompleted: false
        )
        presenter?.saveNewToDo(todo: modelToSave)
        presenter?.dismissViewController()
        addHapticFeedback()
    }
}

    // MARK: - AddTaskViewControllerProtocol
extension AddTaskViewController: AddTaskViewControllerProtocol {
    // TODO: add needed methods
}

    // MARK: - UITextFieldDelegate

extension AddTaskViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return false
    }
}
