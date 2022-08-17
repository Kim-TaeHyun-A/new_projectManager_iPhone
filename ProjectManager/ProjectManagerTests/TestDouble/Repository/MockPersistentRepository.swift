//
//  MockPersistentRepository.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager
import RxRelay

final class MockPersistentRepository: PersistentRepositoryProtocol {
    var createProjectEntityCallCount = 0
    var createProjectEntitiesCallCount = 0
    var readCallCount = 0
    var readWithProjectEntityIDCallCount = 0
    var updateCallCount = 0
    var deleteCallCount = 0
    var deleteAllCallCount = 0
    
    func create(projectEntity: ProjectEntity) {
        createProjectEntityCallCount += 1
    }
    
    func create(projectEntities: [ProjectEntity]) {
        createProjectEntitiesCallCount += 1
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
    
    func deleteAll() {
        deleteAllCallCount += 1
    }
}
