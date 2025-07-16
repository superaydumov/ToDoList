//
//  ToDoListPresenterTests.swift
//  ToDoListTests
//
//  Created by Эльдар Айдумов on 25.06.2025.
//

import UIKit
import Testing
@testable import ToDoList

final class MockView: ToDoListViewControllerProtocol {

    var didCallShowToDoList = false

    func showToDoList() {
        didCallShowToDoList = true
    }

    func showError(message: String, retry: @escaping () -> Void) { }

    func startLoadingIndicator() { }

    func hideLoading() { }
}

final class MockInteractor: ToDoListInteractorProtocol {

    var didFetchData = false
    var didDeleteItem = false
    var didUpdateItem = false

    func fetchData() {
        didFetchData = true
    }

    func deleteItemFromCoreData(item: ToDoList.LocalToDoModel) {
        didDeleteItem = true
    }

    func updateItemInCoreData(item: ToDoList.LocalToDoModel) {
        didUpdateItem = true
    }
}

final class MockRouter: ToDoListRouterProtocol {

    var didNavigateToDetails = false
    var didNavigateToEditTask = false
    var didNavigateToAddTask = false

    func navigateToDetailsVC(with selectedToDo: ToDoList.LocalToDoModel) {
        didNavigateToDetails = true
    }

    func navigateToEditTask(with selectedToDo: ToDoList.LocalToDoModel) {
        didNavigateToEditTask = true
    }

    func navigateToAddTaskScreen() {
        didNavigateToAddTask = true
    }
}

final class mockNetworkService: NetworkServiceProtocol {

    var didCallNetworkService = false

    func fetchData(completion: @escaping (Result<ToDoList.NetworkToDoListModel, ToDoList.NetworkErrors>) -> Void) {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasLoadedToDos)
        didCallNetworkService = true
    }
}

final class MockPresenter: ToDoListPresenterProtocol {

    var router: (any ToDoList.ToDoListRouterProtocol)?
    var toDos = [ToDoList.LocalToDoModel]()
    var filteredToDos = [ToDoList.LocalToDoModel]()

    func configureView(with networkModel: ToDoList.NetworkToDoListModel) { }
    func configureView(with localToDos: [ToDoList.LocalToDoModel]) { }
    func navigateToDetailsVC(with selectedToDo: ToDoList.LocalToDoModel) { }
    func navigateToEditTask(with selectedToDo: ToDoList.LocalToDoModel) { }
    func navigateToAddTaskScreen() { }
    func triggerDataLoading() { }
    func fetchFailed(with error: ToDoList.NetworkErrors) { }
    func deleteTaskFromArray(itemToDelete: ToDoList.LocalToDoModel) { }
    func updateToDo(itemToUpdate: ToDoList.LocalToDoModel) { }
}

struct ToDoListTests {

    let mockModel = LocalToDoModel(
        id: UUID(),
        header: "Test",
        description: "desc",
        date: "2025-07-16",
        isCompleted: true
    )

    @Test func testPresenterCallsFetchData() async throws {
        let mockView = MockView()
        let mockInteractor = MockInteractor()
        let presenter = ToDoListPresenter(view: mockView)
        presenter.interactor = mockInteractor

        presenter.triggerDataLoading()
        #expect(mockInteractor.didFetchData == true)
    }

    @Test func testPresenterCallsShowToDoList() async throws {
        let mockView = MockView()
        let mockInteractor = MockInteractor()
        let presenter = ToDoListPresenter(view: mockView)
        presenter.interactor = mockInteractor

        presenter.configureView(with: [mockModel])
        #expect(mockView.didCallShowToDoList == true)
    }

    @Test func testPresenterCallsDeleteAndUpdateItem() async throws {
        let mockView = MockView()
        let mockInteractor = MockInteractor()
        let presenter = ToDoListPresenter(view: mockView)
        presenter.interactor = mockInteractor

        presenter.deleteTaskFromArray(itemToDelete: mockModel)
        presenter.updateToDo(itemToUpdate: mockModel)

        #expect(mockInteractor.didDeleteItem == true && mockInteractor.didUpdateItem == true)
    }

    @Test func testPresenterCallsRouterToGoToDetails() async throws {
        let mockView = MockView()
        let mockInteractor = MockInteractor()
        let presenter = ToDoListPresenter(view: mockView)
        let mockRouter = MockRouter()

        presenter.interactor = mockInteractor
        presenter.router = mockRouter

        presenter.navigateToDetailsVC(with: mockModel)

        #expect(mockRouter.didNavigateToDetails == true)
    }

    @Test func testPresenterCallsRouterToGoToEditTask() async throws {
        let mockView = MockView()
        let mockInteractor = MockInteractor()
        let presenter = ToDoListPresenter(view: mockView)
        let mockRouter = MockRouter()

        presenter.interactor = mockInteractor
        presenter.router = mockRouter

        presenter.router?.navigateToEditTask(with: mockModel)

        #expect(mockRouter.didNavigateToEditTask == true)
    }

    @Test func testPresenterCallsRouterToGoToAddTask() async throws {
        let mockView = MockView()
        let mockInteractor = MockInteractor()
        let presenter = ToDoListPresenter(view: mockView)
        let mockRouter = MockRouter()

        presenter.interactor = mockInteractor
        presenter.router = mockRouter

        presenter.navigateToAddTaskScreen()

        #expect(mockRouter.didNavigateToAddTask == true)
    }

    @Test func testIntractorCallsNetworkService() async throws {
        let presenter = MockPresenter()
        let mockNetworkService = mockNetworkService()
        let interactor = ToDoListInteractor(presenter: presenter, networkService: mockNetworkService)

        /// Setting this parameter to false to test networkService
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.hasLoadedToDos)
        interactor.fetchData()

        #expect(mockNetworkService.didCallNetworkService == true)
    }
}
