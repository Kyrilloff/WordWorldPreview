//
//  FlashcardContent.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 07.12.24.
//

import Foundation

struct FlashcardContent: Codable, Comparable, Equatable, Identifiable {
    let id: UUID
    let word: Word
    
    init(id: UUID,
         word: Word) {
        self.id = id
        self.word = word
    }
    
    static func == (lhs: FlashcardContent, rhs: FlashcardContent) -> Bool {
        return lhs.id == rhs.id
        && lhs.word == rhs.word
    }
    
    static func < (lhs: FlashcardContent, rhs: FlashcardContent) -> Bool {
        return lhs.id < rhs.id
        && lhs.word < rhs.word
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "flashcardId"
        case word = "flashcardWord"
    }
}

extension FlashcardContent {
    static let testFlashcard = FlashcardContent(
        id: UUID(),
        word: Word(id: UUID(),
                   originalMeaning: "cellulare",
                   translation: "cellphone",
                   gender: .male)
    )
    
    static let testFlashcards = [
        FlashcardContent(
            id: UUID(),
            word: Word(id: UUID(),
                       originalMeaning: "cellulare",
                       translation: "cellphone",
                       gender: .male)),
        FlashcardContent(
            id: UUID(),
            word: Word(id: UUID(),
                       originalMeaning: "donna",
                       translation: "woman",
                       gender: .female)),
        FlashcardContent(
            id: UUID(),
            word: Word(id: UUID(),
                       originalMeaning: "uomo",
                       translation: "man",
                       gender: .male))
        ]
}
