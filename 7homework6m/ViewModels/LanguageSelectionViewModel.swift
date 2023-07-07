//
//  LanguageSelectionViewModel.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation

protocol LanguageSelectionViewModelProtocol {
    func selectLanguage(_ languageCode: String)
    var delegate: (LanguageSelectionViewModelDelegate)? { get set }
}


protocol LanguageSelectionViewModelDelegate: AnyObject {
    func didSelectLanguage()
}

class LanguageSelectionViewModel: LanguageSelectionViewModelProtocol {
    weak var delegate: LanguageSelectionViewModelDelegate?
    
    private let localizationManager: LocalizationManagerProtocol
        let languageManager: LanguageManagerProtocol
        
        init(localizationManager: LocalizationManagerProtocol, languageManager: LanguageManagerProtocol) {
            self.localizationManager = localizationManager
            self.languageManager = languageManager
        }
    
    func selectLanguage(_ languageCode: String) {
        LanguageManager.shared.currentLanguage = languageCode
        delegate?.didSelectLanguage()
    }
}
