//
//  AddWordScreen.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 08.12.24.
//

import SharedComponents
import SwiftUI

struct AddWordScreen: View {
    
    @State private var vm: AddWordScreenViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(FlashcardState.self) var flashcardState
    
    init(_ flashcard: FlashcardContent? = nil) {
        _vm = .init(initialValue: AddWordScreenViewModel(flashcard: flashcard))
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: Height.standard)
            
            StandardTextField(
                placeholder: "AddWordScreen.OriginalWordTextfield.Placeholder".localized,
                text: $vm.originalMeaning
            )
            
            Spacer().frame(height: Height.small)
            
            StandardTextField(placeholder: "AddWordScreen.TranslationTextfield.Placeholder".localized, text: $vm.translation)
            
            Spacer().frame(height: Height.small)
            
            HStack {
                Text("AddWordScreen.GenderPicker.Title").bold()
                
                Spacer()
                
                Picker("", selection: $vm.gender) {
                    ForEach(Gender.allCases, id: \.self) { value in
                        Text(value.fullDescription)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, Padding.standard)
        .addWordScreenNavbar()
        .environment(vm)
    }
}

#Preview {
    NavigationStack {
        AddWordScreen()
            .environment(FlashcardState())
            .environment(AddWordScreenViewModel())
    }
}
