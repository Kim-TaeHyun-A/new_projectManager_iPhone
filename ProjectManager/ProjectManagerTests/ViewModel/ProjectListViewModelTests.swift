//
//  ProjectListViewModelTests.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/20.
//

@testable import ProjectManager
import XCTest
import RxRelay

// behavior verification with Mock
final class ProjectListViewModelTests: XCTestCase {
    var sut: ProjectListViewModelProtocol!
    var mockProjectUseCase: MockProjectUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockProjectUseCase = MockProjectUseCase()
        sut = ProjectListViewModel(projectUseCase: mockProjectUseCase, status: .todo)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_didDeleteCell_하면_mockProjectUseCase_deleteCallCount_1증가하는지() {
        // given
        let dataToDelete = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.didDeleteCell(content: dataToDelete)
        
        // then
        XCTAssertEqual(mockProjectUseCase.deleteCallCount, 1)
    }
    
    func test_didDeleteCell_하면_mockProjectUseCase_createHistoryCallCount_1증가하는지() {
        // given
        let dataToDelete = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.didDeleteCell(content: dataToDelete)
        
        // then
        XCTAssertEqual(mockProjectUseCase.createHistoryCallCount, 1)
    }
}
