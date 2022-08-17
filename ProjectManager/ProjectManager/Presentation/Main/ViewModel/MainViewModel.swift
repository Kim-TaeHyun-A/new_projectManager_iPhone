//
//  MainViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/06.
//

import RxSwift
import RxCocoa
import RxGesture

protocol MainViewModelInputProtocol {
    func deleteProject(_ content: ProjectEntity)
    func readProject(_ id: UUID?)
    func loadNetworkData()
}

protocol MainViewModelOutputProtocol {
    var todoProjects: Driver<[ProjectEntity]> { get }
    var doingProjects: Driver<[ProjectEntity]> { get }
    var doneProjects: Driver<[ProjectEntity]> { get }
    var currnetProjectEntity: ProjectEntity? { get }
    var remoteData: Disposable? { get }
}

protocol MainViewModelProtocol: MainViewModelInputProtocol,MainViewModelOutputProtocol { }

final class MainViewModel: MainViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    private lazy var projects: BehaviorRelay<[ProjectEntity]> = {
        return projectUseCase.read()
    }()
    
    // MARK: - Output
    
    lazy var todoProjects: Driver<[ProjectEntity]> = {
        projects
            .map { $0.filter { $0.status == .todo } }
            .asDriver(onErrorJustReturn: [])
    }()
    lazy var doingProjects: Driver<[ProjectEntity]> = {
        return projects
            .map { $0.filter { $0.status == .doing } }
            .asDriver(onErrorJustReturn: [])
    }()
    lazy var doneProjects: Driver<[ProjectEntity]> = {
        return projects
            .map { $0.filter { $0.status == .done } }
            .asDriver(onErrorJustReturn: [])
    }()
    var currnetProjectEntity: ProjectEntity? = nil
    var remoteData: Disposable? = nil
    
    init(projectUseCase: ProjectUseCaseProtocol) {
        self.projectUseCase = projectUseCase
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

extension MainViewModel {
    func deleteProject(_ content: ProjectEntity) {
        projectUseCase.delete(projectEntityID: content.id)
        deleteHistory(by: content)
    }
    
    func readProject(_ id: UUID?) {
        currnetProjectEntity = projectUseCase.read(projectEntityID: id)
    }
    
    func loadNetworkData() {
        remoteData = projectUseCase.load()
    }
}
