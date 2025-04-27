//
//  FlashcardScreenNavbar.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import SwiftUI

struct FlashcardScreenNavbar: ViewModifier {
    @Environment(FlashcardScreenViewModel.self) var vm
    @Environment(FlashcardState.self) var flashcardState
    
    private var toolbarIsDisabled: Bool {
        flashcardState.flashcards.isEmpty
    }

    func body(content: Content) -> some View {
        content
            .navigationTitle("FlashcardScreen.NavigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        vm.regenerateCards(state: flashcardState)
                    } label: {
                        Image(systemName: "arrow.trianglehead.counterclockwise")
                    }
                    .disabled(vm.regenerateButtonIsDisabled)

                    Button {
                        vm.invertAll.toggle()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                    }
                    .disabled(vm.invertButtonIsDisabled)
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        vm.showSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                    
                    Button {
                        vm.showAddWord = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(vm.addButtonIsDisabled)
                }
            }
            .disabled(toolbarIsDisabled)
    }
}

extension View {
    func flashcardScreenNavbar() -> some View {
        modifier(FlashcardScreenNavbar())
    }
}
