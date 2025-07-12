//
//  MockData.swift
//  ToDoList
//
//  Created by Эльдар Айдумов on 06.07.2025.
//

var cellMockData: NetworkToDoListModel = NetworkToDoListModel(
    todos: [
        NetworkToDo(
            id: 13,
            todo: "Have a photo session with some friends",
            completed: false,
            userId: 12
        ),
        NetworkToDo(
            id: 16,
            todo: "Learn calligraphy",
            completed: true,
            userId: 53
        ),
        NetworkToDo(
            id: 57,
            todo: "Improve touch typing Improve touch typing Improve touch typing Improve touch typing Improve touch typing Improve touch typing",
            completed: false,
            userId: 89
        )
    ],
    total: 157,
    skip: 0,
    limit: 50
)
