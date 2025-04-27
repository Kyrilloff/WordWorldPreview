//
//  AddLanguageScreenNavbar.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import SwiftUI

struct AddLanguageScreenNavbar: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    @Environment(AddLanguageScreenViewModel.self) var vm
    @Environment(FlashcardState.self) var flashcardState
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("AddLanguageScreenNavbar.NavigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("AddLanguageScreenNavbar.Button.Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("AddLanguageScreenNavbar.Button.Save") {
                    Task {
                        try await vm.addLanguage(for: flashcardState)
                        dismiss()
                    }
                }
                .disabled(vm.disableSaveButton)
                .sensoryFeedback(.impact(weight: .heavy, intensity: 3.0), trigger: vm.isSaved)
            }
        }
    }
}

extension View {
    func addLanguageScreenNavbar() -> some View {
        modifier(AddLanguageScreenNavbar())
    }
}
