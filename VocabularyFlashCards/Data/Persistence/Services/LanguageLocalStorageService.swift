//
//  LanguageLocalStorageService.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 27.04.25.
//

import CoreData

@MainActor
protocol LanguageLocalStorageServiceProtocol {
    func saveLanguages(_ languages: [String]) async throws -> [Language]
    func loadLanguages() async throws -> [Language]
    func setCurrentLanguage(languageName: String) async throws
    func loadCurrentLanguage() async throws -> Language?
    func deleteAllLanguages() async throws
}

struct LanguageLocalStorageService: LanguageLocalStorageServiceProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func saveLanguages(_ languages: [String]) async throws -> [Language] {
        let languages = try await CDLanguage.saveOrUpdateLanguages(languages,
                                                                   context: context).sorted()
        
        // check if currentLanguage is set
        if languages.first(where: { $0.isCurrent }) != nil {
            return languages
        } else {
            // set if no current language exists
            if let firstLanguage = languages.first {
                try await CDLanguage.setLanguageAsCurrent(languageName: firstLanguage.name, context: context)
                return try await CDLanguage.loadAllLanguages(context: context)
            } else {
                return languages
            }
        }
    }
    
    func loadLanguages() async throws -> [Language] {
        try await CDLanguage.loadAllLanguages(context: context)
    }
    
    func setCurrentLanguage(languageName: String) async throws {
        log.info("Setting current language: \(languageName)")
        try await CDLanguage.setLanguageAsCurrent(languageName: languageName, context: context)
    }
    
    func loadCurrentLanguage() async throws -> Language? {
        try await CDLanguage.loadCurrentLanguage(context: context)
    }
    
    func deleteAllLanguages() async throws {
        try await CDLanguage.deleteAllLanguages(context: context)
    }
}
