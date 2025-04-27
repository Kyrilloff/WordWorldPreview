//
//  DummyFlashcardScreen.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 25.04.25.
//

import SwiftUI

// this is a placeholder for the logout
struct DummyFlashcardScreen: View {
    @State private var vm = FlashcardScreenViewModel()
    
    var body: some View {
        VStack {
            Picker("", selection: $vm.currentSection) {
                ForEach(VocabularySection.allCases, id: \ .self) { section in
                    Text(section.description)
                }
            }
            .pickerStyle(.segmented)
            
            Spacer()
            
            ProgressView {
                Text("DummiFlashcardScreen.ProgressView.Title")
                    .padding()
            }

            Spacer()
        }
        .flashcardScreenNavbar()
        .environment(vm)
    }
}
