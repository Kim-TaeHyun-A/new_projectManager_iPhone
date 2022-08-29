//
//  ProjectManager - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let dependencies = SceneDIContainer.Dependencies(networkService: NetworkService(),
                                                                    networkCondition: NetworkCondition())
    private lazy var sceneDIContainer = SceneDIContainer(dependencies: dependencies)
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = UINavigationController(rootViewController: sceneDIContainer
            .makeMainViewController(with: sceneDIContainer))
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        sceneDIContainer.projectUseCase.backUp()
    }
}
