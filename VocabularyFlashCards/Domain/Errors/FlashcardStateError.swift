//
//  FlashcardStateError.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 23.04.25.
//

enum FlashcardStateError: Error {
    case flashcardsNotLoaded
    case wordAlreadyExists
    case noCurrentLanguageSelected
}
