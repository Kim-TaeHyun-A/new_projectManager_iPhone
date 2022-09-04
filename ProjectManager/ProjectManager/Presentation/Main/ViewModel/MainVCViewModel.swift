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
    func viewDidLoad(_ viewController: NetworkConditionDelegate)
}

protocol MainVCViewModelOutputProtocol {
    var currentProjectEntity: ProjectEntity? { get }
}

protocol MainVCViewModelProtocol: MainVCViewModelInputProtocol, MainVCViewModelOutputProtocol { }

final class MainVCViewModel: MainVCViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    private let networkCondition: NetworkCondition
    private lazy var projects: BehaviorRelay<[ProjectEntity]> = {
        return projectUseCase.read()
    }()
    private let disposeBag = DisposeBag()
    
    // MARK: - Output
    
    var currentProjectEntity: ProjectEntity?
    
    init(projectUseCase: ProjectUseCaseProtocol, networkCondition: NetworkCondition) {
        self.projectUseCase = projectUseCase
        self.networkCondition = networkCondition
    }
}

// MARK: - Input

extension MainVCViewModel {
    func didTapCell(_ id: UUID?) {
        currentProjectEntity = projectUseCase.read(projectEntityID: id)
    }
    
    func didTapLoadButton() {
        projectUseCase.load().disposed(by: disposeBag)
    }
    
    func viewDidLoad(_ viewController: NetworkConditionDelegate) {
        networkCondition.delegate = viewController
    }
}
