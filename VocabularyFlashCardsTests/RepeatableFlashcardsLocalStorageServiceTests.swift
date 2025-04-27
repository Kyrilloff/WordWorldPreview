//
//  RepeatableFlashcardsLocalStorageServiceTests.swift
//  VocabularyFlashCardsTests
//
//  Created by Konrad Schmid on 27.04.25.
//

import Testing
@testable import VocabularyFlashCards

@MainActor
struct RepeatableFlashcardsLocalStorageTests {
    var sut: RepeatableFlashcardsLocalStorageService
    
    init() {
        let persistence = PersistenceController(forTesting: true)
        let context = persistence.container.viewContext
        self.sut = RepeatableFlashcardsLocalStorageService(context: context)
    }
    
    @Test("Save Card Success")
    func saveCardSuccess() async throws {
        let testFlashcard = FlashcardContent.testFlashcard
        let testUser = User.testUser
        
        do {
            let repeatableCardsBeforeSaving = try await sut.loadAllCards(for: testUser.uid)
            #expect(repeatableCardsBeforeSaving.isEmpty)
            
            try await sut.saveCard(testFlashcard,
                                   for: testUser.uid)
            
            let repeatableCardsAfterSaving = try await sut.loadAllCards(for: testUser.uid)
            #expect(repeatableCardsAfterSaving.contains(testFlashcard.id))
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Load All Cards Success")
    func loadAllCardsSuccess() async throws {
        let testFlashcards = FlashcardContent.testFlashcards
        let testUser = User.testUser
        do {
            for card in testFlashcards {
                try await sut.saveCard(card, for: testUser.uid)
            }
            let allCardsLoaded = try await sut.loadAllCards(for: testUser.uid)
            #expect(allCardsLoaded.sorted() == testFlashcards.map(\.id).sorted())
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
}
