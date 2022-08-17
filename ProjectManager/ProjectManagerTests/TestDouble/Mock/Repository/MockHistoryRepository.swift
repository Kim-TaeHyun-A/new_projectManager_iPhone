//
//  MockHistoryRepository.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager
import RxRelay

final class MockHistoryRepository: HistoryRepositoryProtocol {
    var createCallCount = 0
    var readCallCount = 0
    
    func create(historyEntity: HistoryEntity) {
        createCallCount += 1
    }
    
    func read() -> BehaviorRelay<[HistoryEntity]> {
        readCallCount += 1
        return BehaviorRelay(value: [])
    }
}
