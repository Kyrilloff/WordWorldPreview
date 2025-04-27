//
//  RepeatableFlashcardsLocalStorageService.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 08.12.24.
//

import CoreData

@MainActor
protocol RepeatableFlashcardsLocalStorageServiceProtocol {
    func saveCard(_ card: FlashcardContent, for userUID: String) async throws
    func loadAllCards(for userUID: String) async throws -> [UUID]
    func deleteCard(_ card: FlashcardContent) async throws
}

struct RepeatableFlashcardsLocalStorageService: RepeatableFlashcardsLocalStorageServiceProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func saveCard(_ card: FlashcardContent, for userUID: String) async throws {
        try await CDRepeatableFlashcard.storeOrUpdateCard(card.id,
                                                          userUid: userUID,
                                                          context: context)
    }
    
    func loadAllCards(for userUID: String) async throws -> [UUID] {
        try await CDRepeatableFlashcard.loadAllCards(for: userUID,
                                                     context: context)
    }
    
    func deleteCard(_ card: FlashcardContent) async throws {
        try await CDRepeatableFlashcard.deleteCard(id: card.id,
                                                   context: context)
    }
}
