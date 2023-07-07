//
//  LocalizationManager.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation

protocol LocalizationManagerProtocol{
    func localizedString(forKey key: String) -> String
    func loadLocalizedStrings()
}

class LocalizationManager: LocalizationManagerProtocol {
    static let shared = LocalizationManager()
    
    private var localizedStrings: [String: String] = [:]
    
    private init() {
        loadLocalizedStrings()
    }
    
    func localizedString(forKey key: String) -> String {
        return localizedStrings[key] ?? ""
    }
    
    func loadLocalizedStrings() {
        let currentLanguage = LanguageManager.shared.currentLanguage
        
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            let languageBundle = Bundle(path: path)
            localizedStrings = NSDictionary(contentsOfFile: languageBundle?.path(forResource: "Localizable", ofType: "strings") ?? "") as? [String: String] ?? [:]
        } else {
            localizedStrings = [:]
        }
    }
}
