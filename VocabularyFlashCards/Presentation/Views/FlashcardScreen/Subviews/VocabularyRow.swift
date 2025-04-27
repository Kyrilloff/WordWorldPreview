//
//  VocabularyRow.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 08.12.24.
//

import SwiftUI

enum VocabluaryRowType {
    case translatable // translations can be hidden or shown
    case editable // word can be edited
}

struct VocabularyRow: View {
    var flashcard: FlashcardContent
    @State var showTranslation: Bool = false
    @State private var showEditWordSheet: Bool = false
    @Binding var inverse: Bool
    var rowType: VocabluaryRowType = .translatable
    
    var translationAsAsterisks: String {
        return "*****"
    }
    
    var translationWithGender: String {
        if flashcard.word.gender == .none
            || inverse {
            return flashcard.word.translation
        } else {
            return "\(flashcard.word.translation) (\(flashcard.word.gender.description))"
        }
    }
    
    var originalWithGender: String {
        if flashcard.word.gender == .none
            || !inverse {
            return flashcard.word.originalMeaning
        } else {
            return "\(flashcard.word.originalMeaning) (\(flashcard.word.gender.description))"
        }
    }
    
    init(flashcard: FlashcardContent,
         inverse: Binding<Bool>,
         rowType: VocabluaryRowType = .translatable) {
        self.flashcard = flashcard
        self._inverse = inverse
        self.rowType = rowType
        
        if rowType == .editable {
            _showTranslation = State(initialValue: true)
        } else {
            _showTranslation = State(initialValue: false)
        }
    }
    
    var body: some View {
        HStack {
            Text(inverse ? translationWithGender : originalWithGender)
            
            Spacer()
            
            if rowType == .editable || showTranslation {
                Text(inverse ? originalWithGender : translationWithGender)
            } else {
                Text(translationAsAsterisks)
            }
        }
        .contentShape(Rectangle())
        .onAppear {
            if rowType == .translatable {
                showTranslation = false
            }
        }
        .onTapGesture {
            switch rowType {
            case .translatable:
                showTranslation.toggle()
            case .editable:
                showEditWordSheet = true
            }
        }
        .sheet(isPresented: $showEditWordSheet) {
            NavigationStack {
                AddWordScreen(flashcard)
            }
        }
    }
}
