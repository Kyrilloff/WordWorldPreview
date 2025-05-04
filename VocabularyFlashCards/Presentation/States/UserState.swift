//
//  UserState.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 07.12.24.
//

import FirebaseAuth
import Observation

enum AuthStatus: Equatable {
    case loading
    case authenticated(User)
    case unauthenticated
}

@MainActor
@Observable
final class UserState {
    
    private let repo: AuthRepositoryProtocol
    
    private(set) var status: AuthStatus = .loading
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    var currentStatus: AuthStatus {
        get { status }
        set { self.status = newValue }
    }

    var currentUser: User? {
        if case .authenticated(let user) = status {
            return user
        }
        return nil
    }

    var isAuthenticated: Bool {
        if case .authenticated = status {
            return true
        }
        return false
    }

    var isLoading: Bool {
        if case .loading = status {
            return true
        }
        return false
    }
    
    init(authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.repo = authRepository
        setupAuthListener()
    }

    private func setupAuthListener() {
        removeAuthListener()
        
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            
            if let user {
                self.currentStatus = .authenticated(User(from: user))
            } else {
                self.currentStatus = .unauthenticated
            }
        }
    }

    private func removeAuthListener() {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            authHandle = nil
        }
    }

    func signUp(email: String, password: String) async throws {
        let user = try await repo.createUser(email: email, password: password)
        currentStatus = .authenticated(user)
    }

    func login(email: String, password: String) async throws {
        let user = try await repo.login(email: email, password: password)
        currentStatus = .authenticated(user)
    }

    func logout() async throws {
        try await repo.logout()
        removeAuthListener()
        currentStatus = .unauthenticated
    }
}
