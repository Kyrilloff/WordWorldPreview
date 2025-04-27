//
//  ContentView.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 07.12.24.
//

import SharedComponents
import SwiftUI

struct FlashcardScreen: View {
    @Environment(FlashcardState.self) var flashcardState
    @State private var vm = FlashcardScreenViewModel()
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            sectionPicker
            
            if flashcardState.flashcards.isEmpty {
                loadingView
            } else {
                if vm.flashcards(for: flashcardState).isEmpty
                    && vm.currentSection != .all  {
                    // Info Bubble for empty lists
                    infoBubble
                } else {
                    // Vocabulary List
                    if vm.currentSection == .all {
                        searchBar
                            .padding(.horizontal, Padding.medium)
                            .padding(.top, Padding.small)
                    }
                    
                    List {
                        vocabularyRows
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                }
            }
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .flashcardScreenNavbar()
        .environment(vm)
        .sheet(isPresented: $vm.showAddWord) {
            NavigationStack {
                AddWordScreen()
            }
        }
        .fullScreenCover(isPresented: $vm.showSettings) {
            NavigationStack {
                SettingsScreen()
                    .onDisappear {
                        if vm.randomRepeatableFlashcards.isEmpty
                            || vm.randomFlashcards.isEmpty {
                            vm.generateInitialCards(state: flashcardState)
                        }
                    }
            }
        }
        .onChange(of: flashcardState.currentLanguage) { _, newValue in
            vm.resetRandomCards()
        }
        .onChange(of: flashcardState.repetition) { _, _ in
            vm.generateInitialCards(state: flashcardState)
        }
        .onChange(of: vm.currentSection) { _, _ in
            vm.generateInitialCards(state: flashcardState)
        }
    }
}

extension FlashcardScreen {
    var sectionPicker: some View {
        Picker("", selection: $vm.currentSection) {
            ForEach(VocabularySection.allCases, id: \ .self) { section in
                Text(section.description)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var loadingView: some View {
        VStack {
            Spacer()
            
            ProgressView {
                Text("FlashcardScreen.ProgressView.Message")
                    .padding()
            }
            
            Spacer()
        }
    }
    
    var infoBubble: some View {
        VStack {
            Spacer().frame(height: Height.standard)
            
            InfoBubble(text: "FlashcardScreen.InfoBubble.Text".localized)
            
            Spacer()
        }
    }
    
    var searchBar: some View {
        VStack {
            TextField(String(
                format: "FlashcardScreen.SearchField.Placeholder".localized, "\(flashcardState.sortedFilteredFlashcards.count)"
            ), text: $searchText)
            .onChange(of: searchText) { _, newValue in
                flashcardState.searchText = newValue
            }
        }
    }
    
    var vocabularyRows: some View {
        ForEach(vm.flashcards(for: flashcardState),
                id: \ .id) { flashcard in
            
            VocabularyRow(
                flashcard: flashcard,
                inverse: $vm.invertAll,
                rowType: vm.currentSection == .all ? .editable : .translatable
            )
            .id("\(flashcard.id)-\(vm.currentSection)")
            .swipeActions(edge: .trailing,
                          allowsFullSwipe: true) {
                
                if vm.currentSection == .all
                    || vm.currentSection == .randomTwenty  {
                    RepeatableFlashcardButton(flashcard)
                } else {
                    RepeatableFlashcardButton(flashcard, removeFlashcard: true) {
                        vm.randomRepeatableFlashcards.removeAll { $0.id == flashcard.id }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FlashcardScreen()
            .environment(FlashcardState())
    }
}
