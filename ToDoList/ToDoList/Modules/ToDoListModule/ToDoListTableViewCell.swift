//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 05.07.2025.
//

import UIKit

final class ToDoListTableViewCell: UITableViewCell {

    // MARK: - Stored properties
    static let reuseIdentifier = "ToDoListTableViewCell"
    var checkMarkButtonTapped: (() -> Void)?
    var preview: UIView {
        return verticalStack
    }

    // MARK: - Computed properties
    private lazy var cellCheckMark: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(checkMarkDidTap), for: .touchUpInside)

        return button
    }()

    private lazy var cellMainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .natural

        return label
    }()

    private lazy var cellDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textAlignment = .natural

        return label
    }()

    private lazy var cellDataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .appWhiteOpacity

        return label
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

        return stack
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear
        self.contentView.backgroundColor = .appBackground
        self.selectionStyle = .none

        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(with viewModel: ToDo) {
        let image: UIImage = viewModel.completed ? .checkMarkFilled : .checkMarkEmpty
        cellCheckMark.setImage(image, for: .normal)

        let today = Date()
        cellDataLabel.text = today.convertDateToString()

        let cellMainLabelText = "Задача \(viewModel.id)"
        let cellDescriptionLabelText = viewModel.todo
        switch viewModel.completed {
        case true:
            cellMainLabel.attributedText = addStrikethrough(to: cellMainLabelText)
            cellMainLabel.textColor = .appWhiteOpacity
            cellDescriptionLabel.attributedText = addStrikethrough(to: cellDescriptionLabelText)
            cellDescriptionLabel.textColor = .appWhiteOpacity
        case false:
            cellMainLabel.attributedText = nil
            cellMainLabel.text = cellMainLabelText
            cellMainLabel.textColor = .appWhite
            cellDescriptionLabel.attributedText = nil
            cellDescriptionLabel.textColor = .appWhite
            cellDescriptionLabel.text = cellDescriptionLabelText
        }
    }

    func setPreviewActive(_ active: Bool) {
        verticalStack.backgroundColor = active ? .appGray : .clear
    }

    // MARK: - Private methods
    private func addSubviews() {
        [cellCheckMark, verticalStack].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [
            cellMainLabel,
            cellDescriptionLabel,
            cellDataLabel
        ].forEach {
            verticalStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellCheckMark.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cellCheckMark.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            cellCheckMark.heightAnchor.constraint(equalToConstant: 24),
            cellCheckMark.widthAnchor.constraint(equalToConstant: 24),

            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            verticalStack.leadingAnchor.constraint(equalTo: cellCheckMark.trailingAnchor, constant: 8),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Actions
    @objc func checkMarkDidTap() {
        checkMarkButtonTapped?()
        addHapticFeedback()
    }
}
