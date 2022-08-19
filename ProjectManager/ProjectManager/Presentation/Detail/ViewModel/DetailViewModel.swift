//
//  DetailViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

import Foundation

protocol DetailViewModelInputProtocol {
    func read()
    func update(_ content: ProjectEntity)
}

protocol DetailViewModelOutputProtocol {
    var content: ProjectEntity { get }
    var currentProjectEntity: ProjectEntity? { get }
}

protocol DetailViewModelProtocol: DetailViewModelInputProtocol, DetailViewModelOutputProtocol { }

final class DetailViewModel: DetailViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    
    // MARK: - Output
    
    var content: ProjectEntity
    var currentProjectEntity: ProjectEntity?
    
    init(projectUseCase: ProjectUseCaseProtocol, content: ProjectEntity) {
        self.projectUseCase = projectUseCase
        self.content = content
    }
    
    private func updateHistory(by content: ProjectEntity) {
        let historyEntity = HistoryEntity(editedType: .edit,
                                          title: content.title,
                                          date: Date().timeIntervalSince1970)
        
        projectUseCase.createHistory(historyEntity: historyEntity)
    }
}

// MARK: - Input

extension DetailViewModel {
    func read() {
        currentProjectEntity = projectUseCase.read(projectEntityID: content.id)
    }
    
    func update(_ content: ProjectEntity) {
        projectUseCase.update(projectEntity: content)
        updateHistory(by: content)
    }
}
