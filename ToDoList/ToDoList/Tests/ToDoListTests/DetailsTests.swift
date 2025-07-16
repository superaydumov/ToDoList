//
//  ToDoListRouterTests.swift
//  ToDoListTests
//
//  Created by Эльдар Айдумов on 16.07.2025.
//

import UIKit
import Testing
@testable import ToDoList

final class MockDetailsInteractor: DetailsInteractorProtocol {

    var didCallSaveToCoreData = false

    func updateItemInCoreData(item: ToDoList.LocalToDoModel) {
        didCallSaveToCoreData = true
    }
}

struct DetailsTests {

    let mockModel = LocalToDoModel(
        id: UUID(),
        header: "Test",
        description: "desc",
        date: "2025-07-16",
        isCompleted: true
    )

    @Test func testPresenterCallsInteractor() async throws {
        let presenter = DetailsPresenter()
        let mockInteractor = MockDetailsInteractor()

        presenter.interactor = mockInteractor

        presenter.updateToDo(itemToUpdate: mockModel)

        #expect(mockInteractor.didCallSaveToCoreData == true)
    }
}
