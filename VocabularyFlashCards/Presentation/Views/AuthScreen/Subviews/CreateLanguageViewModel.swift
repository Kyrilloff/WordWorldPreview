//
//  CreateLanguageViewModel.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import Observation
import SwiftUI

@Observable
final class CreateLanguageViewModel {
    // language name
    var languageName: String = ""
    
    // first flashcard
    var originalMeaning: String = ""
    var translation: String = ""
    var gender: Gender = .none
    
    var isSaved: Bool = false
    
    var disableSaveButton: Bool {
        languageName.isEmpty
        || languageName.count < 2
        || originalMeaning.isEmpty
        || translation.isEmpty
    }
    
    func addLanguage(for state: FlashcardState) async throws {
        let newWord = Word(id: UUID(),
                           originalMeaning: originalMeaning,
                           translation: translation,
                           gender: gender)
        
        try await state.saveNewLanguage(languageName, firstWord: newWord)
        isSaved = true
    }
}

