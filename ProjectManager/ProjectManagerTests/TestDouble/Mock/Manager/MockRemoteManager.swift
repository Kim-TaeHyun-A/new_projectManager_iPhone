//
//  MockRemoteManager.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager
import RxSwift

final class MockRemoteManager: RemoteManagerProtocol {
    var readCallCount = 0
    var updateCallCount = 0
    
    func read() -> Single<[ProjectDTO]> {
        readCallCount += 1
        return Single.create { _ in Disposables.create() }
    }
    
    func update(projects: [ProjectDTO]) {
        updateCallCount += 1
    }
}
