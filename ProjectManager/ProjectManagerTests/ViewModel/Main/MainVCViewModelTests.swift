//
//  MainVCViewModelTests.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/19.
//

@testable import ProjectManager
import XCTest
import RxRelay

// behavior verification with Mock
final class MainVCViewModelTests: XCTestCase {
    var sut: MainVCViewModelProtocol!
    var mockProjectUseCase: MockProjectUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockProjectUseCase = MockProjectUseCase()
        sut = MainVCViewModel(projectUseCase: mockProjectUseCase,
                              networkCondition: NetworkCondition())
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_didTapCell_id넣으면_mockProjectUseCase_readWithProjectEntityIDCallCount_1증가하는지() {
        // when
        sut.didTapCell(UUID())
        
        // then
        XCTAssertEqual(mockProjectUseCase.readWithProjectEntityIDCallCount, 1)
    }
    
    func test_didTapLoadButton_하면_mockProjectUseCase_loadCallCount_1증가하는지() {
        // when
        sut.didTapLoadButton()
        
        // then
        XCTAssertEqual(mockProjectUseCase.loadCallCount, 1)
    }
}
