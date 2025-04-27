//
//  SettingsScreenRowTypes.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 24.04.25.
//

extension SettingsScreen {
    enum UserDataRowType: CaseIterable {
        case email, password
        
        var description: String {
            switch self {
            case .email:
                return String(localized: "SettingsScreen.RowTitle.Email")
            case .password:
                return String(localized: "SettingsScreen.RowTitle.Password")
            }
        }
    }

    enum AuthRowType: CaseIterable {
        case logout, deleteAccount
        
        var description: String {
            switch self {
            case .logout:
                return String(localized: "SettingsScreen.RowTitle.Logout")
            case .deleteAccount:
                return String(localized: "SettingsScreen.RowTitle.DeleteAccount")
            }
        }
    }
    
    enum LanguageRowType: CaseIterable {
        case add, delete
        
        var description: String {
            switch self {
            case .add:
                return String(localized: "Add New Language")
            case .delete:
                return String(localized: "Delete Language")
            }
        }
    }
}
