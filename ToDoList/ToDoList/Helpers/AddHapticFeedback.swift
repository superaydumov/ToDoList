//
//  AddHapticFeedback.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 07.07.2025.
//

import UIKit

func addHapticFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.prepare()
    generator.impactOccurred()
}
