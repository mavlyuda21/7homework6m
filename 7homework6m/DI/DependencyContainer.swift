//
//  DependencyContainer.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation
import UIKit

protocol DependencyContainerProtocol {
    func createTabBarController() -> UITabBarController
    func createLanguageSelectionViewController() -> LanguageSelectionViewController
    func createMainViewController() -> MainViewController
    func createLocalizationManager() -> LocalizationManagerProtocol
    func createAPIManager() -> APIManagerProtocol
    func createLanguageManager() -> LanguageManagerProtocol
    func createCoreDataManager() -> CoreDataManagerProtocol
}

class DependencyContainer: DependencyContainerProtocol {
    private let localizationManager: LocalizationManagerProtocol
    private let apiManager: APIManagerProtocol
    private let languageManager: LanguageManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    
    init() {
        localizationManager = LocalizationManager.shared
        apiManager = APIManager.shared
        languageManager = LanguageManager.shared
        coreDataManager = CoreDataManager.shared
    }
    
    func createTabBarController() -> UITabBarController {
        let tabBarController = CustomTabBarController()
        
        return tabBarController
    }
    
    func createLanguageSelectionViewController() -> LanguageSelectionViewController {
        let viewModel = LanguageSelectionViewModel(localizationManager: localizationManager, languageManager: languageManager)
        return LanguageSelectionViewController(viewModel: viewModel)
    }
    
    func createMainViewController() -> MainViewController {
        let viewModel = MainViewModel(apiManager: apiManager, coreDataManager: coreDataManager)
        return MainViewController(viewModel: viewModel)
    }
    
    func createLocalizationManager() -> LocalizationManagerProtocol {
        return localizationManager
    }
    
    func createAPIManager() -> APIManagerProtocol {
        return apiManager
    }
    
    func createLanguageManager() -> LanguageManagerProtocol {
        return languageManager
    }
    
    func createCoreDataManager() -> CoreDataManagerProtocol {
        return coreDataManager
    }
}

