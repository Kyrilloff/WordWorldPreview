//
//  String+Extension.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 23.04.25.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
