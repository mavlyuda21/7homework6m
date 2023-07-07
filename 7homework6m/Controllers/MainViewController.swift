//
//  MainViewController.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation
import UIKit


class MainViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var viewModel: MainViewModelProtocol
    
    init(viewModel: MainViewModelProtocol = MainViewModel(apiManager: APIManager.shared, coreDataManager: CoreDataManager.shared)) {
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
        languageDidChange()
        viewModel.loadIPAddresses()
    }
    
    @objc func languageDidChange() {
        LocalizationManager.shared.loadLocalizedStrings()
        title = LocalizationManager.shared.localizedString(forKey: "Main")
        titleLabel.text = LocalizationManager.shared.localizedString(forKey: "IPHistory")
        fetchButton.setTitle(LocalizationManager.shared.localizedString(forKey: "FetchIPAddress"), for: .normal)
        deleteButton.setTitle(LocalizationManager.shared.localizedString(forKey: "DeleteAll"), for: .normal)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        fetchButton.addTarget(self, action: #selector(fetchButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(titleLabel)
        view.addSubview(fetchButton)
        view.addSubview(deleteButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            fetchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

    }
    
    @objc private func fetchButtonTapped() {
        viewModel.fetchIPAddress()
    }
    
    @objc private func deleteButtonTapped() {
        let alertController = UIAlertController(title: LocalizationManager.shared.localizedString(forKey: "ClearAll"), message: LocalizationManager.shared.localizedString(forKey: "SureToDelete"), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "Cancel"), style: .cancel, handler: nil)
                let deleteAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "Delete"), style: .destructive) { _ in
                    self.viewModel.deleteAllIPAddresses()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                present(alertController, animated: true, completion: nil)
    }
}

extension MainViewController: MainViewModelDelegate {
    func ipAddressFetched() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func ipAddressFetchFailed(with error: Error) {
        // Обработка ошибки при загрузке IP адреса
    }
    
    func ipAddressesDeleted() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func ipAddressDeletionFailed(with error: Error) {
        // Обработка ошибки при удалении IP адресов
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfIPAddresses()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let ipAddress = viewModel.ipAddress(at: indexPath.row)
        cell.textLabel?.text = ipAddress
        return cell
    }
}
