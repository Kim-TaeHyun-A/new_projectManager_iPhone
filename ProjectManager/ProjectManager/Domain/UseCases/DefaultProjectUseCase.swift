//
//  DefaultProjectUseCase.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/12.
//

import RxSwift
import RxRelay

protocol ProjectUseCaseProtocol {
    func create(projectEntity: ProjectEntity)
    func read() -> BehaviorRelay<[ProjectEntity]>
    func read(projectEntityID: UUID?) -> ProjectEntity?
    func update(projectEntity: ProjectEntity)
    func delete(projectEntityID: UUID?)
    func load() -> Disposable
    func backUp()
    func createHistory(historyEntity: HistoryEntity)
    func readHistory() -> BehaviorRelay<[HistoryEntity]>
}

struct DefaultProjectUseCase: ProjectUseCaseProtocol {
    private let projectRepository: PersistentRepositoryProtocol
    private let remoteRepository: RemoteRepositoryProtocol
    private let historyRepository: HistoryRepositoryProtocol
    
    init(projectRepository: PersistentRepositoryProtocol, remoteRepository: RemoteRepositoryProtocol, historyRepository: HistoryRepositoryProtocol) {
        self.projectRepository = projectRepository
        self.remoteRepository = remoteRepository
        self.historyRepository = historyRepository
    }
    
    func create(projectEntity: ProjectEntity) {
        projectRepository.create(projectEntity: projectEntity)
    }
    
    func read() -> BehaviorRelay<[ProjectEntity]> {
        return projectRepository.read()
    }
    
    func read(projectEntityID: UUID?) -> ProjectEntity? {
        return projectRepository.read(projectEntityID: projectEntityID)
    }
    
    func update(projectEntity: ProjectEntity) {
        projectRepository.update(projectEntity: projectEntity)
    }
    
    func delete(projectEntityID: UUID?) {
        projectRepository.delete(projectEntityID: projectEntityID)
    }
    
    func load() -> Disposable {
        return remoteRepository.read(repository: projectRepository)
    }
    
    func backUp() {
        remoteRepository.update(repository: projectRepository)
    }
    
    func createHistory(historyEntity: HistoryEntity) {
        historyRepository.create(historyEntity: historyEntity)
    }
    
    func readHistory() -> BehaviorRelay<[HistoryEntity]> {
        return historyRepository.read()
    }
}
