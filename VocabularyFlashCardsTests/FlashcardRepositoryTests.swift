//
//  FlashcardRepositoryTests.swift
//  VocabularyFlashCardsTests
//
//  Created by Konrad Schmid on 26.04.25.
//

import Testing
@testable import VocabularyFlashCards

@MainActor
struct FlashcardRepositoryTests {
    var sut: FlashcardRepository
    let mockNetworkService = FlashcardNetworkServiceMock()
    let mockLocalStorageService = FlashcardLocalStorageServiceMock()
    
    init() {
        sut = FlashcardRepository(networkService: mockNetworkService,
                                  localStorageService: mockLocalStorageService,
                                  user: User.testUser)
    }
    
    @Test("Save Flashcard Failure")
    func saveFlashcardFailure() async throws {
        mockNetworkService.saveFlashcardSucceeds = false
        
        await #expect(throws: NetworkError.duplicate) {
            try await sut.save(FlashcardContent.testFlashcard, for: Language.testLanguageCurrent)
        }
    }
    
    @Test("Save Flashcard Success")
    func saveFlashcardSuccess() async throws {
        mockNetworkService.saveFlashcardSucceeds = true
        
        do {
            try await sut.save(FlashcardContent.testFlashcard, for: Language.testLanguageCurrent)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Update Flashcard Failure")
    func updateFlashcardFailure() async throws {
        mockNetworkService.updateFlashcardSucceeds = false
        
        await #expect(throws: NetworkError.noData) {
            try await sut.update(FlashcardContent.testFlashcard, for: Language.testLanguage)
        }
    }
    
    @Test("Update Flashcard Success")
    func updateFlashcardSuccess() async throws {
        mockNetworkService.updateFlashcardSucceeds = true
        
        do {
            let updatedFlashcard = try await sut.update(FlashcardContent.testFlashcard, for: Language.testLanguageCurrent)
            #expect(updatedFlashcard == FlashcardContent.testFlashcard)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Load All Flashcards Failure")
    func loadAllFlashcardsFailure() async throws {
        mockNetworkService.loadLanguageFlashcardsSucceeds = false
        
        await #expect(throws: NetworkError.noData) {
            try await sut.loadFlashcards(for: Language.testLanguageCurrent)
        }
    }
    
    @Test("Load All Flashcards Success")
    func loadAllFlashcardsSuccess() async throws {
        mockNetworkService.loadLanguageFlashcardsSucceeds = true
        
        do {
            let flashcards = try await sut.loadFlashcards(for: Language.testLanguageCurrent)
            #expect(flashcards == FlashcardContent.testFlashcards)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Load Flashcard With UUID Failure")
    func loadFlashcardWithUUIDFailure() async throws {
        mockNetworkService.loadflashcardWithUUIDSucceeds = false
        
        await #expect(throws: NetworkError.noData) {
            try await sut.loadSpecificFlashcard(with: FlashcardContent.testFlashcard.id, for: Language.testLanguageCurrent)
        }
    }
    
    @Test("Load Flashcard With UUID Success")
    func loadFlashcardWithUUIDSuccess() async throws {
        mockNetworkService.loadflashcardWithUUIDSucceeds = true
        
        do {
            let flashcard = FlashcardContent.testFlashcard
            let loadedFlashcard = try await sut.loadSpecificFlashcard(with: flashcard.id, for: Language.testLanguageCurrent)
            #expect(loadedFlashcard == flashcard)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Load Flashcard With Word Failure")
    func loadFlashcardWithWordFailure() async throws {
        mockNetworkService.loadflashcardWithWordSucceeds = false
        
        await #expect(throws: NetworkError.noData) {
            try await sut.loadSpecificFlashcardWithWord(containing: FlashcardContent.testFlashcard.word.originalMeaning, for: Language.testLanguageCurrent)
        }
    }
    
    @Test("Load Flashcard With Word Success")
    func loadFlashcardWithWordSuccess() async throws {
        mockNetworkService.loadflashcardWithWordSucceeds = true
        
        do {
            let flashcard = FlashcardContent.testFlashcard
            let loadedFlashcards = try await sut.loadSpecificFlashcardWithWord(containing: flashcard.word.originalMeaning, for: Language.testLanguageCurrent)
            guard let loadedFlashcards else {
                #expect(loadedFlashcards != nil)
                return
            }
            #expect(loadedFlashcards.contains(flashcard))
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Save Repeatable Flashcard Failure")
    func saveRepeatableFlashcardFailure() async throws {
        mockLocalStorageService.saveRepeatableCardSucceeds = false
        
        await #expect(throws: StorageError.storingFailed) {
            try await sut.saveRepeatableFlashcard(FlashcardContent.testFlashcard)
        }
    }
    
    @Test("Save Repeatable Flashcard Success")
    func saveRepeatableFlashcardSuccess() async throws {
        mockLocalStorageService.saveRepeatableCardSucceeds = true
        
        do {
            try await sut.saveRepeatableFlashcard(FlashcardContent.testFlashcard)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Load Repeatable Cards Failure")
    func loadRepeatableCardsFailure() async throws {
        mockLocalStorageService.loadAllRepeatableCardsSucceeds = false
        
        await #expect(throws: StorageError.dataNotFound) {
            try await sut.loadRepeatableFlashcards()
        }
    }
    
    @Test("Load Repeatable Cards Success")
    func loadRepeatableCardsSucceeds() async throws {
        mockLocalStorageService.loadAllRepeatableCardsSucceeds = true
        
        do {
            let cards = try await sut.loadRepeatableFlashcards()
            #expect(cards == FlashcardContent.testFlashcards.map(\.id))
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Delete Repetable Card Failure")
    func deleteRepeatableCardsFailure() async throws {
        mockLocalStorageService.deleteRepeatableCardSucceeds = false
        
        await #expect(throws: StorageError.dataNotFound) {
            try await sut.deleteRepeatableFlashcard(FlashcardContent.testFlashcard)
        }
    }
    
    @Test("Delete Repeatable Card Succeeds")
    func deleteRepeatableCardsSucceeds() async throws {
        mockLocalStorageService.deleteRepeatableCardSucceeds = true
        
        do {
            try await sut.deleteRepeatableFlashcard(FlashcardContent.testFlashcard)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
}
