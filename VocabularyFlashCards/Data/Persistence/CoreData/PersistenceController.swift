//
//  PersistenceController.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 08.12.24.
//


import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(forTesting: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataStorage")
        
        log.info("PersistenceController is for testing: \(forTesting)")
        
        if forTesting {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
