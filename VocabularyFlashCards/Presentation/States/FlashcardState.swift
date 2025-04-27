//
//  FlashcardState.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 07.12.24.
//

import Foundation
import Observation

@MainActor
@Observable
final class FlashcardState {
    private let flashcardRepo: FlashcardRepositoryProtocol
    private let languageRepo: LanguageRepositoryProtocol
    
    var flashcards: [FlashcardContent] = []
    var repetition: [FlashcardContent] = []
    private(set) var sortedFilteredFlashcards: [FlashcardContent] = []
    
    var availableLanguages: [String] = []
    var currentLanguage: Language?
    var searchText: String = "" {
        didSet {
            updateFilteredFlashcards()
        }
    }

    init(flashcardRepository: FlashcardRepositoryProtocol = FlashcardRepository(),
         languageRepository: LanguageRepositoryProtocol = LanguageRepository()) {
        self.flashcardRepo = flashcardRepository
        self.languageRepo = languageRepository
        
        Task { [weak self] in
            guard let self else { return }
            try await loadAvailableLanguages()
            let currentLanguage = try await getCurrentLanguage()
            flashcards = try await flashcardRepo.loadFlashcards(for: currentLanguage) ?? []
            updateFilteredFlashcards()
            repetition = try await loadRepeatableFromIDs()
        }
    }

    func resetFlashcards() async throws {
        flashcards = []
        repetition = []
        try await languageRepo.deleteAllLocalLanguages()
        updateFilteredFlashcards()
    }
    
    func reloadCards() async throws {
        let currentLanguage = try await getCurrentLanguage()
        flashcards = try await flashcardRepo.loadFlashcards(for: currentLanguage) ?? []
        updateFilteredFlashcards()
        repetition = try await loadRepeatableFromIDs()
    }

    func saveNewWord(_ word: Word) async throws {
        guard !flashcards.contains(where: { $0.word.originalMeaning == word.originalMeaning }) else {
            throw FlashcardStateError.wordAlreadyExists
        }
        let newFlashcard = FlashcardContent(id: UUID(), word: word)
        let currentLanguage = try await getCurrentLanguage()
        try await flashcardRepo.save(newFlashcard, for: currentLanguage)
        flashcards = try await flashcardRepo.loadFlashcards(for: currentLanguage) ?? []
        updateFilteredFlashcards()
    }

    func updateFlashcard(_ flashcard: FlashcardContent) async throws {
        let currentLanguage = try await getCurrentLanguage()
        let updatedCard = try await flashcardRepo.update(flashcard, for: currentLanguage)
        flashcards = flashcards.map { $0.id == updatedCard.id ? updatedCard : $0 }
        repetition = repetition.map { $0.id == updatedCard.id ? updatedCard : $0 }
        updateFilteredFlashcards()
    }

    func addRepeatableFlashcard(_ flashcard: FlashcardContent) async throws {
        guard !repetition.contains(flashcard) else { return }
        try await flashcardRepo.saveRepeatableFlashcard(flashcard)
        repetition = try await loadRepeatableFromIDs()
    }

    func deleteRepeatableFlashcard(_ flashcard: FlashcardContent) async throws {
        try await flashcardRepo.deleteRepeatableFlashcard(flashcard)
        repetition = try await loadRepeatableFromIDs()
    }

    func pickRandomCards(number: Int = 20) -> [FlashcardContent] {
        flashcards.count <= number ? flashcards : Array(flashcards.shuffled().prefix(number))
    }

    func pickRandomRepeatableCards(number: Int = 20) -> [FlashcardContent] {
        repetition.count <= number ? repetition : Array(repetition.shuffled().prefix(number))
    }

    // MARK: - Language Management
    func loadAvailableLanguages() async throws {
        let available = try await languageRepo.loadAvailableLanguages()
        availableLanguages = available.map { $0.name }
        self.currentLanguage = available.first(where: { $0.isCurrent })
    }

    func saveNewLanguage(_ language: String, firstWord: Word) async throws {
        try await languageRepo.addLanguage(language, firstWord: firstWord)
        availableLanguages = try await languageRepo.loadAvailableLanguages().map { $0.name }
    }

    func saveCurrentLanguage(_ language: String) async throws {
        currentLanguage = nil
        try await languageRepo.saveCurrentLanguage(language: language)
        _ = try await getCurrentLanguage()
        try await reloadCards()
    }

    // MARK: - Helpers
    private func loadRepeatableFromIDs() async throws -> [FlashcardContent] {
        let ids = try await flashcardRepo.loadRepeatableFlashcards()
        return flashcards.filter { ids.contains($0.id) }
    }

    private func updateFilteredFlashcards() {
        if searchText.isEmpty {
            sortedFilteredFlashcards = flashcards.sorted {
                $0.word.originalMeaning.localizedCaseInsensitiveCompare($1.word.originalMeaning) == .orderedAscending
            }
        } else {
            let byOriginal = flashcards.filter {
                $0.word.originalMeaning.lowercased().hasPrefix(searchText.lowercased())
            }
            
            let byTranslation = flashcards.filter {
                $0.word.translation.lowercased().hasPrefix(searchText.lowercased())
            }
            
            let combined = (byOriginal + byTranslation).unique
            sortedFilteredFlashcards = combined.sorted {
                $0.word.originalMeaning < $1.word.originalMeaning
            }
        }
    }
    
    private func getCurrentLanguage() async throws -> Language {
        if let currentLanguage {
            return currentLanguage
        } else {
            guard let currentLanguage = try await languageRepo.loadCurrentLanguage() else {
                throw FlashcardStateError.noCurrentLanguageSelected
            }
            self.currentLanguage = currentLanguage
            return currentLanguage
        }
    }
}
