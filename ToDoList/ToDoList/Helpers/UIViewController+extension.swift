//
//  UIViewController+extension.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 08.07.2025.
//

import UIKit

extension UIViewController {

    func showAlert(message: String, retryAction: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(
                title: "Попробовать снова",
                style: .default,
                handler: { _ in
                    retryAction()
                }))

            alert.addAction(UIAlertAction(
                title: "Отменить",
                style: .cancel))

            self.present(alert, animated: true)
        }
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
