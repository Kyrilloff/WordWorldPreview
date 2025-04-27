//
//  CreateLanguageView.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import SharedComponents
import SwiftUI

struct CreateLanguageView: View {
    
    @Binding var languageName: String
    @Binding var wordOriginal: String
    @Binding var wordTranslation: String
    @Binding var wordGender: Gender
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("CreateLanguageView.LanguageTextField.Title").bold()
            
            StandardTextField(
                placeholder: "italian",
                text: $languageName
            )
            
            Spacer().frame(height: Height.standard)
            
            Text("CreateLanguageView.WordTextFields.Title").bold()
            
            StandardTextField(
                placeholder: "CreateLanguageView.OriginalWordTextfield.Placeholder".localized,
                text: $wordOriginal
            )
            
            Spacer().frame(height: Height.small)
            
            StandardTextField(placeholder: "CreateLanguageView.TranslationTextfield.Placeholder".localized, text: $wordTranslation)
            
            Spacer().frame(height: Height.small)
            
            HStack {
                Text("CreateLanguageView.GenderPicker.Title").bold()
                
                Spacer()
                
                Picker("", selection: $wordGender) {
                    ForEach(Gender.allCases, id: \.self) { value in
                        Text(value.fullDescription)
                    }
                }
            }
            
            Spacer()
        }
    }
}
