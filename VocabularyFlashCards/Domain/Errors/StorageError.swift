//
//  StorageError.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 08.12.24.
//

public enum StorageError: Error {
    case dataNotFound
    case conversionFromCDFailed
    case unexpectedReturn
    case storingFailed
    case currentLanguageIsNotSet
}
