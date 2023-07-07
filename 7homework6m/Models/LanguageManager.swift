//
//  LanguageManager.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation
import UIKit

protocol LanguageManagerProtocol{
    var currentLanguage: String {get}
    func updateBundle()
    func reloadRootViewController()
}

class LanguageManager: LanguageManagerProtocol {
    static let shared = LanguageManager()
    
    private init() {}
    
    var currentLanguage: String {
        get {
            return UserDefaults.standard.array(forKey: "AppleLanguages")![0] as! String
        }
        set {
            guard let path = Bundle.main.path(forResource: newValue, ofType: "lproj") else { return }
            let bundle = Bundle(path: path)!
            object_setClass(Bundle.main, type(of: bundle))
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .languageDidChange, object: nil)
        }
    }
    
    func updateBundle() {
            guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") else { return }
            let bundle = Bundle(path: path)
        object_setClass(Bundle.main, type(of: bundle!))
    }
    
    func reloadRootViewController() {
            guard let window = UIApplication.shared.delegate?.window else { return }
            let rootViewController = window?.rootViewController
            window?.rootViewController = nil
            window?.rootViewController = rootViewController
        }
}

extension Notification.Name {
    static let languageDidChange = Notification.Name("LanguageDidChange")
}
