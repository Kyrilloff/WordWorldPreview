//
//  LanguageLocalStorageTests.swift
//  VocabularyFlashCardsTests
//
//  Created by Konrad Schmid on 26.04.25.
//

import Testing
@testable import VocabularyFlashCards

@MainActor
struct LanguageLocalStorageTests {
    var sut: LanguageLocalStorageService
    
    init() {
        let persistence = PersistenceController(forTesting: true)
        let context = persistence.container.viewContext
        self.sut = LanguageLocalStorageService(context: context)
    }
    
    @Test("Save Languages Success")
    func saveLanguagesSuccess() async throws {
        let languages = Language.testLanguages.map(\.name)
        
        do {
            let savedLanguages = try await sut.saveLanguages(languages)
            #expect(savedLanguages.map(\.name).sorted() == languages.sorted())
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Load Languages Success")
    func loadLanguagesSuccess() async throws {
        do {
            let languages = Language.testLanguages.map(\.name)
            let savedLanguages = try await sut.saveLanguages(languages)
            let loadedLanguages = try await sut.loadLanguages()
            #expect(savedLanguages == loadedLanguages)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Load Current Language Failure")
    func loadCurrentLanguageFailure() async throws {
        do {
            let currentLanguage = try await sut.loadCurrentLanguage()
            #expect(currentLanguage == nil)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Set and Load Current Language Success")
    func setAndLoadCurrentLanguageSuccess() async throws {
        do {
            let languages = ["dutch", "english", "italian"]
            _ = try await sut.saveLanguages(languages)
            try await sut.setCurrentLanguage(languageName: languages[0])
            
            let currentLanguageLoaded = try await sut.loadCurrentLanguage()
            #expect(currentLanguageLoaded?.name == languages[0])
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
}
