//
//  RegistrationViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

import Foundation

protocol RegistrationViewModelInputProtocol {
    func registrate(title: String, date: Date, body: String)
}

protocol RegistrationViewModelOutputProtocol { }

protocol RegistrationViewModelProtocol: RegistrationViewModelInputProtocol, RegistrationViewModelOutputProtocol { }

final class RegistrationViewModel: RegistrationViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    
    init(projectUseCase: ProjectUseCaseProtocol) {
        self.projectUseCase = projectUseCase
    }
    
    private func registrateHistory(by content: ProjectEntity) {
        let historyEntity = HistoryEntity(editedType: .register,
                                          title: content.title,
                                          date: Date().timeIntervalSince1970)
        
        projectUseCase.createHistory(historyEntity: historyEntity)
    }
}

// MARK: - Input

extension RegistrationViewModel {
    func registrate(title: String, date: Date, body: String) {
        let newProject = ProjectEntity(title: title, deadline: date, body: body)
        
        projectUseCase.create(projectEntity: newProject)
        registrateHistory(by: newProject)
    }
}
