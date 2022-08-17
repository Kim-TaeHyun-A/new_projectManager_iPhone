//
//  MockHistoryManager.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager
import RxRelay

final class MockHistoryManager: HistoryManagerProtocol {
    var creatCallCount = 0
    var readCallCount = 0
    
    func create(historyEntity: HistoryEntity) {
        creatCallCount += 1
    }
    
    func read() -> BehaviorRelay<[HistoryEntity]> {
        readCallCount += 1
        return BehaviorRelay(value: [])
    }
}
