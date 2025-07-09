//
//  UITextField+extension.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 09.07.2025.
//

import UIKit

extension UITextField {

    func indentSize(leftSize: CGFloat) {
        self.leftView = UIView(
            frame:
                CGRect(
                    x: self.frame.minX,
                    y: self.frame.minY,
                    width: leftSize,
                    height: self.frame.height
                )
        )
        self.leftViewMode = .always
    }

    func validateText(
        textField: UITextField,
        textCount: Int,
        minCount: Int,
        borderWidth: CGFloat
    ) {
        if textCount < minCount {
                textField.layer.borderColor = UIColor.systemRed.cgColor
                textField.layer.borderWidth = borderWidth
            } else {
                textField.layer.borderWidth = .zero
            }
    }
}
