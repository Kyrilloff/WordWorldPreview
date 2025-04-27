//
//  SwiftUIView.swift
//  
//
//  Created by Konrad Schmid on 22.06.24.
//

import SwiftUI

public struct StandardTextField: View {
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    private let height: CGFloat = Height.textFieldStandard
    private let horizontalPadding: CGFloat = Padding.small
    private let cornerRadius: CGFloat = CornerRadius.standard
    private let strokeColor: Color = .gray
    
    public init(placeholder: String, 
                text: Binding<String>,
                isSecure: Bool = false) {
        self.placeholder = placeholder
        _text = text
        self.isSecure = isSecure
    }
    
    public var body: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .frame(height: height)
                .padding(.horizontal, horizontalPadding)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(strokeColor))
        } else {
            TextField(placeholder, text: $text)
                .frame(height: height)
                .padding(.horizontal, horizontalPadding)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(strokeColor))
        }
    }
}

#Preview {
    StandardTextField(placeholder: "placeholder",
                      text: .constant(""))
}
