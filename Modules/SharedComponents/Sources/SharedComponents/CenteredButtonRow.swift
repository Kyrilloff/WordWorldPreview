//
//  CenteredButtonRow.swift
//  Entities
//
//  Created by Konrad Schmid on 28.11.24.
//

import SwiftUI

public struct CenteredButtonRow: View {
    public var title: String
    public var titleColor: Color
    public var isLoading: Bool
    public var action: () -> Void
    
    public init(_ title: String,
                titleColor: Color = .blue,
                isLoading: Bool = false,
                action: @escaping () -> Void) {
        self.title = title
        self.titleColor = titleColor
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        HStack {
            Spacer()
            Button(title, action: action)
                .disabled(isLoading)
            
            if isLoading {
                ProgressView()
            }
            
            Spacer()
        }
        .foregroundStyle(titleColor)
        .contentShape(Rectangle())
    }
}
