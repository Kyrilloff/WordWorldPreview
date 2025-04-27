//
//  Language.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

import Foundation

struct Language: Comparable, Equatable {
    let id: UUID
    let name: String
    var isCurrent: Bool
    
    init(id: UUID,
         name: String,
         isCurrent: Bool = false) {
        self.id = id
        self.name = name
        self.isCurrent = isCurrent
    }
    
    static func == (lhs: Language, rhs: Language) -> Bool {
        lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.isCurrent == rhs.isCurrent
    }
    
    static func < (lhs: Language, rhs: Language) -> Bool {
        lhs.name < rhs.name
    }
}

extension Language {
    static let testLanguage = Language(id: UUID(),
                                       name: "italian")

    static let testLanguageCurrent = Language(id: UUID(),
                                              name: "portuguese",
                                              isCurrent: true)
    
    static let testLanguages = [
        testLanguage,
        testLanguageCurrent
    ]
}
