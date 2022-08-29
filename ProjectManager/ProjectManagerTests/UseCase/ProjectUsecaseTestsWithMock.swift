//
//  ProjectUsecaseTestsWithMock.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/19.
//

@testable import ProjectManager
import XCTest

// behavior verification with Mock
final class ProjectUsecaseTestsWithMock: XCTestCase {
    var sut: ProjectUseCaseProtocol!
    var mockPersistentRepository: MockPersistentRepository!
    var mockRemoteRepository: MockRemoteRepository!
    var mockHistoryRepository: MockHistoryRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockPersistentRepository = MockPersistentRepository()
        mockRemoteRepository = MockRemoteRepository()
        mockHistoryRepository = MockHistoryRepository()
        
        sut = DefaultProjectUseCase(
            projectRepository: mockPersistentRepository,
            remoteRepository: mockRemoteRepository,
            historyRepository: mockHistoryRepository
        )
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_create_호출하면_PersistentRepository_createProjectEntityCallCount_1증가하는지() {
        // given
        let dataToCreate = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.create(projectEntity: dataToCreate)
        
        // then
        XCTAssertEqual(mockPersistentRepository.createProjectEntityCallCount, 1)
    }
    
    func test_read_호출하면_PersistentRepository_readCallCount_1증가하는지() {
        // when
        _ = sut.read()
        
        // then
        XCTAssertEqual(mockPersistentRepository.readCallCount, 1)
    }
    
    func test_read_호출하면_PersistentRepository_readWithProjectEntityIDCallCount_1증가하는지() {
        // given
        let dataToRead = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        _ = sut.read(projectEntityID: dataToRead.id)
        
        // then
        XCTAssertEqual(mockPersistentRepository.readWithProjectEntityIDCallCount, 1)
    }
    
    func test_update_호출하면_PersistentRepository_updateCallCount_1증가하는지() {
        // given
        let dataToUpdate = ProjectEntity(id: UUID(), title: "upateTest", deadline: Date(), body: "test_body")
        
        // when
        sut.update(projectEntity: dataToUpdate)
        
        // then
        XCTAssertEqual(mockPersistentRepository.updateCallCount, 1)
    }
    
    func test_delete_호출하면_PersistentRepository_deleteCallCount_1증가하는지() {
        // given
        let dataToDelete = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.delete(projectEntityID: dataToDelete.id)
        
        // then
        XCTAssertEqual(mockPersistentRepository.deleteCallCount, 1)
    }
    
    func test_load_호출하면_NetworkRepository_readCallCount_1증가하는지() {
        // when
        _ = sut.load()
        
        // then
        XCTAssertEqual(mockRemoteRepository.readCallCount, 1)
    }
    
    func test_backUp_호출하면_mockNetworkRepository_updateCallCount_1증가하는지() {
        // when
        sut.backUp()
        
        // then
        XCTAssertEqual(mockRemoteRepository.updateCallCount, 1)
    }
    
    func test_createHistory_호출하면_mockHistoryRepository_createCallCount_1증가하는지() {
        // when
        sut.createHistory(
            historyEntity: HistoryEntity(
                editedType: EditedType.move,
                title: "test",
                date: Date().timeIntervalSince1970
            )
        )
        
        // then
        XCTAssertEqual(mockHistoryRepository.createCallCount, 1)
    }
    
    func test_readHistory_호출하면_mockHistoryRepository_readCallCount_1증가하는지() {
        // when
        _ = sut.readHistory()
        
        // then
        XCTAssertEqual(mockHistoryRepository.readCallCount, 1)
    }
}
