//
//  AuthScreenViewModel.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import Observation
import SwiftUI

@Observable
final class AuthScreenViewModel {
    var email: String = ""
    var password: String = ""
    var isRegistration = false
    var languageWasAdded = false
    var buttonIsLoading = false
    var showAddLanguage = false
    
    // language name
    var languageName: String = ""
    
    // first flashcard
    var originalMeaning: String = ""
    var translation: String = ""
    var gender: Gender = .none
    
    var registrationButtonTitle: String {
        if isRegistration {
            return showAddLanguage ? "Complete Registration" : "Register"
        } else {
            return "Login"
        }
    }
    
    var registerButtonIsDisabled: Bool {
        if showAddLanguage {
            languageName.isEmpty
            || languageName.count < 2
            || originalMeaning.isEmpty
            || translation.isEmpty
        } else {
            email.isEmpty || password.count < 6
        }
    }
    
    var addLanguageButtonIsDisabled: Bool {
        languageName.isEmpty
        || languageName.count < 2
        || originalMeaning.isEmpty
        || translation.isEmpty
    }
    
    @MainActor
    func login(userState: UserState,
               flashcardState: FlashcardState) async throws {
        try await userState.login(email: email,
                                  password: password)
        try await flashcardState.loadAvailableLanguages()
        try await flashcardState.reloadCards()
    }
    
    @MainActor
    func register(userState: UserState,
                  flashcardState: FlashcardState) async throws {
        try await userState.signUp(email: email,
                                   password: password)
        
        let firstWord = Word(id: UUID(),
                             originalMeaning: originalMeaning,
                             translation: translation,
                             gender: gender)
        try await flashcardState.saveNewLanguage(languageName,
                                                 firstWord: firstWord)
        try await flashcardState.reloadCards()
    }
}
