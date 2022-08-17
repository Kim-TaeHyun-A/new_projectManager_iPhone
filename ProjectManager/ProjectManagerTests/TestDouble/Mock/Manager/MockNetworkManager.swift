//
//  MockNetworkManager.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager
import RxSwift

final class MockNetworkManager: NetworkManagerProtocol {
    var readCallCount = 0
    var updateCallCount = 0
    
    func read() -> Observable<[ProjectDTO]> {
        readCallCount += 1
        return Observable.create { _ in Disposables.create() }
    }
    
    func update(projects: [ProjectDTO]) {
        updateCallCount += 1
    }
}
