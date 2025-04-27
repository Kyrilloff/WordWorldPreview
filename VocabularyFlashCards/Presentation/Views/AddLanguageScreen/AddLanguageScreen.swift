//
//  AddLanguageScreen.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import SharedComponents
import SwiftUI

struct AddLanguageScreen: View {
    
    @State private var vm = AddLanguageScreenViewModel()
    
    @Environment(\.dismiss) var dismiss
    @Environment(FlashcardState.self) var flashcardState
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: Height.standard)
            
            Text("AddLanguageScreen.LanguageTextfield.Title").bold()
            
            StandardTextField(
                placeholder: "AddLanguageScreen.LanguageTextfield.Placeholder".localized,
                text: $vm.languageName
            )
            
            Spacer().frame(height: Height.standard)
            
            Text("").bold()
            
            StandardTextField(
                placeholder: "AddLanguageScreen.OriginTextfield.Placeholder".localized,
                text: $vm.originalMeaning
            )
            
            Spacer().frame(height: Height.small)
            
            StandardTextField(placeholder: "AddWordScreen.TranslationTextfield.Placeholder".localized, text: $vm.translation)
            
            Spacer().frame(height: Height.small)
            
            HStack {
                Text("AddLanguageScreen.GenderPicker.Title").bold()
                
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
        .addLanguageScreenNavbar()
        .environment(vm)
    }
}

#Preview {
    NavigationStack {
        AddLanguageScreen()
            .environment(FlashcardState())
            .environment(AddLanguageScreenViewModel())
    }
}
