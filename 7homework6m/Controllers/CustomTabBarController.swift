//
//  CustomTabBarController.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    let dependencyContainer = DependencyContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(red: 67/255,
                                   green: 95/255,
                                   blue: 209/255,
                                   alpha: 1)
        
        let mainVM = MainViewController()
        let mainNav = UINavigationController(rootViewController: dependencyContainer.createMainViewController())

        let menuNav = UINavigationController(rootViewController: dependencyContainer.createLanguageSelectionViewController())
        
        
        mainNav.tabBarItem = UITabBarItem(title: NSLocalizedString("Main", comment: ""),
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(systemName: "house.fill"))

        menuNav.tabBarItem = UITabBarItem(title: NSLocalizedString("Language", comment: ""),
                                          image: UIImage(systemName: "line.3.horizontal"),
                                          selectedImage: UIImage(systemName: "line.3.horizontal"))

        let viewControllers = [mainNav,
                               menuNav]
        self.setViewControllers(viewControllers, animated: false)
        
    }
}
