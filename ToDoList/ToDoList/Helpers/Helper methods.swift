//
//  AddHapticFeedback.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 07.07.2025.
//

import UIKit

func addStrikethrough(to text: String) -> NSAttributedString {
    let attrString = NSMutableAttributedString(string: text)
    let range = NSRange(location: 0, length: attrString.length)
    attrString.addAttribute(
        .strikethroughStyle,
        value: NSUnderlineStyle.single.rawValue,
        range: range
    )

    return attrString
}

func addHapticFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.prepare()
    generator.impactOccurred()
}

func pluralizedTaskWord(for count: Int) -> String {
    let remainder100 = count % 100
    let remainder10 = count % 10

    if remainder100 >= 11 && remainder100 <= 14 {
        return "задач"
    }

    switch remainder10 {
    case 1: return "задача"
    case 2, 3, 4: return "задачи"
    default: return "задач"
    }
}
