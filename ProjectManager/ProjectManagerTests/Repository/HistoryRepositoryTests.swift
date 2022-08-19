//
//  HistoryRepositoryTests.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/19.
//

@testable import ProjectManager
import XCTest

// behavior verification with Mock
final class HistoryRepositoryTests: XCTestCase {
    var sut: HistoryRepository!
    var mockHistoryManager: MockHistoryManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockHistoryManager = MockHistoryManager()
        sut = HistoryRepository(historyManager: mockHistoryManager)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_create_호출하면_mockHistoryManager_creatCallCount_1증가하는지() {
        // given
        let data = HistoryEntity(editedType: .delete, title: "test", date: Date().timeIntervalSince1970)
        
        // when
        sut.create(historyEntity: data)
        
        // then
        XCTAssertEqual(mockHistoryManager.creatCallCount, 1)
    }
    
    func test_read_호출하면_mockHistoryManager_readCallCount_1증가하는지() {
        // when
        _ = sut.read()
        
        // then
        XCTAssertEqual(mockHistoryManager.readCallCount, 1)
    }
}
