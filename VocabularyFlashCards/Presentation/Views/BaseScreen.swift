//
//  BaseScreen.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import SwiftUI

struct BaseScreen: View {
    @Environment(UserState.self) var userState
    @State private var showLoginView = false

    var body: some View {
        ZStack {
            switch userState.status {
            case .loading:
                ProgressView("BaseScreen.ProgressView.Title")
                    .progressViewStyle(.circular)
            case .authenticated:
                FlashcardScreen()
            case .unauthenticated:
                DummyFlashcardScreen()
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            NavigationStack {
                AuthScreen()
            }
        }
        .onChange(of: userState.status) { _, newStatus in
            showLoginView = (newStatus == .unauthenticated)
        }
        .onAppear {
            showLoginView = (userState.status == .unauthenticated)
        }
    }
}

#Preview {
    NavigationStack {
        BaseScreen()
            .environment(UserState())
            .environment(FlashcardState())
    }
}
