//
//  MockRegistrationViewModel.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager
import Foundation

final class MockRegistrationViewModel: RegistrationViewModelInputProtocol {
    var registrateCallCount = 0
    
    func registrate(title: String, date: Date, body: String) {
        registrateCallCount += 1
    }
}
