//
//  DetailViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

import Foundation
import RxRelay

protocol DetailViewModelInputProtocol {
    func update(_ content: ProjectEntity)
    func didTapLeftButton()
    func didTapRightButton()
}

protocol DetailViewModelOutputProtocol {
    var content: ProjectEntity? { get }
}

protocol DetailViewModelProtocol: DetailViewModelInputProtocol, DetailViewModelOutputProtocol { }

final class DetailViewModel: DetailViewModelProtocol {
    enum Mode {
        case display
        case edit
    }
    
    private let projectUseCase: ProjectUseCaseProtocol
    let mode = BehaviorRelay<Mode>(value: .display)
    weak var delegate: DetailViewModelDelegate?
    
    // MARK: - Output
    
    var content: ProjectEntity?
    
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
    func update(_ content: ProjectEntity) {
        self.content = content
        projectUseCase.update(projectEntity: content)
        updateHistory(by: content)
    }
    
    func didTapLeftButton() {
        switch mode.value {
        case .display:
            didTapEditButton()
        case .edit:
            didTapCancelButton()
        }
    }
    
    func didTapRightButton() {
        switch mode.value {
        case .display:
            didTapDoneButton()
        case .edit:
            didTapSaveButton()
        }
    }
}

extension DetailViewModel {
    private func didTapEditButton() {
        mode.accept(.edit)
    }
    
    private func didTapCancelButton() {
        mode.accept(.display)
    }
    
    private func didTapSaveButton() {
        delegate?.save()
        mode.accept(.display)
    }
    
    private func didTapDoneButton() {
        delegate?.close()
    }
}
