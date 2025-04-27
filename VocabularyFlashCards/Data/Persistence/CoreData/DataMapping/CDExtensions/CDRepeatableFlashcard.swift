//
//  CDRepeatableFlashcard.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 08.12.24.
//

import CoreData

@MainActor
extension CDRepeatableFlashcard {
    
    static func loadAllCards(for userUID: String,
                             context: NSManagedObjectContext) async throws -> [UUID] {

        let request = CDRepeatableFlashcard.fetchRequest()
        
        let fetchResult = try context.fetch(request)
            .filter { $0.userId == userUID }
        let repeatable = fetchResult.compactMap { $0.repeatableFlashcardId }
        return repeatable
    }
    
    static func storeOrUpdateCard(_ id: UUID,
                                  userUid: String,
                                  context: NSManagedObjectContext) async throws {
        
        if try await getCard(id: id, context: context) != nil {
            log.info("Updating card")
            _ = try await updateCard(id: id,
                                     userUid: userUid,
                                     context: context)
        } else {
            log.info("Storing card")
            _ = try await createCard(id,
                                     userUid: userUid,
                                     context: context)
        }
    }
    
    static func updateCard(id: UUID,
                           userUid: String,
                           context: NSManagedObjectContext) async throws -> CDRepeatableFlashcard? {
        guard let fetchedCard = try await getCard(id: id,
                                                  context: context) else {
            throw StorageError.dataNotFound
        }
        
        fetchedCard.id = id
        fetchedCard.userId = userUid
        
        try context.save()
        return try await getCard(id: id, context: context)
    }
    
    static func createCard(_ id: UUID,
                           userUid: String,
                           context: NSManagedObjectContext) async throws -> CDRepeatableFlashcard {
        
        log.info("Marking for repetition")
        let cdCard = CDRepeatableFlashcard(context: context)
        cdCard.id = id
        cdCard.userId = userUid
        
        try context.save()
        if let card = try await getCard(id: id, context: context) {
            log.info("Marking for repetition succeeded")
            return card
        } else {
            log.error("Marking for repetition failed")
            throw StorageError.dataNotFound
        }
    }
    
    static func deleteCard(id: UUID,
                           context: NSManagedObjectContext) async throws {
        
        guard let cdExercise = try await getCard(id: id, context: context) else {
            throw StorageError.dataNotFound
        }
        
        context.delete(cdExercise)
        try context.save()
    }
    
    static func getCard(id: UUID, context: NSManagedObjectContext) async throws -> CDRepeatableFlashcard? {
        
        let request: NSFetchRequest<CDRepeatableFlashcard> = CDRepeatableFlashcard.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}

extension CDRepeatableFlashcard {
    var repeatableFlashcardId: UUID? {
        guard let id else {
            return nil
        }
        
        return id
    }
}
