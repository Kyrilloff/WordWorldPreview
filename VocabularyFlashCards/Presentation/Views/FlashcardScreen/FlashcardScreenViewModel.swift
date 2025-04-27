//
//  FlashcardScreenViewModel.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 23.04.25.
//

import Foundation
import Observation

@Observable
final class FlashcardScreenViewModel {
    
    var showAddWord = false
    var showSettings = false
    var currentSection: VocabularySection = .all
    var invertAll = false
    var invertAllInverted = true
    
    var randomFlashcards: [FlashcardContent] = []
    var randomRepeatableFlashcards: [FlashcardContent] = []
    
    // Navbar buttons
    var regenerateButtonIsDisabled: Bool {
        currentSection == .all
        || currentSection == .repetition
    }
    
    var invertButtonIsDisabled: Bool {
        currentSection == .all
    }
    
    var addButtonIsDisabled: Bool {
        currentSection != .all
    }
    
    // Helper functions
    @MainActor
    func regenerateCards(state: FlashcardState) {
        switch currentSection {
        case .randomTwentyRepeat:
            randomRepeatableFlashcards = state.pickRandomRepeatableCards()
        default:
            randomFlashcards = state.pickRandomCards()
        }
    }
    
    func resetRandomCards() {
        randomFlashcards.removeAll()
        randomRepeatableFlashcards.removeAll()
    }
    
    // card generation
    @MainActor
    func generateInitialCards(state: FlashcardState) {
        if randomRepeatableFlashcards.isEmpty {
            randomRepeatableFlashcards = state.pickRandomRepeatableCards()
        }
        
        if randomFlashcards.isEmpty {
            randomFlashcards = state.pickRandomCards()
        }
    }
    
    @MainActor
    // returns flashcard data based on section
    func flashcards(for state: FlashcardState) -> [FlashcardContent] {
        switch currentSection {
        case .all:
            state.sortedFilteredFlashcards
        case .randomTwenty:
            randomFlashcards
        case .repetition:
            state.repetition
        case .randomTwentyRepeat:
            randomRepeatableFlashcards
        }
    }
}

enum VocabularySection: CaseIterable {
    case all // shows all available words
    case randomTwenty // shows 20 randomly picked words
    case repetition // shows all words marked for repetition
    case randomTwentyRepeat // shows 20 randomly picked words from the repetition list
    
    var description: String {
        switch self {
        case .all:
            String("VocabularySections.Description.All".localized)
        case .randomTwenty:
            String("VocabularySections.Description.RandomTwenty".localized)
        case .repetition:
            String("VocabularySections.Description.RepeatAll".localized)
        case .randomTwentyRepeat:
            String("VocabularySections.Description.RepeatTwenty".localized)
        }
    }
}
