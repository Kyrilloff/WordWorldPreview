//
//  AuthRepositoryTests.swift
//  VocabularyFlashCardsTests
//
//  Created by Konrad Schmid on 26.04.25.
//

import Testing
@testable import VocabularyFlashCards

@MainActor
struct AuthRepositoryTests {
    var sut: AuthRepository
    let mockNetworkService = AuthNetworkServiceMock()
    
    init() {
        sut = AuthRepository(networkService: mockNetworkService)
    }
    
    @Test("Create User Failure")
    func createUserFailure() async throws {
        mockNetworkService.createUserSucceeds = false
        await #expect(throws: NetworkError.unauthorized) {
            try await sut.createUser(email: "test@user.de",
                                                      password: "123456")
        }
    }
    
    @Test("Create User Success")
    func createUserSuccess() async throws {
        mockNetworkService.createUserSucceeds = true
        
        do {
            let createUser = try await sut.createUser(email: "test@user.de",
                                                      password: "123456")
            #expect(createUser == User.testUser)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Login Failure")
    func loginFailure() async throws {
        mockNetworkService.loginSucceeds = false
        await #expect(throws: NetworkError.unauthorized) {
            try await sut.login(email: "test@user.de",
                                            password: "123456")
        }
    }
    
    @Test("Login Success")
    func loginSuccess() async throws {
        mockNetworkService.loginSucceeds = true
        do {
            let user = try await sut.login(email: "test@user.de",
                                            password: "123456")
            #expect(user == User.testUser)
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
    
    @Test("Logout Failure")
    func logoutFailure() async throws {
        mockNetworkService.logoutSucceeds = false
        await #expect(throws: NetworkError.unauthorized) {
            try await sut.logout()
        }
    }
    
    @Test("Logout Success")
    func logoutSuccess() async throws {
        mockNetworkService.logoutSucceeds = true
        do {
            try await sut.logout()
        } catch {
            #expect(error == nil,
                    "Test failed unexpectedly with error \(error)")
        }
    }
}
