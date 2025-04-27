//
//  InfoBubble.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 26.04.25.
//

import SharedComponents
import SwiftUI

struct InfoBubble: View {
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
                .padding()
                .fontWeight(.medium)
        }
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.standard))
    }
}

#Preview {
    InfoBubble(text: "This is an info text")
}
