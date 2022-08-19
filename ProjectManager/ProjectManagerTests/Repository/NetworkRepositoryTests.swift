//
//  NetworkRepositoryTests.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/19.
//

@testable import ProjectManager
import XCTest

// behavior verification with Mock
final class NetworkRepositoryTests: XCTestCase {
    var sut: NetworkRepository!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockNetworkManager = MockNetworkManager()
        sut = NetworkRepository(networkManger: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_update_호출하면_mockNetworkManager_mockNetworkManager_1증가하는지() {
        // given
        let mockPersistentRepository = MockPersistentRepository()
        
        // when
        sut.update(repository: mockPersistentRepository)
        
        // then
        XCTAssertEqual(mockNetworkManager.updateCallCount, 1)
    }
    
    func test_update_호출하면_mockNetworkManager_readCallCount_1증가하는지() {
        // given
        let mockPersistentRepository = MockPersistentRepository()
        
        // when
        _ = sut.read(repository: mockPersistentRepository)
        
        // then
        XCTAssertEqual(mockNetworkManager.readCallCount, 1)
    }
}
