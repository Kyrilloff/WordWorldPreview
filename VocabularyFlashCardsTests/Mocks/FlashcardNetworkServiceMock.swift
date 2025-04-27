//
//  FlashcardNetworkServiceMock.swift
//  VocabularyFlashCardsTests
//
//  Created by Konrad Schmid on 26.04.25.
//

import SwiftUI
@testable import VocabularyFlashCards

class FlashcardNetworkServiceMock: FlashcardNetworkServiceProtocol {
    var saveFlashcardSucceeds = false
    let saveFlashcardErrorResult = NetworkError.duplicate
    
    var updateFlashcardSucceeds = false
    let updateFlashcardSuccessResult = FlashcardContent.testFlashcard
    let updateFlashcardErrorResult = NetworkError.noData
    
    var loadLanguageFlashcardsSucceeds = false
    let loadLanguageFlashcardsSuccessResult = FlashcardContent.testFlashcards
    let loadLanguageFlashcardsErrorResult = NetworkError.noData
    
    var loadflashcardWithUUIDSucceeds = false
    let loadFlashcardWithUUIDSuccessResult = FlashcardContent.testFlashcard
    let loadFlashcardWithUUIDErrorResult = NetworkError.noData
    
    var loadflashcardWithWordSucceeds = false
    let loadFlashcardWithWordSuccessResult = [FlashcardContent.testFlashcard]
    let loadFlashcardWithWordErrorResult = NetworkError.noData
    
    var loadAvailableLanguagesSucceeds = false
    let loadAvailableLanguagesSuccessResult = ["italian", "portuguese"]
    let loadAvailableLanguagesErrorResult = NetworkError.noData
    
    var addLanguageSucceeds = false
    let addLanguageErrorResult = NetworkError.unauthorized
    
    func save(_ flashcard: FlashcardContent, for language: Language) async throws {
        if !saveFlashcardSucceeds {
            throw saveFlashcardErrorResult
        }
    }
    
    func update(_ flashcard: FlashcardContent, for language: Language) async throws -> FlashcardContent {
        if updateFlashcardSucceeds {
            updateFlashcardSuccessResult
        } else {
            throw updateFlashcardErrorResult
        }
    }
    
    func load(language: Language) async throws -> [FlashcardContent]? {
        if loadLanguageFlashcardsSucceeds {
            loadLanguageFlashcardsSuccessResult
        } else {
            throw loadLanguageFlashcardsErrorResult
        }
    }
    
    func loadSpecificFlashcard(with uuid: UUID, for language: Language) async throws -> FlashcardContent? {
        if loadflashcardWithUUIDSucceeds {
            loadFlashcardWithUUIDSuccessResult
        } else {
            throw loadFlashcardWithUUIDErrorResult
        }
    }
    
    func loadSpecificFlashcardWithWord(containing originalMeaning: String, for language: Language) async throws -> [FlashcardContent]? {
        if loadflashcardWithWordSucceeds {
            loadFlashcardWithWordSuccessResult
        } else {
            throw loadFlashcardWithWordErrorResult
        }
    }
    
    func loadAvailableLanguages() async throws -> [String] {
        if loadAvailableLanguagesSucceeds {
            loadAvailableLanguagesSuccessResult
        } else {
            throw loadAvailableLanguagesErrorResult
        }
    }
    
    func addLanguage(_ languageCode: String, firstWord: Word) async throws {
        if !addLanguageSucceeds {
            throw addLanguageErrorResult
        }
    }
}
