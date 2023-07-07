//
//  LanguageSelectionViewController.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation
import UIKit


class LanguageSelectionViewController: UIViewController {
    
    private let englishLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let russianLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()


    
    private let englishSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let russianSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private var viewModel: LanguageSelectionViewModelProtocol

        init(viewModel: LanguageSelectionViewModelProtocol) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
            self.viewModel.delegate = self
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageDidChange, object: nil)
        setupUI()
        updateSelectedLanguage()
        updateLabels()
    }
    
    @objc func languageDidChange() {
        LocalizationManager.shared.loadLocalizedStrings()
        updateLabels()
    }


    
    private func updateLabels(){
        title = LocalizationManager.shared.localizedString(forKey: "Language")
        englishLabel.text = LocalizationManager.shared.localizedString(forKey: "English")
        russianLabel.text = LocalizationManager.shared.localizedString(forKey: "Russian")
        DispatchQueue.main.async {
            self.englishLabel.setNeedsDisplay()
            self.russianLabel.setNeedsDisplay()
        }
    }




    
    private func setupUI() {
        view.backgroundColor = .white
        englishSwitch.addTarget(self, action: #selector(englishSwitchValueChanged), for: .valueChanged)
        russianSwitch.addTarget(self, action: #selector(russianSwitchValueChanged), for: .valueChanged)
    
        view.addSubview(englishLabel)
        view.addSubview(russianLabel)
        view.addSubview(englishSwitch)
        view.addSubview(russianSwitch)
        
        NSLayoutConstraint.activate([
                    englishLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                    englishLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    
                    englishSwitch.centerYAnchor.constraint(equalTo: englishLabel.centerYAnchor),
                    englishSwitch.leadingAnchor.constraint(equalTo: englishLabel.trailingAnchor, constant: 8),
                    
                    russianLabel.topAnchor.constraint(equalTo: englishLabel.bottomAnchor, constant: 16),
                    russianLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    
                    russianSwitch.centerYAnchor.constraint(equalTo: russianLabel.centerYAnchor),
                    russianSwitch.leadingAnchor.constraint(equalTo: russianLabel.trailingAnchor, constant: 8),
                ])
    }
    
    private func updateSelectedLanguage() {
        let currentLanguage = LanguageManager.shared.currentLanguage

        DispatchQueue.main.async {
            switch currentLanguage {
            case "en":
                self.englishSwitch.isOn = true
                self.russianSwitch.isOn = false
            case "ru":
                self.englishSwitch.isOn = false
                self.russianSwitch.isOn = true
            default:
                break
            }

            self.englishSwitch.setNeedsDisplay()
            self.russianSwitch.setNeedsDisplay()
        }
    }



    
    @objc private func englishSwitchValueChanged() {
        viewModel.selectLanguage("en")
    }
    
    @objc private func russianSwitchValueChanged() {
        viewModel.selectLanguage("ru")
    }
}

extension LanguageSelectionViewController: LanguageSelectionViewModelDelegate {
    func didSelectLanguage() {
        updateSelectedLanguage()
    }
}
