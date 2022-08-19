//
//  RegistrationViewModelTests.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/20.
//

@testable import ProjectManager
import XCTest

// behavior verification with Mock
final class RegistrationViewModelTests: XCTestCase {
    var sut: RegistrationViewModelProtocol!
    var mockProjectUseCase: MockProjectUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockProjectUseCase = MockProjectUseCase()
        sut = RegistrationViewModel(projectUseCase: mockProjectUseCase)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_registrate_하면_mockProjectUseCase_createCallCount_1증가하는지() {
        // when
        sut.registrate(title: "title", date: Date(), body: "test_body")
        
        // then
        XCTAssertEqual(mockProjectUseCase.createCallCount, 1)
    }
    
    func test_registrate_하면_mockProjectUseCase_createHistoryCallCount_1증가하는지() {
        // when
        sut.registrate(title: "title", date: Date(), body: "test_body")
        
        // then
        XCTAssertEqual(mockProjectUseCase.createHistoryCallCount, 1)
    }
}
