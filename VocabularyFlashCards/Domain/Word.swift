//
//  Word.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 07.12.24.
//

import Foundation

struct Word: Codable, Comparable, Equatable, Hashable, Identifiable {
    let id: UUID
    let originalMeaning: String
    let translation: String
    let gender: Gender
    
    init(id: UUID,
         originalMeaning: String,
         translation: String,
         gender: Gender) {
        self.id = id
        self.originalMeaning = originalMeaning
        self.translation = translation
        self.gender = gender
    }
    
    enum CodingKeys: String, CodingKey {
        case translation, gender
        case id = "wordId"
        case originalMeaning = "word"
    }
    
    static func < (lhs: Word, rhs: Word) -> Bool {
        if lhs.originalMeaning != rhs.originalMeaning {
            return lhs.originalMeaning < rhs.originalMeaning
        }
        if lhs.translation != rhs.translation {
            return lhs.translation < rhs.translation
        }
        if lhs.gender != rhs.gender {
            return lhs.gender < rhs.gender
        }
        return lhs.id < rhs.id
    }
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id
        && lhs.originalMeaning == rhs.originalMeaning
        && lhs.translation == rhs.translation
        && lhs.gender == rhs.gender
    }
}

enum Gender: String, Codable, CaseIterable, Comparable {
    case female
    case none
    case male
    case neuter
    
    var description: String {
        switch self {
        case .female: return "GenderEnum.Feminine.Short".localized
        case .none: return "GenderEnum.None".localized
        case .male: return "GenderEnum.Masculine.Short".localized
        case .neuter: return "GenderEnum.Neuter.Short".localized
        }
    }
    
    var fullDescription: String {
        switch self {
        case .female: return "GenderEnum.Feminine".localized
        case .none: return "GenderEnum.None".localized
        case .male: return "GenderEnum.Masculine".localized
        case .neuter: return "GenderEnum.Neuter".localized
        }
    }
    
    static func < (lhs: Gender, rhs: Gender) -> Bool {
        return lhs.description < rhs.description
    }
}

extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

extension Word {
    static let testWord = Word(id: UUID(),
                               originalMeaning: "developer",
                               translation: "Entwickler",
                               gender: .none)
}
