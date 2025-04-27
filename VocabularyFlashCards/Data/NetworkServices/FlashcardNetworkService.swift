//
//  FlashcardNetworkService.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 07.12.24.
//

@preconcurrency import Firebase
import FirebaseAuth
import Foundation

@MainActor
protocol FlashcardNetworkServiceProtocol {
    func save(_ flashcard: FlashcardContent, for language: Language) async throws
    func update(_ flashcard: FlashcardContent, for language: Language) async throws -> FlashcardContent
    func load(language: Language) async throws -> [FlashcardContent]?
    func loadSpecificFlashcard(with uuid: UUID, for language: Language) async throws -> FlashcardContent?
    func loadSpecificFlashcardWithWord(containing originalMeaning: String, for language: Language) async throws -> [FlashcardContent]?
    
    func loadAvailableLanguages() async throws -> [String]
    func addLanguage(_ languageCode: String, firstWord: Word) async throws
}

final class FlashcardNetworkService: FlashcardNetworkServiceProtocol {
    typealias Flashcards = [String: FlashcardContent]
    typealias WordOriginalMeaning = String
    
    private var languageCode: String
        
    init(languageCode: String = "") {
        self.languageCode = languageCode
    }
    
    private var ref: DatabaseReference {
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError("User is not logged in")
        }
        return Database.database().reference()
            .child("users")
            .child(uid)
            .child("flashcards")
            .child(languageCode)
    }
    
    func loadAvailableLanguages() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else {
            log.info("User is not logged in")
            throw NetworkError.unauthorized
        }

        let ref = Database.database().reference()
            .child("users")
            .child(uid)
            .child("flashcards")

        let snapshot = try await ref.getData()
        guard let value = snapshot.value as? [String: Any] else {
            log.info("snapshot does not exist")
            return []
        }
        
        let languages = Array(value.keys).sorted()
        return languages
    }
    
    func addLanguage(_ languageCode: String, firstWord: Word) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            log.info("User is not logged in")
            throw NetworkError.unauthorized
        }
        
        let ref = Database.database().reference()
            .child("users")
            .child(uid)
            .child("flashcards")
            .child(languageCode)
        
        let placeholderFlashcard = FlashcardContent(id: UUID(),
                                                    word: firstWord)

        let data = try JSONEncoder().encode(placeholderFlashcard)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        try await ref.child("\(placeholderFlashcard.id)").setValue(dictionary)
    }
    
    func save(_ flashcard: FlashcardContent, for language: Language) async throws {
        log.info("saving flashcard")
        setLanguageCode(languageCode: language.name)
        
        let isDuplicate = try await checkIfDuplicate(with: flashcard, language: language)
        if isDuplicate {
            log.info("Will not save flashcard as word is a duplicate")
            throw NetworkError.duplicate
        }
        
        let data = try JSONEncoder().encode(flashcard)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        try await ref.child("\(flashcard.id)").setValue(dictionary)
    }
    
    func update(_ flashcard: FlashcardContent, for language: Language) async throws -> FlashcardContent {
        setLanguageCode(languageCode: language.name)
        log.info("updating flashcard with id \(flashcard.id)")
        
        // Check if the flashcard exists before updating
        let snapshot = try await ref.child("\(flashcard.id)").getData()
        guard snapshot.exists() else {
            log.info("Flashcard does not exist, cannot update")
            throw NetworkError.notFound
        }
        
        let data = try JSONEncoder().encode(flashcard)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        guard let dictionary else {
            throw NetworkError.noData
        }
        
        try await ref.child("\(flashcard.id)").updateChildValues(dictionary)
        
        log.info("Flashcard updated successfully")
        
        guard let updatedFlashcard = try await loadSpecificFlashcard(with: flashcard.id, for: language) else {
            throw NetworkError.notFound
        }
        return updatedFlashcard
    }
    
    func load(language: Language) async throws -> [FlashcardContent]? {
        setLanguageCode(languageCode: language.name)
        
        let snapshot = try await ref.getData()
        guard let value = snapshot.value else {
            log.info("snapshot does not exist")
            return nil
        }

        if value is NSNull {
            return nil
        }
        
        guard let flashcards = decodeFlashcards(snapshotValue: value) else {
            return nil
        }
        
        log.info("Loading Flashcards for language \(language.name) succeeded")
        return flashcards.map { $0.value }
    }
    
    func loadSpecificFlashcard(with uuid: UUID, for language: Language) async throws -> FlashcardContent? {
        setLanguageCode(languageCode: language.name)
        let snapshot = try await ref.child(uuid.uuidString).getData()
        guard let value = snapshot.value else {
            log.info("snapshot does not exist")
            return nil
        }
        
        return decodeFlashcard(snapshotValue: value)
    }
    
    func loadSpecificFlashcardWithWord(containing originalMeaning: WordOriginalMeaning, for language: Language) async throws -> [FlashcardContent]? {
        setLanguageCode(languageCode: language.name)
        log.info("original meaning: \(originalMeaning)")
        
        let query = ref.queryOrdered(byChild: "flashcardWord/word").queryEqual(toValue: originalMeaning)
        let snapshot = try await query.getData()
        
        guard let flashcards = decodeFlashcards(snapshotValue: snapshot.value) else {
            return nil
        }
        
        return flashcards.map { $0.value }
    }
    
    // MARK: - Private Helpers
    private func checkIfDuplicate(with flashcard: FlashcardContent, language: Language) async throws -> Bool {
        let loadedFlashcard = try await loadSpecificFlashcardWithWord(containing: flashcard.word.originalMeaning, for: language)
        return loadedFlashcard != nil
    }
    
    private func decodeFlashcards(snapshotValue: Any?) -> Flashcards? {
        guard let json = try? JSONSerialization.data(withJSONObject: snapshotValue as Any, options: []) else {
            log.error("jsonSerialization failed")
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let decodedFlashcards = try? decoder.decode(Flashcards.self, from: json) else {
            log.error("DECODING JSON FAILED")
            return nil
        }
        
        return decodedFlashcards
    }
    
    private func decodeFlashcard(snapshotValue: Any?) -> FlashcardContent? {
        guard let json = try? JSONSerialization.data(withJSONObject: snapshotValue as Any, options: []) else {
            log.error("jsonSerialization failed")
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let decodedFlashcard = try? decoder.decode(FlashcardContent.self, from: json) else {
            log.error("decoding json failed")
            return nil
        }
        
        return decodedFlashcard
    }
    
    private func setLanguageCode(languageCode: String) {
        self.languageCode = languageCode
    }
}
