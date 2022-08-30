//
//  RemoteRepositoryTests.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/19.
//

@testable import ProjectManager
import XCTest

// behavior verification with Mock
final class RemoteRepositoryTests: XCTestCase {
    var sut: RemoteRepository!
    var mockRemoteManager: MockRemoteManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockRemoteManager = MockRemoteManager()
        sut = RemoteRepository(remoteManger: mockRemoteManager)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_update_호출하면_mockRemoteManager_updateCallCount_1증가하는지() {
        // given
        let mockPersistentRepository = MockPersistentRepository()
        
        // when
        sut.update(repository: mockPersistentRepository)
        
        // then
        XCTAssertEqual(mockRemoteManager.updateCallCount, 1)
    }
    
    func test_read_호출하면_mockRemoteManager_readCallCount_1증가하는지() {
        // given
        let mockPersistentRepository = MockPersistentRepository()
        
        // when
        _ = sut.read(repository: mockPersistentRepository)
        
        // then
        XCTAssertEqual(mockRemoteManager.readCallCount, 1)
    }
}
