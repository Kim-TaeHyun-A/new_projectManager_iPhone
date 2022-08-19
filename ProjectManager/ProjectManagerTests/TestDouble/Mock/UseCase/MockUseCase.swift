//
//  MockUseCase.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/20.
//

@testable import ProjectManager
import XCTest
import RxRelay
import RxSwift

final class MockProjectUseCase: ProjectUseCaseProtocol {
    var createCallCount = 0
    var readCallCount = 0
    var readWithProjectEntityIDCallCount = 0
    var updateCallCount = 0
    var deleteCallCount = 0
    var loadCallCount = 0
    var backUpCallCount = 0
    var createHistoryCallCount = 0
    var readHistoryCallCount = 0
    
    func create(projectEntity: ProjectEntity) {
        createCallCount += 1
    }
    
    func read() -> BehaviorRelay<[ProjectEntity]> {
        readCallCount += 1
        return BehaviorRelay(value: [])
    }
    
    func read(projectEntityID: UUID?) -> ProjectEntity? {
        readWithProjectEntityIDCallCount += 1
        return nil
    }
    
    func update(projectEntity: ProjectEntity) {
        updateCallCount += 1
    }
    
    func delete(projectEntityID: UUID?) {
        deleteCallCount += 1
    }
    
    func load() -> Disposable {
        loadCallCount += 1
        return Disposables.create()
    }
    
    func backUp() {
        backUpCallCount += 1
    }
    
    func createHistory(historyEntity: HistoryEntity) {
        createHistoryCallCount += 1
    }
    
    func readHistory() -> BehaviorRelay<[HistoryEntity]> {
        readHistoryCallCount += 1
        return BehaviorRelay(value: [])
    }
}
