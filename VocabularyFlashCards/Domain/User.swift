//
//  User.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 26.04.25.
//

import FirebaseAuth

struct User: Equatable, Sendable {
    let uid: String
    let email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
    
    init(from fibUser: FirebaseAuth.User) {
        self.uid = fibUser.uid
        self.email = fibUser.email
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
        && lhs.email == rhs.email
    }
}

extension User {
    static let testUser = User(uid: "gVZe5ZbnJ6a688vuhmxO7CwGxLx1",
                               email: "test@user.de")
}
