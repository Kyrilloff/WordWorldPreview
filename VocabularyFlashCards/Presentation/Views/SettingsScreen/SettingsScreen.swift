//
//  SettingsScreen.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import FirebaseAuth
import SharedComponents
import SwiftUI

struct SettingsScreen: View {
    
    @Environment(UserState.self) var userState
    @Environment(FlashcardState.self) var flashcardState
    
    @State private var handle: AuthStateDidChangeListenerHandle?
    @State private var selectedLanguage: String = ""
    @State private var showNoLanguagesAvailableView = false
    @State private var showAddLanguageScreen = false
    
    
    var body: some View {
        VStack {
            List {
                Section {
                    if case let .authenticated(user) = userState.status {
                        ForEach(UserDataRowType.allCases, id: \.self) { rowType in
                            switch rowType {
                            case .email:
                                if let email = user.email {
                                    HStack {
                                        Spacer()
                                        Text("\(rowType.description): \(email)")
                                            .foregroundStyle(.gray)
                                        Spacer()
                                    }
                                }
                            case .password:
                                CenteredButtonRow(rowType.description) {
                                    // TODO: implement password change
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                
                Section {
                    Picker("SettingsScreen.LanguagePicker.Title",
                           selection: $selectedLanguage) {
                        if flashcardState.availableLanguages.isEmpty {
                            ProgressView()
                        } else {
                            ForEach(flashcardState.availableLanguages, id: \.self) { lang in
                                Text(lang.capitalized)
                                    .bold()
                                    .tag(lang)
                            }
                        }
                    }.pickerStyle(.menu)
                    
                    ForEach(LanguageRowType.allCases, id: \.self) { rowType in
                        switch rowType {
                        case .add:
                            CenteredButtonRow(rowType.description) {
                                showAddLanguageScreen = true
                            }
                        case .delete:
                            CenteredButtonRow("Delete Language",
                                              titleColor: .red) {
                                // TODO: implement
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                
                Section {
                    if case .authenticated = userState.status {
                        ForEach(AuthRowType.allCases, id: \.self) { rowType in
                            switch rowType {
                            case .logout:
                                CenteredButtonRow(rowType.description) {
                                    Task {
                                        do {
                                            try await userState.logout()
                                            try await flashcardState.resetFlashcards()
                                        } catch {
                                            print("Logout failed: \(error)")
                                        }
                                    }
                                }
                            case .deleteAccount:
                                CenteredButtonRow(rowType.description, titleColor: .red) {
                                    // TODO: implement account deletion
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .settingsNavbar()
            .sheet(isPresented: $showAddLanguageScreen) {
                NavigationStack {
                    AddLanguageScreen()
                }
            }
            .task {
                try? await flashcardState.loadAvailableLanguages()
                
                if let currentLanguage = flashcardState.currentLanguage {
                    self.selectedLanguage = currentLanguage.name
                    // TODO: implement
                } else {
                    showNoLanguagesAvailableView = true
                }
            }
            .onChange(of: selectedLanguage) { oldValue, newValue in
                if !oldValue.isEmpty {
                    Task {
                        try await flashcardState.saveCurrentLanguage(newValue)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
            .environment(UserState())
    }
}
