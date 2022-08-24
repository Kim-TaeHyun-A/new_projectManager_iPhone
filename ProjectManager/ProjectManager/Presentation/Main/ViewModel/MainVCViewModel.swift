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
    func didTapCell(_ id: UUID?)
    func didTapLoadButton()
}

protocol MainVCViewModelOutputProtocol {
    var currnetProjectEntity: ProjectEntity? { get }
}

protocol MainVCViewModelProtocol: MainVCViewModelInputProtocol, MainVCViewModelOutputProtocol { }

final class MainVCViewModel: MainVCViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    private lazy var projects: BehaviorRelay<[ProjectEntity]> = {
        return projectUseCase.read()
    }()
    private let disposeBag = DisposeBag()
    
    // MARK: - Output
    
    var currnetProjectEntity: ProjectEntity?
    
    init(projectUseCase: ProjectUseCaseProtocol) {
        self.projectUseCase = projectUseCase
    }
}

// MARK: - Input

extension MainVCViewModel {
    func didTapCell(_ id: UUID?) {
        currnetProjectEntity = projectUseCase.read(projectEntityID: id)
    }
    
    func didTapLoadButton() {
        projectUseCase.load().disposed(by: disposeBag)
    }
}
