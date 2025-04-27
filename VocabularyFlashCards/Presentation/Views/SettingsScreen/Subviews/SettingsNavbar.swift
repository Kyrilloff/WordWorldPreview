//
//  SettingsNavbar.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import SwiftUI

struct SettingsNavbar: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("SettingsScreen.Navbar.Title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("SettingsScreen.Navbar.Button.Close") {
                        dismiss()
                    }
                }
            }
    }
}

extension View {
    func settingsNavbar() -> some View {
        modifier(SettingsNavbar())
    }
}
