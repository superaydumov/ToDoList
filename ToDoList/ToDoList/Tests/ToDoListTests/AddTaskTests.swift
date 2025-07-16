//
//  AddTaskTests.swift
//  ToDoListTests
//
//  Created by Эльдар Айдумов on 16.07.2025.
//

import UIKit
import Testing
@testable import ToDoList

final class MockAddTaskInteractor: AddTaskInteractorProtocol {

    var didCallSaveToCoreData = false

    func saveItemToCoreData(item: ToDoList.LocalToDoModel) {
        didCallSaveToCoreData = true
    }
}

final class MockAddTaskRouter: AddTaskRouterProtocol {

    var didCallDismiss = false

    func dismissVC() {
        didCallDismiss = true
    }
}

struct AddTaskTests {

    let mockModel = LocalToDoModel(
        id: UUID(),
        header: "Test",
        description: "desc",
        date: "2025-07-16",
        isCompleted: true
    )

    @Test func testPresenterCallsInteractor() async throws {
        let presenter = AddTaskPresenter()
        let mockInteractor = MockAddTaskInteractor()

        presenter.interactor = mockInteractor

        presenter.saveNewToDo(todo: mockModel)

        #expect(mockInteractor.didCallSaveToCoreData == true)
    }

    @Test func testPresenterCallsRouter() async throws {
        let presenter = AddTaskPresenter()
        let mockAddTaskRouter = MockAddTaskRouter()

        presenter.router = mockAddTaskRouter

        presenter.dismissViewController()

        #expect(mockAddTaskRouter.didCallDismiss == true)
    }


}
