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
    var sut: DetailViewModel!
    var mockProjectUseCase: MockProjectUseCase!
    var stubDetailViewModelDelegate = StubDetailViewModelDelegate()
    
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
    
    func test_didTapRightButton_누르고_editMode면_createHistoryCallCount_1증가하는지() {
        // given
        sut.didTapLeftButton()
        sut.delegate = stubDetailViewModelDelegate
        
        // when
        sut.didTapRightButton()
        
        // then
        XCTAssertEqual(mockProjectUseCase.createHistoryCallCount, 1)
    }
    
    func test_didTapRightButton_누르고_editMode면_updateCallCount_1증가하는지() {
        // given
        sut.didTapLeftButton()
        sut.delegate = stubDetailViewModelDelegate
        
        // when
        sut.didTapRightButton()
        
        // then
        XCTAssertEqual(mockProjectUseCase.updateCallCount, 1)
    }
}

final class StubDetailViewModelDelegate: DetailViewModelDelegate {
    func close() {
        // empty
    }
    
    func getEdittedContent() -> ProjectEntity? {
        return ProjectEntity(title: "test", deadline: Date(), body: "body_test")
    }
}
