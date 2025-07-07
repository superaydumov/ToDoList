//
//  DateFormatter+extension.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 07.07.2025.
//

import Foundation

extension Date {

    func convertDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"

        return formatter.string(from: self)
    }
}
