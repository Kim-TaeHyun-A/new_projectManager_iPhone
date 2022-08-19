//
//  PersistentRepositoryTests.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/19.
//

@testable import ProjectManager
import XCTest

// behavior verification with Mock
final class PersistentRepositoryTests: XCTestCase {
    var sut: PersistentRepository!
    var mockPersistentManager: MockPersistentManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockPersistentManager = MockPersistentManager()
        sut = PersistentRepository(persistentManager: mockPersistentManager)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_create_projectEntity_호출하면_PersistentManager_createProjectCallCount_1증가하는지() {
        // given
        let data = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.create(projectEntity: data)
        
        // then
        XCTAssertEqual(mockPersistentManager.createProjectCallCount, 1)
    }
    
    func test_create_projectEntities_호출하면_PersistentManager_createProjectsCallCount_1증가하는지() {
        // given
        let data = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.create(projectEntities: [data])
        
        // then
        XCTAssertEqual(mockPersistentManager.createProjectsCallCount, 1)
    }
    
    func test_read_호출하면_PersistentManager_readAllCallCount_1증가하는지() {
        // when
        _ = sut.read()
        
        // then
        XCTAssertEqual(mockPersistentManager.readAllCallCount, 1)
    }
    
    func test_update_호출하면_PersistentManager_readAllCallCount_1증가하는지() {
        // given
        let data = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.update(projectEntity: data)
        
        // then
        XCTAssertEqual(mockPersistentManager.updateCallCount, 1)
    }

    func test_delete_projectEntityID_호출하면_PersistentManager_deleteCallCount_1증가하는지() {
        // given
        let data = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.delete(projectEntityID: data.id)
        
        // then
        XCTAssertEqual(mockPersistentManager.deleteCallCount, 1)
    }
    
    func test_deleteAll호출하면_PersistentManager_deleteAllCallCount_1증가하는지() {
        // when
        sut.deleteAll()
        
        // then
        XCTAssertEqual(mockPersistentManager.deleteAllCallCount, 1)
    }
}
