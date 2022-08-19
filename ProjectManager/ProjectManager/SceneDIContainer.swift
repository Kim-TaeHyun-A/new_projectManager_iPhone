//
//  SceneDIContainer.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/27.
//

import UIKit

final class SceneDIContainer {
    lazy var projectUseCase = makeProjectUseCase()
    
    // MARK: - Manager
    
    private func makePersistentManager() -> PersistentManager {
        return PersistentManager()
    }
    
    private func makeNetworkManager() -> NetworkManager {
        return NetworkManager()
    }
    
    private func makeHistoryManager() -> HistoryManager {
        return HistoryManager()
    }
    
    // MARK: - Repository
    
    private func makeProjectRepository() -> PersistentRepository {
        return PersistentRepository(persistentManager: makePersistentManager())
    }
    
    private func makeNetworkRepository() -> NetworkRepository {
        return NetworkRepository(networkManger: makeNetworkManager())
    }
    
    private func makeHistoryRepository() -> HistoryRepository {
        return HistoryRepository(historyManager: makeHistoryManager())
    }
    
    // MARK: - Use Cases
    
    private func makeProjectUseCase() -> ProjectUseCaseProtocol {
        return DefaultProjectUseCase(
            projectRepository: makeProjectRepository(),
            networkRepository: makeNetworkRepository(),
            historyRepository: makeHistoryRepository()
        )
    }
    
    // MARK: - Main
    
    private func makeMainVCViewModel() -> MainVCViewModel {
        return MainVCViewModel(projectUseCase: projectUseCase)
    }
    
    private func makeMainViewModel() -> [ProjectListViewModel] {
        return [ProjectListViewModel(projectUseCase: projectUseCase, status: .todo),
                ProjectListViewModel(projectUseCase: projectUseCase, status: .doing),
                ProjectListViewModel(projectUseCase: projectUseCase, status: .done)]
    }
    
    func makeMainViewController(with sceneDIContainer: SceneDIContainer) -> MainViewController {
        return MainViewController(with: makeMainVCViewModel(), viewModel: makeMainViewModel(), sceneDIContainer)
    }
    
    // MARK: - PopOver
    
    private func makePopOverViewModel(with cell: ProjectCell) -> PopOverViewModel {
        return PopOverViewModel(projectUseCase: projectUseCase, cell: cell)
    }
    
    func makePopOverViewController(with cell: ProjectCell) -> PopOverViewController {
        return PopOverViewController(with: makePopOverViewModel(with: cell))
    }
    
    // MARK: - History
    
    private func makeHistoryViewModel() -> HistoryViewModel {
        return HistoryViewModel(projectUseCase: projectUseCase)
    }
    
    func makeHistoryViewController(with source: UIBarButtonItem) -> HistoryViewController {
        return HistoryViewController(with: makeHistoryViewModel(), source: source)
    }
    
    // MARK: - Detail
    
    private func makeDetailViewModel(with projectEntity: ProjectEntity) -> DetailViewModel {
        return DetailViewModel(projectUseCase: projectUseCase, content: projectEntity)
    }
    
    func makeDetailViewController(with projectEntity: ProjectEntity) -> DetailViewController {
        return DetailViewController(with: makeDetailViewModel(with: projectEntity))
    }
    
    // MARK: - Registration
    
    private func makeRegistrationViewModel() -> RegistrationViewModel {
        return RegistrationViewModel(projectUseCase: projectUseCase)
    }
    
    func makeRegistrationViewController() -> RegistrationViewController {
        return RegistrationViewController(with: makeRegistrationViewModel())
    }
    
    // MARK: - Alert
    
    func makeAlertController(over: UIViewController, title: String, confirmButton: UIAlertAction?) -> AlertController {
        return AlertController(over: over, title: title, confirmButton: confirmButton)
    }
    
}
