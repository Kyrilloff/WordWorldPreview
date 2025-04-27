//
//  LanguageRepositoryTests.swift
//  VocabularyFlashCardsTests
//
//  Created by Konrad Schmid on 27.04.25.
//

import Testing
@testable import VocabularyFlashCards

@MainActor
struct LanguageRepositoryTests {
    var sut: LanguageRepository
    let mockNetworkService = FlashcardNetworkServiceMock()
    let mockLocalStorageService = LanguageLocalStorageServiceMock()
    
    init() {
        sut = LanguageRepository(networkService: mockNetworkService,
                                 localStorageService: mockLocalStorageService)
    }
    
    @Test("Load Available Languages Failure")
    func loadAvailableLanguagesFailure() async throws {
        mockNetworkService.loadAvailableLanguagesSucceeds = false
        
        await #expect(throws: NetworkError.noData) {
            try await sut.loadAvailableLanguages()
        }
    }
    
    @Test("Load Available Languages Failure - Local Storage Failure")
    func loadAvailableLanguagesLocalStorageFailure() async throws {
        mockNetworkService.loadAvailableLanguagesSucceeds = true
        mockLocalStorageService.saveLanguagesSucceeds = false
        
        await #expect(throws: StorageError.storingFailed) {
            try await sut.loadAvailableLanguages()
        }
    }
    
    @Test("Load Available Languages Success")
    func loadAvailableLanguagesSuccess() async throws {
        mockNetworkService.loadAvailableLanguagesSucceeds = true
        mockLocalStorageService.saveLanguagesSucceeds = true
        
        do {
            let availableLanguages = try await sut.loadAvailableLanguages()
            #expect(!availableLanguages.isEmpty)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Add Language Failure")
    func addLanguageFailure() async throws {
        mockNetworkService.addLanguageSucceeds = false
        
        await #expect(throws: NetworkError.unauthorized) {
            try await sut.addLanguage("english",
                                      firstWord: Word.testWord)
        }
    }
    
    @Test("Add Language Failure - Network Loading Failure")
    func addLanguageNetworkLoadingFailure() async throws {
        mockNetworkService.addLanguageSucceeds = true
        mockNetworkService.loadAvailableLanguagesSucceeds = false
        
        await #expect(throws: NetworkError.noData) {
            try await sut.addLanguage("english",
                                      firstWord: Word.testWord)
        }
    }
    
    @Test("Add Language Failure - Local Storage Failure")
    func addLanguageLocalStorageFailure() async throws {
        mockNetworkService.addLanguageSucceeds = true
        mockNetworkService.loadAvailableLanguagesSucceeds = true
        mockLocalStorageService.saveLanguagesSucceeds = false
        
        await #expect(throws: StorageError.storingFailed) {
            try await sut.addLanguage("english",
                                      firstWord: Word.testWord)
        }
    }
    
    @Test("Add Language Success")
    func addLanguageSuccess() async throws {
        mockNetworkService.addLanguageSucceeds = true
        mockNetworkService.loadAvailableLanguagesSucceeds = true
        mockLocalStorageService.saveLanguagesSucceeds = true
        do {
            try await sut.addLanguage("english",
                                      firstWord: Word.testWord)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Save Current Language Failure")
    func saveCurrentLanguageFailure() async throws {
        mockLocalStorageService.setCurrentLanguageSucceeds = false
        
        await #expect(throws: StorageError.storingFailed) {
            try await sut.saveCurrentLanguage(language: "english")
        }
    }
    
    @Test("Save Current Language Success")
    func saveCurrentLanguageSuccess() async throws {
        mockLocalStorageService.setCurrentLanguageSucceeds = true
        
        do {
            try await sut.saveCurrentLanguage(language: "english")
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Load Current Language Failure")
    func loadCurrentLanguageFailure() async throws {
        mockLocalStorageService.loadCurrentLanguageSucceeds = false
        
        await #expect(throws: StorageError.currentLanguageIsNotSet) {
            try await sut.loadCurrentLanguage()
        }
    }
    
    @Test("Load Current Language Success")
    func loadCurrentLanguageSuccess() async throws {
        mockLocalStorageService.loadCurrentLanguageSucceeds = true
        
        do {
            let currentLanguage = try await sut.loadCurrentLanguage()
            #expect(currentLanguage == Language.testLanguageCurrent)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Delete Local Languages Failure")
    func deleteLocalLanguagesFailure() async throws {
        mockLocalStorageService.deleteAllLanguagesSucceeds = false
        
        await #expect(throws: StorageError.dataNotFound) {
            try await sut.deleteAllLocalLanguages()
        }
    }
    
    @Test("Delete Local Languages Success")
    func deleteLocalLanguagesSuccess() async throws {
        mockLocalStorageService.deleteAllLanguagesSucceeds = true
        
        do {
            try await sut.deleteAllLocalLanguages()
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
}
