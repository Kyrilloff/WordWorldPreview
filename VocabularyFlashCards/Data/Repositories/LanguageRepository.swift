//
//  LanguageRepository.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 27.04.25.
//

import Foundation

@MainActor
protocol LanguageRepositoryProtocol {
    func loadAvailableLanguages() async throws -> [Language]
    func addLanguage(_ language: String, firstWord: Word) async throws
    func loadCurrentLanguage() async throws -> Language?
    func saveCurrentLanguage(language: String) async throws
    func deleteAllLocalLanguages() async throws
}

struct LanguageRepository: LanguageRepositoryProtocol {
    let networkService: FlashcardNetworkServiceProtocol
    let localStorageService: LanguageLocalStorageServiceProtocol
    
    init(networkService: FlashcardNetworkServiceProtocol = FlashcardNetworkService(),
         localStorageService: LanguageLocalStorageServiceProtocol = LanguageLocalStorageService()) {
        self.networkService = networkService
        self.localStorageService = localStorageService
    }
    
    func loadAvailableLanguages() async throws -> [Language] {
        let languages = try await networkService.loadAvailableLanguages()
        let localLanguages = try await localStorageService.saveLanguages(languages)
        return localLanguages
        
    }
    
    func saveCurrentLanguage(language: String) async throws {
        try await localStorageService.setCurrentLanguage(languageName: language)
    }
    
    func loadCurrentLanguage() async throws -> Language? {
        try await localStorageService.loadCurrentLanguage()
    }
    
    func addLanguage(_ language: String, firstWord: Word) async throws {
        try await networkService.addLanguage(language, firstWord: firstWord)
        _ = try await loadAvailableLanguages()
    }
    
    func deleteAllLocalLanguages() async throws {
        try await localStorageService.deleteAllLanguages()
    }
}
