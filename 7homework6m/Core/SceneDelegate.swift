//
//  SceneDelegate.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    var dependencyContainer: DependencyContainerProtocol!

        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            dependencyContainer = DependencyContainer()
            
            let tabBarController = dependencyContainer.createTabBarController()
            
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        }
}


