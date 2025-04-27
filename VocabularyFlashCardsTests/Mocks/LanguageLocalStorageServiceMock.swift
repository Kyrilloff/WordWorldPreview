//
//  LanguageLocalStorageServiceMock.swift
//  VocabularyFlashCardsTests
//
//  Created by Konrad Schmid on 27.04.25.
//

import Foundation
@testable import VocabularyFlashCards

class LanguageLocalStorageServiceMock: LanguageLocalStorageServiceProtocol {
    
    var saveLanguagesSucceeds = false
    let saveLanguagesSuccessResult = Language.testLanguages
    let saveLanguagesErrorResult = StorageError.storingFailed
    
    var loadLanguagesSucceeds = false
    let loadLanguagesSuccessResult = Language.testLanguages
    let loadLanguagesErrorResult = StorageError.dataNotFound
    
    var loadCurrentLanguageSucceeds = false
    let loadCurrentLanguageSuccessResult = Language.testLanguageCurrent
    let loadCurrentLanguageErrorResult = StorageError.currentLanguageIsNotSet
    
    var setCurrentLanguageSucceeds = false
    let setCurrentLanguageErrorResult = StorageError.storingFailed
    
    var deleteAllLanguagesSucceeds = false
    let deleteAllLanguagesErrorResult = StorageError.dataNotFound
    
    func saveLanguages(_ languages: [String]) async throws -> [Language] {
        if saveLanguagesSucceeds {
            saveLanguagesSuccessResult
        } else {
            throw saveLanguagesErrorResult
        }
    }
    
    func loadLanguages() async throws -> [Language] {
        if loadLanguagesSucceeds {
            loadLanguagesSuccessResult
        } else {
            throw loadLanguagesErrorResult
        }
    }
    
    func setCurrentLanguage(languageName: String) async throws {
        if !setCurrentLanguageSucceeds {
            throw setCurrentLanguageErrorResult
        }
    }
    
    func loadCurrentLanguage() async throws -> Language? {
        if loadCurrentLanguageSucceeds {
            loadCurrentLanguageSuccessResult
        } else {
            throw loadCurrentLanguageErrorResult
        }
    }
    
    func deleteAllLanguages() async throws {
        if !deleteAllLanguagesSucceeds {
            throw deleteAllLanguagesErrorResult
        }
    }
}
