//
//  AuthNetworkService.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import FirebaseAuth

@MainActor
protocol AuthNetworkServiceProtocol {
    func createUser(email: String, password: String) async throws -> User
    func login(email: String, password: String) async throws -> User
    func logout() async throws
}

struct AuthNetworkService: AuthNetworkServiceProtocol {
    
    func createUser(email: String,
                    password: String) async throws -> User {
        log.info("Creating User")
        let authResult = try await withCheckedThrowingContinuation { continuation in
            Task.detached {
                do {
                    let result = try await Auth.auth().createUser(withEmail: email, password: password)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
        
        return User(from: authResult.user)
    }

    func login(email: String, password: String) async throws -> User {
        log.info("Logging in")
        let authResult = try await withCheckedThrowingContinuation { continuation in
            Task.detached {
                do {
                    let result = try await Auth.auth().signIn(withEmail: email, password: password)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
        
        return User(from: authResult.user)
    }

    func logout() async throws {
        log.info("Logging out")
        try Auth.auth().signOut()
    }

    // TODO: implement
    func resetPassword(email: String) async throws {
        log.info("Resetting password")
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func updatePassword(password: String) async throws {
        log.info("Updating password")
        try await Auth.auth().currentUser?.updatePassword(to: password)
    }

    func deleteAccount() throws {
        log.info("Deleting Account")
        Auth.auth().currentUser?.delete()
    }
}
