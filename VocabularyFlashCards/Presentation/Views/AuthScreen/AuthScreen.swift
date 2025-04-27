//
//  AuthScreen.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import FirebaseAuth
import SharedComponents
import SwiftUI

struct AuthScreen: View {
    @State private var vm = AuthScreenViewModel()

    @Environment(UserState.self) var userState
    @Environment(FlashcardState.self) var flashcardState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: Height.large)

            if !vm.showAddLanguage {
                Text("AuthScreen.Label.Email").bold()
                StandardTextField(placeholder: "AuthScreen.EmailTextfield.Placeholder".localized, text: $vm.email)

                Spacer().frame(height: Height.standard)

                Text("AuthScreen.Label.Password").bold()
                StandardTextField(placeholder: "AuthScreen.PasswordTextfield.Placeholder".localized, text: $vm.password, isSecure: true)

                Spacer().frame(height: Height.standard)

                Button(
                    vm.isRegistration ? "AuthScreen.ButtonTitle.Login" : "AuthScreen.ButtonTitle.Registration"
                ) {
                    vm.email = ""
                    vm.password = ""
                    vm.isRegistration.toggle()
                }
            } else {
                CreateLanguageView(
                    languageName: $vm.languageName,
                    wordOriginal: $vm.originalMeaning,
                    wordTranslation: $vm.translation,
                    wordGender: $vm.gender
                )
            }

            Spacer()

            StandardButton(
                text: vm.registrationButtonTitle,
                disabled: vm.registerButtonIsDisabled,
                loading: $vm.buttonIsLoading
            ) {
                Task {
                    await handleAuthAction()
                }
            }

            Spacer().frame(height: Height.standard)
        }
        .padding(.horizontal, Padding.standard)
        .navigationTitle(vm.isRegistration ? "Register" : "Login")
        .onChange(of: userState.status) { _, newStatus in
            if case .authenticated = newStatus {
                dismiss()
            }
        }
    }

    private func handleAuthAction() async {
        vm.buttonIsLoading = true
        do {
            if vm.isRegistration {
                if !vm.addLanguageButtonIsDisabled {
                    try await vm.register(userState: userState, flashcardState: flashcardState)
                } else {
                    vm.showAddLanguage = true
                }
            } else {
                try await vm.login(userState: userState, flashcardState: flashcardState)
            }
            log.info("\(vm.isRegistration ? "Registration" : "Login") succeeded")
        } catch {
            let type = vm.isRegistration ? "Registration" : "Login"
            log.error("\(type) failed: \(error)")
        }
        vm.buttonIsLoading = false
    }
}

#Preview {
    NavigationStack {
        AuthScreen()
            .environment(UserState())
            .environment(FlashcardState())
            .environment(AuthScreenViewModel())
    }
}
