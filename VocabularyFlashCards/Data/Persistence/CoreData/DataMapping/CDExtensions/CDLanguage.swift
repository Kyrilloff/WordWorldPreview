//
//  CDLanguage.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import CoreData

@MainActor
extension CDLanguage {
    static func loadAllLanguages(context: NSManagedObjectContext) async throws -> [Language] {
        let request = CDLanguage.fetchRequest()
        
        let fetchResult = try context.fetch(request)
        return fetchResult.compactMap(\.language)
    }
    
    static func saveOrUpdateLanguages(_ languageNames: [String],
                                      context: NSManagedObjectContext) async throws -> [Language] {
        
        for languageName in languageNames {
            if (try await fetchLanguage(with: languageName, context: context)) == nil {
                // create
                try await createLanguage(languageName,
                                         context: context)
            }
        }
        
        let allLanguages = try await loadAllLanguages(context: context)
        return allLanguages
    }
    
    static func setLanguageAsCurrent(languageName: String,
                                     context: NSManagedObjectContext) async throws {
        // RESET old current language first
        // TODO: make more efficient
        if let oldCurrentLanguage = try await loadCurrentLanguage(context: context),
           let oldCurrentCDLanguage = try await fetchLanguage(with: oldCurrentLanguage.name, context: context) {
            var oldCurrentLanguageUpdated = oldCurrentLanguage
            oldCurrentLanguageUpdated.isCurrent = false
            
            try await updateLanguage(oldCurrentCDLanguage, with: oldCurrentLanguageUpdated, context: context)
        }
        
        guard let existingLanguage = try await fetchLanguage(with: languageName, context: context),
              var language = existingLanguage.language else {
            throw StorageError.dataNotFound
        }
        
        language.isCurrent = true
        
        try await updateLanguage(existingLanguage,
                                 with: language,
                                 context: context)
    }
    
    static func loadCurrentLanguage(context: NSManagedObjectContext) async throws -> Language? {
        
        let languages = try await loadAllLanguages(context: context)
        return languages.first(where: { $0.isCurrent })
    }
    
    static func deleteAllLanguages(context: NSManagedObjectContext) async throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDLanguage")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        // Batch Delete ausführen
        let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
        if let objectIDs = result?.result as? [NSManagedObjectID] {
            // Kontext aktualisieren, damit View-Updates korrekt sind
            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: objectIDs
            ]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        }
    }
    
    private static func updateLanguage(_ existingLanguage: CDLanguage,
                                       with language: Language,
                                       context: NSManagedObjectContext) async throws {
        
        log.info("Updating language in local storage")
        
        existingLanguage.name = language.name
        existingLanguage.isCurrent = language.isCurrent
        
        try context.save()
    }
    
    private static func createLanguage(_ languageName: String,
                                       context: NSManagedObjectContext) async throws {
        log.info("Creating language in local storage")
        
        let newLanguage = CDLanguage(context: context)
        newLanguage.id = UUID()
        newLanguage.name = languageName
        
        try context.save()
    }
    
    private static func fetchLanguage(with name: String,
                                      context: NSManagedObjectContext)  async throws -> CDLanguage? {
        let request = CDLanguage.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name as CVarArg)
        request.fetchLimit = 1
        
        return try context.fetch(request).first
    }

}

extension CDLanguage {
    var language: Language? {
        guard let id,
              let name else {
            log.error("Casting CDLanguage to Language failed due to lack of data")
            return nil
        }
        
        return Language(id: id,
                        name: name,
                        isCurrent: isCurrent)
        
    }
}
