//
//  VocabularyFlashCardsApp.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 07.12.24.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

let log = Logger()

@main
struct VocabularyFlashCardsApp: App {
    @State private var flashcardsState: FlashcardState
    @State private var userState: UserState

    init() {
        FirebaseApp.configure()
        _flashcardsState = State(initialValue: FlashcardState())
        _userState = State(initialValue: UserState())
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BaseScreen()
                    .environment(flashcardsState)
                    .environment(userState)
            }
        }
    }
}
