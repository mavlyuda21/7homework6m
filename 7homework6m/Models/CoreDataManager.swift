//
//  CoreDataManager.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol{
    var persistentContainer: NSPersistentContainer{get}
    var context: NSManagedObjectContext{get}
    func saveContext()
    func saveIPAddress(_ ipAddress: String)
    func fetchIPAddresses() -> [SavedIPAddress]
    func deleteAllIPAddresses()
}

class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedIPAddress")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func saveIPAddress(_ ipAddress: String) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "SavedIPAddress", in: context)!
        let savedIPAddress = SavedIPAddress(entity: entityDescription, insertInto: context)
        savedIPAddress.ipAddress = ipAddress
        saveContext()
    }
    
    func fetchIPAddresses() -> [SavedIPAddress] {
        let fetchRequest: NSFetchRequest<SavedIPAddress> = SavedIPAddress.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Failed to fetch IP addresses: \(error)")
            return []
        }
    }
    
    func deleteAllIPAddresses() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SavedIPAddress")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete IP addresses: \(error)")
        }
    }
}
