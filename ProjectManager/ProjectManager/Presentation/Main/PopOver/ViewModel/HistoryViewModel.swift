//
//  HistoryViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/26.
//

import RxCocoa
import RxRelay

protocol HistoryViewModelInputProtocol {
    func viewDidLoad()
}

protocol HistoryViewModelOutputProtocol {
    var currentHistory: Driver<[HistoryEntity]>? { get }
}

protocol HistoryViewModelProtocol: HistoryViewModelInputProtocol, HistoryViewModelOutputProtocol { }

final class HistoryViewModel: HistoryViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    private lazy var history: BehaviorRelay<[HistoryEntity]> = {
        return projectUseCase.readHistory()
    }()
    
    // MARK: - Output
    
    var currentHistory: Driver<[HistoryEntity]>?
    
    init(projectUseCase: ProjectUseCaseProtocol) {
        self.projectUseCase = projectUseCase
    }
}

// MARK: - Output

extension HistoryViewModel {
    func viewDidLoad() {
        currentHistory = history.map {
            $0.sorted { $0.date > $1.date }
        }.asDriver(onErrorJustReturn: [])
    }
}
