//
//  ProjectListViewModel.swift
//  ProjectManager
//
//  Created by Tiana on 2022/08/19.
//

import RxCocoa

protocol ProjectListViewModelInputProtocol {
    func didDeleteCell(content: ProjectEntity)
}

protocol ProjectListViewModelOutputProtocol {
    var status: ProjectStatus { get }
    var statusProject: Driver<[ProjectEntity]> { get }
}

protocol ProjectListViewModelProtocol: ProjectListViewModelInputProtocol, ProjectListViewModelOutputProtocol { }

final class ProjectListViewModel: ProjectListViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    
    // MARK: - Output
    let status: ProjectStatus
    lazy var statusProject: Driver<[ProjectEntity]> = {
        return projectUseCase.read()
            .map { [weak self] in $0.filter { $0.status == self?.status } }
            .asDriver(onErrorJustReturn: [])
    }()
    
    init(projectUseCase: ProjectUseCaseProtocol, status: ProjectStatus) {
        self.projectUseCase = projectUseCase
        self.status = status
    }
    
    private func deleteHistory(by content: ProjectEntity) {
        let historyEntity = HistoryEntity(
            editedType: .delete,
            title: content.title,
            date: Date().timeIntervalSince1970
        )
        
        projectUseCase.createHistory(historyEntity: historyEntity)
    }
}

// MARK: - Input

extension ProjectListViewModel {
    func didDeleteCell(content: ProjectEntity) {
        projectUseCase.delete(projectEntityID: content.id)
        deleteHistory(by: content)
    }
}
