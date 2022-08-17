//
//  RegistrationViewModel.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/07.
//

import Foundation

struct RegistrationViewModel {
    private let projectUseCase: ProjectUseCase
    
    init(projectUseCase: ProjectUseCase) {
        self.projectUseCase = projectUseCase
    }
    
    private func registrateHistory(by content: ProjectEntity) {
        let historyEntity = HistoryEntity(
            editedType: .register,
            title: content.title,
            date: Date().timeIntervalSince1970
        )
        
        projectUseCase.createHistory(historyEntity: historyEntity)
    }
    
    func registrate(title: String, date: Date, body: String) {
        let newProject = ProjectEntity(
            title: title,
            deadline: date,
            body: body
        )
        
        projectUseCase.create(projectEntity: newProject)
        registrateHistory(by: newProject)
    }
}
