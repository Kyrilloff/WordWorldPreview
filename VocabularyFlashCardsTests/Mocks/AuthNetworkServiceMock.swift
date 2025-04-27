//
//  AuthNetworkServiceMock.swift
//  VocabularyFlashCardsTests
//
//  Created by Konrad Schmid on 26.04.25.
//

@testable import VocabularyFlashCards

class AuthNetworkServiceMock: AuthNetworkServiceProtocol {
    var createUserSucceeds = false
    let createUserSuccessResult = User.testUser
    let createUserErrorResult = NetworkError.unauthorized
    
    var loginSucceeds = false
    let loginSuccessResult = User.testUser
    let loginErrorResult = NetworkError.unauthorized
    
    var logoutSucceeds: Bool = false
    let logoutErrorResult = NetworkError.unauthorized
    
    func createUser(email: String, password: String) async throws -> User {
        if createUserSucceeds {
            createUserSuccessResult
        } else {
            throw createUserErrorResult
        }
    }
    
    func login(email: String, password: String) async throws -> User {
        if loginSucceeds {
            loginSuccessResult
        } else {
            throw loginErrorResult
        }
    }
    
    func logout() async throws {
        if !logoutSucceeds {
            throw logoutErrorResult
        }
    }
}
