//
//  AddWordScreenViewModel.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 23.04.25.
//

import Observation
import SwiftUI

@Observable
final class AddWordScreenViewModel {
    var originalMeaning: String
    var translation: String
    var gender: Gender
    var editableFlashcard: FlashcardContent?
    
    var isSaved: Bool = false
    
    var disableSaveButton: Bool {
        originalMeaning.isEmpty
        || translation.isEmpty
    }
    
    init(flashcard: FlashcardContent? = nil) {
        _editableFlashcard = flashcard
        _originalMeaning = flashcard?.word.originalMeaning ?? ""
        _translation = flashcard?.word.translation ?? ""
        _gender = flashcard?.word.gender ?? .none
    }
}

@MainActor
extension AddWordScreenViewModel {
    
    func editFlashcard(for state: FlashcardState) async throws {
        guard let editableFlashcard else { return }
        do {
            let newWord = Word(id: editableFlashcard.word.id,
                               originalMeaning: originalMeaning,
                               translation: translation,
                               gender: gender)
            
            let newFlashcard = FlashcardContent(id: editableFlashcard.id,
                                                word: newWord)
            
            try await state.updateFlashcard(newFlashcard)
            isSaved = true
        } catch {
            log.error("Editing flashcard failed with error \(error)")
        }
    }
    
    func addWord(for state: FlashcardState) async throws {
        let newWord = Word(id: UUID(),
                           originalMeaning: originalMeaning,
                           translation: translation,
                           gender: gender)
        try await state.saveNewWord(newWord)
        
        originalMeaning = ""
        translation = ""
        gender = .none
        isSaved = true
        
    }
}
