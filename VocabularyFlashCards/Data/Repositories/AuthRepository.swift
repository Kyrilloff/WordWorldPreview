//
//  AuthRepository.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import FirebaseAuth
import Foundation

@MainActor
protocol AuthRepositoryProtocol {
    func createUser(email: String,
                    password: String) async throws -> User
    func login(email: String,
               password: String) async throws -> User
    func logout() async throws
}

struct AuthRepository: AuthRepositoryProtocol {
    let networkService: AuthNetworkServiceProtocol
    
    init(networkService: AuthNetworkServiceProtocol = AuthNetworkService()) {
        self.networkService = networkService
    }
    
    func createUser(email: String,
                    password: String) async throws -> User {
        try await networkService.createUser(email: email,
                                            password: password)
    }
    
    func login(email: String,
               password: String) async throws -> User {
        try await networkService.login(email: email,
                                       password: password)
    }
    
    func logout() async throws {
        try await networkService.logout()
    }
}
