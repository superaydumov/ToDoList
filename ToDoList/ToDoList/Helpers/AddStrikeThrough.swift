//
//  AddStrikeThrough.swift
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
