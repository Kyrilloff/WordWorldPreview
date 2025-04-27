//
//  AddWordScreenNavbar.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import SwiftUI

struct AddWordScreenNavbar: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    @Environment(AddWordScreenViewModel.self) var vm
    @Environment(FlashcardState.self) var flashcardState
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("AddWordScreen.NavigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("AddWordScreen.ToolbarButton.Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("AddWordScreen.ToolbarButton.Save") {
                    Task {
                        if vm.editableFlashcard != nil {
                            do {
                                try await vm.editFlashcard(for: flashcardState)
                                dismiss()
                            } catch {
                                log.error("Editing word failed with error \(error)")
                            }
                        } else {
                            do {
                                try await vm.addWord(for: flashcardState)
                                dismiss()
                            } catch {
                                log.error("Saving new word failed with error \(error)")
                            }
                        }
                    }
                }
                .disabled(vm.disableSaveButton)
                .sensoryFeedback(.impact(weight: .heavy, intensity: 3.0), trigger: vm.isSaved)
            }
        }
    }
}

extension View {
    func addWordScreenNavbar() -> some View {
        modifier(AddWordScreenNavbar())
    }
}
