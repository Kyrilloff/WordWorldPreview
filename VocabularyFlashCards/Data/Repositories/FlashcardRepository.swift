//
//  FlashcardRepository.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 07.12.24.
//

import FirebaseAuth
import Foundation

@MainActor
protocol FlashcardRepositoryProtocol {
    // flashcards
    func save(_ flashcard: FlashcardContent, for language: Language) async throws
    func update(_ flashcard: FlashcardContent, for language: Language) async throws -> FlashcardContent
    func loadFlashcards(for language: Language) async throws -> [FlashcardContent]?
    func loadSpecificFlashcard(with uuid: UUID, for language: Language) async throws -> FlashcardContent?
    func loadSpecificFlashcardWithWord(containing originalMeaning: String, for language: Language) async throws -> [FlashcardContent]?
    
    // repeatable flashcards
    func saveRepeatableFlashcard(_ flashcard: FlashcardContent) async throws
    func loadRepeatableFlashcards() async throws -> [UUID]
    func deleteRepeatableFlashcard(_ flashcard: FlashcardContent) async throws
}

struct FlashcardRepository: FlashcardRepositoryProtocol {
    
    let networkService: FlashcardNetworkServiceProtocol
    let localStorageService: RepeatableFlashcardsLocalStorageServiceProtocol
    let user: User?
    
    init(networkService: FlashcardNetworkServiceProtocol = FlashcardNetworkService(),
         localStorageService: RepeatableFlashcardsLocalStorageServiceProtocol = RepeatableFlashcardsLocalStorageService(),
         user: User? = nil) {
        self.networkService = networkService
        self.localStorageService = localStorageService
        self.user = user
    }
    
    // MARK: Flashcards
    func save(_ flashcard: FlashcardContent, for language: Language) async throws {
        try await networkService.save(flashcard, for: language)
    }
    
    func update(_ flashcard: FlashcardContent, for language: Language) async throws -> FlashcardContent {
        try await networkService.update(flashcard, for: language)
    }
    
    func loadFlashcards(for language: Language) async throws -> [FlashcardContent]? {
        try await networkService.load(language: language)
    }
    
    func loadSpecificFlashcard(with uuid: UUID, for language: Language) async throws -> FlashcardContent? {
        try await networkService.loadSpecificFlashcard(with: uuid,
                                                       for: language)
    }
    
    func loadSpecificFlashcardWithWord(containing originalMeaning: String, for language: Language) async throws -> [FlashcardContent]? {
        try await networkService.loadSpecificFlashcardWithWord(containing: originalMeaning,
                                                               for: language)
    }
    
    // MARK: Repeatable Flashcards
    func saveRepeatableFlashcard(_ flashcard: FlashcardContent) async throws {
        if let user {
            try await localStorageService.saveCard(flashcard,
                                                   for: user.uid)
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw NetworkError.unauthorized
            }
            
            try await localStorageService.saveCard(flashcard,
                                                   for: uid)
        }
    }
    
    func loadRepeatableFlashcards() async throws -> [UUID] {
        if let user {
            return try await localStorageService.loadAllCards(for: user.uid)
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw NetworkError.unauthorized
            }
            return try await localStorageService.loadAllCards(for: uid)
        }
    }
    
    func deleteRepeatableFlashcard(_ flashcard: FlashcardContent) async throws {
        try await localStorageService.deleteCard(flashcard)
    }
}
