//
//  MainViewModel.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func ipAddressFetched()
    func ipAddressFetchFailed(with error: Error)
    func ipAddressesDeleted()
    func ipAddressDeletionFailed(with error: Error)
}

protocol MainViewModelProtocol {
    var delegate: MainViewModelDelegate?{get set}
    var ipAddresses: [SavedIPAddress] {get}
    func fetchIPAddress()
    func loadIPAddresses()
    func numberOfIPAddresses() -> Int
    func ipAddress(at: Int) -> String
    func deleteAllIPAddresses()
}

class MainViewModel: MainViewModelProtocol {
    weak var delegate: MainViewModelDelegate?
    private let apiManager: APIManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    
    var ipAddresses: [SavedIPAddress] = []
    
    init(apiManager: APIManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
    }
    
    func fetchIPAddress() {
        apiManager.fetchIPAddress { [weak self] result in
            switch result {
            case .success(let ipAddress):
                self?.coreDataManager.saveIPAddress(ipAddress)
                self?.loadIPAddresses()
                self?.delegate?.ipAddressFetched()
            case .failure(let error):
                print("Failed to fetch IP address: \(error)")
            }
        }
    }
    
    func loadIPAddresses() {
        ipAddresses = coreDataManager.fetchIPAddresses()
    }
    
    func numberOfIPAddresses() -> Int{
        return ipAddresses.count
    }
    
    func ipAddress(at: Int) -> String{
        return ipAddresses[at].ipAddress ?? ""
    }
    
    func deleteAllIPAddresses() {
        coreDataManager.deleteAllIPAddresses()
        loadIPAddresses()
        delegate?.ipAddressesDeleted()
    }
}
