//
//  StubPersistentManager.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

@testable import ProjectManager
import Foundation

final class StubCoreData {
    var projects: [ProjectDTO] = []
}

final class StubPersistentManager {
    let stubCoreData = StubCoreData()
}

extension StubPersistentManager: PersistentManagerProtocol {
    func create(project: ProjectDTO) {
        stubCoreData.projects.append(project)
    }
    
    func create(projects: [ProjectDTO]) {
        stubCoreData.projects = projects
    }
    
    func read() -> [ProjectDTO] {
        return stubCoreData.projects
    }
    
    func read(projectEntityID: UUID?) -> ProjectDTO? {
        if let indexToRead = stubCoreData.projects.firstIndex(where: { $0.id == projectEntityID?.uuidString}) {
            return stubCoreData.projects[indexToRead]
        }
        return nil
    }
    
    func update(project: ProjectDTO) {
        if let indexToUpdate = stubCoreData.projects.firstIndex(where: { $0.id == project.id}) {
            stubCoreData.projects[indexToUpdate] = project
        }
    }
    
    func delete(projectEntityID: UUID?) {
        if let indexToDelete = stubCoreData.projects.firstIndex(where: { $0.id == projectEntityID?.uuidString}) {
            stubCoreData.projects.remove(at: indexToDelete)
        }
    }
    
    func deleteAll() {
        stubCoreData.projects = []
    }
}
