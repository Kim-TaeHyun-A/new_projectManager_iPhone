//
//  StubProjectUseCase.swift
//  ProjectManagerTests
//
//  Created by Tiana on 2022/08/18.
//

@testable import ProjectManager
import RxRelay
import RxSwift

final class StubProjectUseCase: ProjectUseCaseProtocol {
    var persistentRepository: [ProjectEntity] = []
    var networkRepository: [ProjectEntity] = []
    var historyRepository: [HistoryEntity] = []
    
    private func findIndex(with id: UUID) -> Int? {
        var index: Int?
        
        persistentRepository.enumerated().forEach {
            if $0.element.id == id {
                index = $0.0
            }
        }
        return index
    }
    
    func create(projectEntity: ProjectEntity) {
        persistentRepository.append(projectEntity)
    }
    
    func read() -> BehaviorRelay<[ProjectEntity]> {
        return BehaviorRelay(value: persistentRepository)
    }
    
    func read(projectEntityID: UUID?) -> ProjectEntity? {
        return persistentRepository.first(where: { $0.id == projectEntityID })
    }
    
    func update(projectEntity: ProjectEntity) {
        let index = findIndex(with: projectEntity.id)
        
        persistentRepository.remove(at: index!)
        persistentRepository.insert(projectEntity, at: index!)
    }
    
    func delete(projectEntityID: UUID?) {
        let index = findIndex(with: projectEntityID!)
        
        persistentRepository.remove(at: index!)
    }
    
    func load() -> Disposable {
        persistentRepository = networkRepository
        return Disposables.create()
    }
    
    func backUp() {
        networkRepository = persistentRepository
    }
    
    func createHistory(historyEntity: HistoryEntity) {
        historyRepository.append(historyEntity)
    }
    
    func readHistory() -> BehaviorRelay<[HistoryEntity]> {
        return BehaviorRelay(value: historyRepository)
    }
}
