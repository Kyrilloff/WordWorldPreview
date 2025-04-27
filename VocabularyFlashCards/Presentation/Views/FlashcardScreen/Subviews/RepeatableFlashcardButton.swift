//
//  RepeatableFlashcardButton.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 23.04.25.
//

import SwiftUI

struct RepeatableFlashcardButton: View {
    
    @Environment(FlashcardState.self) var flashcardState
    
    let flashcard: FlashcardContent
    let removeFlashcard: Bool
    var onComplete: (() -> Void)? = nil
    
    init(_ flashcard: FlashcardContent,
         removeFlashcard: Bool = false,
         onComplete: (() -> Void)? = nil) {
        self.flashcard = flashcard
        self.removeFlashcard = removeFlashcard
        self.onComplete = onComplete
    }
    
    var body: some View {
        Button(
            removeFlashcard ?
            "FlashcardScreen.SwipeButton.Remove.Title" : "FlashcardScreen.SwipeButton.Add.Title"
        ) {
            Task {
                removeFlashcard ?
                try await flashcardState.deleteRepeatableFlashcard(flashcard) :
                try await flashcardState.addRepeatableFlashcard(flashcard)
                onComplete?()
            }
        }
        .bold()
        .tint(removeFlashcard ? .green : .orange)
    }
}

#Preview {
    RepeatableFlashcardButton(
        FlashcardContent(id: UUID(),
                         word: Word(id: UUID(),
                                    originalMeaning: "Foo", translation: "Foo Translation",
                                    gender: .male))
    )
    .environment(FlashcardState())
}
