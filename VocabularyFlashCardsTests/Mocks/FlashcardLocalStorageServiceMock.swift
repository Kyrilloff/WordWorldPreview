//
//  FlashcardLocalStorageServiceMock.swift
//  VocabularyFlashCardsTests
//
//  Created by Konrad Schmid on 26.04.25.
//

import Foundation
@testable import VocabularyFlashCards

class FlashcardLocalStorageServiceMock: RepeatableFlashcardsLocalStorageServiceProtocol {
    
    var saveRepeatableCardSucceeds = false
    let saveRepeatableCardErrorResult = StorageError.storingFailed
    
    var loadAllRepeatableCardsSucceeds = false
    let loadAllRepeatableCardsSuccessResult = FlashcardContent.testFlashcards.map(\.id)
    let loadAllRepeatableCardsErrorResult = StorageError.dataNotFound
    
    var deleteRepeatableCardSucceeds = false
    let deleteRepeatableCardErrorResult = StorageError.dataNotFound
    
    func saveCard(_ card: FlashcardContent, for userUID: String) async throws {
        if !saveRepeatableCardSucceeds {
            throw saveRepeatableCardErrorResult
        }
    }
    
    func loadAllCards(for userUID: String) async throws -> [UUID] {
        if loadAllRepeatableCardsSucceeds {
            return loadAllRepeatableCardsSuccessResult
        } else {
            throw loadAllRepeatableCardsErrorResult
        }
    }
    
    func deleteCard(_ card: FlashcardContent) async throws {
        if !deleteRepeatableCardSucceeds {
            throw deleteRepeatableCardErrorResult
        }
    }
}
