//
//  SwiftUIView.swift
//  
//
//  Created by Konrad Schmid on 27.06.24.
//

import SwiftUI

public struct StandardButton: View {
    let text: String
    let disabled: Bool
    let action: () -> ()
    @Binding var loading: Bool
    
    public init(text: String, 
                disabled: Bool = false,
                loading: Binding<Bool> = .constant(false),
                action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.disabled = disabled
        _loading = loading
    }
    
    public var body: some View {
        Button(action: action,
               label: {
            
            HStack(alignment: .center, content: {
                Text(text)
                
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .controlSize(.small)
                        .padding(.leading, Padding.small)
                }
            })
            .frame(height: Height.large)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .bold()
            .background(.blue)
            .opacity(disabled ? Opacity.medium : Opacity.none)
        })
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.standard))
        .disabled(disabled || loading)
    }
}

#Preview {
    StandardButton(text: "Button Name", action: {
        print("button was tapped")
    })
}
