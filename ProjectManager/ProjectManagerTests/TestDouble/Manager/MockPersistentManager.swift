//
//  MockPersistentManager.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager
import Foundation

final class MockPersistentManager: PersistentManagerProtocol {
    var createProjectCallCount = 0
    var createProjectsCallCount = 0
    var createReadCallCount = 0
    var readAllCallCount = 0
    var readWithProjectEntityIDCallCount = 0
    var updateCallCount = 0
    var deleteCallCount = 0
    var deleteAllCallCount = 0
    
    func create(project: ProjectDTO) {
        createProjectCallCount += 1
    }
    
    func create(projects: [ProjectDTO]) {
        createProjectsCallCount += 1
    }
    
    func read() -> [ProjectDTO] {
        readAllCallCount += 1
        return []
    }
    
    func read(projectEntityID: UUID?) -> ProjectDTO? {
        readWithProjectEntityIDCallCount += 1
        return nil
    }
    
    func update(project: ProjectDTO) {
        updateCallCount += 1
    }
    
    func delete(projectEntityID: UUID?) {
        deleteCallCount += 1
    }
    
    func deleteAll() {
        deleteAllCallCount += 1
    }
}
