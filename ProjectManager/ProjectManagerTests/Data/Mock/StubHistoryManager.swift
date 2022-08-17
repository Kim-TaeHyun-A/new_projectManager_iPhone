//
//  StubHistoryManager.swift
//  ProjectManagerTests
//
//  Created by Tiana, mmim on 2022/07/29.
//

@testable import ProjectManager
import RxRelay

final class StubHistoryManager {
    var stubHistoryEntities = BehaviorRelay<[HistoryEntity]>(value: [])
}

extension StubHistoryManager: HistoryManagerProtocol {
    func create(historyEntity: HistoryEntity) {
        var currentProject = read().value
        
        currentProject.append(historyEntity)
        stubHistoryEntities.accept(currentProject)
    }
    
    func read() -> BehaviorRelay<[HistoryEntity]> {
        return stubHistoryEntities
    }
}
