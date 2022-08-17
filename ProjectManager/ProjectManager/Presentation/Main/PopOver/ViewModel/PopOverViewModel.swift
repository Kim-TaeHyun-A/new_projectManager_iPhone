//
//  PopOverViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/12.
//

import Foundation

protocol PopOverViewModelInputProtocol {
    func moveCell(by text: String?)
}

protocol PopOverViewModelOutputProtocol {
    var cell: ProjectCell { get }
    var status: (first: ProjectStatus, second: ProjectStatus)? { get }
}

protocol PopOverViewModelProtocol: PopOverViewModelInputProtocol, PopOverViewModelOutputProtocol { }

final class PopOverViewModel: PopOverViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    
    // MARK: - Output
    
    let cell: ProjectCell
    lazy var status: (first: ProjectStatus, second: ProjectStatus)? = {
        guard let id = cell.contentID,
              let project = projectUseCase.read(projectEntityID: id) else {
            return nil
        }
        
        return convertProcess(by: project.status)
    }()
    
    init(projectUseCase: ProjectUseCaseProtocol, cell: ProjectCell) {
        self.projectUseCase = projectUseCase
        self.cell = cell
    }
    
    private func changeContent(status: ProjectStatus) {
        guard let id = cell.contentID,
              var project = projectUseCase.read(projectEntityID: id) else {
            return
        }
        
        createMoved(from: project.status, to: status, title: project.title)
        
        project.status = status
        
        projectUseCase.update(projectEntity: project)
    }
    
    private func createMoved(from oldStatus: ProjectStatus, to newStatus: ProjectStatus, title: String) {
        let historyTitle = "(from: \(oldStatus.string) to: \(newStatus.string))" + title
        
        let historyEntity = HistoryEntity(
            editedType: .move,
            title: historyTitle,
            date: Date().timeIntervalSince1970
        )
        
        projectUseCase.createHistory(historyEntity: historyEntity)
    }
    
    private func convertProcess(by status: ProjectStatus) -> (first: ProjectStatus, second: ProjectStatus) {
        switch status {
        case .todo:
            return (ProjectStatus.doing, ProjectStatus.done)
        case .doing:
            return (ProjectStatus.todo, ProjectStatus.done)
        case .done:
            return (ProjectStatus.todo, ProjectStatus.doing)
        }
    }
}

// MARK: - Input

extension PopOverViewModel {
    func moveCell(by text: String?) {
        guard let status = ProjectStatus.convert(titleText: text) else {
            return
        }
        changeContent(status: status)
    }
}
