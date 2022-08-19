//
//  MainVCViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/06.
//

import RxSwift
import RxCocoa
import RxGesture

protocol MainVCViewModelInputProtocol {
    func didTap(_ id: UUID?)
    func didTapLoadButton()
}

protocol MainVCViewModelOutputProtocol {
    var currnetProjectEntity: ProjectEntity? { get }
    var remoteData: Disposable? { get }
}

protocol MainVCViewModelProtocol: MainVCViewModelInputProtocol, MainVCViewModelOutputProtocol { }

final class MainVCViewModel: MainVCViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    private lazy var projects: BehaviorRelay<[ProjectEntity]> = {
        return projectUseCase.read()
    }()
    
    // MARK: - Output
    
    var currnetProjectEntity: ProjectEntity?
    var remoteData: Disposable?
    
    init(projectUseCase: ProjectUseCaseProtocol) {
        self.projectUseCase = projectUseCase
    }
}

// MARK: - Input

extension MainVCViewModel {
    func didTap(_ id: UUID?) {
        currnetProjectEntity = projectUseCase.read(projectEntityID: id)
    }
    
    func didTapLoadButton() {
        remoteData = projectUseCase.load()
    }
}
