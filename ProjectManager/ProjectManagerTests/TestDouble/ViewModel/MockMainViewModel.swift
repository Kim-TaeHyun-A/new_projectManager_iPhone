//
//  MockMainViewModel.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager

final class MockMainViewModel: MainViewModelInputProtocol {
    var deleteProjectCallCount = 0
    var readProjectCallCount = 0
    var loadNetworkDataCallCount = 0
    
    func deleteProject(_ content: ProjectEntity) {
        deleteProjectCallCount += 1
    }
    
    func readProject(_ id: UUID?) {
        readProjectCallCount += 1
    }
    
    func loadNetworkData() {
        loadNetworkDataCallCount += 1
    }
}
