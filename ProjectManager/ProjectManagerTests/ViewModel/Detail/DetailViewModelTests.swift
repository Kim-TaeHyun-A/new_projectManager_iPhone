//
//  DetailViewModelTests.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/20.
//

@testable import ProjectManager
import XCTest

// behavior verification with Mock
final class DetailViewModelTests: XCTestCase {
    var sut: DetailViewModelProtocol!
    var mockProjectUseCase: MockProjectUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let dummyData = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        mockProjectUseCase = MockProjectUseCase()
        sut = DetailViewModel(projectUseCase: mockProjectUseCase, content: dummyData)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_read_하면_mockProjectUseCase_readCallCount_1증가하는지() {
        // when
        sut.read()
        
        // then
        XCTAssertEqual(mockProjectUseCase.readCallCount, 1)
    }
    
    func test_registrate_하면_mockProjectUseCase_updateCallCount_1증가하는지() {
        // given
        let dataToUpdate = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.update(dataToUpdate)
        
        // then
        XCTAssertEqual(mockProjectUseCase.updateCallCount, 1)
    }
    
    func test_registrate_하면_mockProjectUseCase_createHistoryCallCount_1증가하는지() {
        // given
        let dataToUpdate = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.update(dataToUpdate)
        
        // then
        XCTAssertEqual(mockProjectUseCase.createHistoryCallCount, 1)
    }
}
