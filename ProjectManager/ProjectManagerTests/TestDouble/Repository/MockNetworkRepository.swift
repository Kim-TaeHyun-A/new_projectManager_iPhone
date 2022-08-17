//
//  MockNetworkRepository.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager
import RxSwift

final class MockNetworkRepository: NetworkRepositoryProtocol {
    var updateCallCount = 0
    var readCallCount = 0

    func update(repository: PersistentRepositoryProtocol) {
        updateCallCount += 1
    }
    
    func read(repository: PersistentRepositoryProtocol) -> Disposable {
        readCallCount += 1
        return Disposables.create()
    }
}
