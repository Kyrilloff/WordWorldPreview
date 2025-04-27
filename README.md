#  Vocabulary FlashCards
This app helps learning vocabulary. Users can create languages and words. Words can be marked and unmarked for repetition.

## Build Requirements

- Xcode 16
- Swift 6

## Deployment Targets

- iOS 18
- iPhone (portrait)

## Technologies & Architecture

- SwiftUI
- MVVM Architecture
- Repository Pattern

## Databases / Services

- Firebase DB
- Core Data (local)
- Firebase Auth (authentication)

## Dependencies / Frameworks

- Firebase Realtime Database
- Firebase Auth

# Main Screens
Main view names end with "Screen", subview names end with "View" to make the structure easier to navigate.

## FlashcardScreen
The Screen consists of four sections with different data.

### Navbar menu
There are four buttons in the navigation bar which will be active based on the selected section. 
From left to right, first there is the **regenerate button**, which picks new random words for the Random 20 and Repeat 20 list from all words.
Secondly, there is the **invert button** which changes if the original or the translation will be shown on the left side of the list, so the users can decide if they want to hide the translation or the original, depending on which of the two they want to learn.
Then there is the **settings button** which leads to the SettingScreen. It is available in every section of the FlashcardScreen. 
On the very right there is the **add button**, which can be used to add a new word.
 
### Sections
In the **All Words section** the user can see and search all words that were added to a language. By Swiping left words can be marked for repetition and will then appear in the repetition sections. New words can be added by tapping the add button inside of the navbar which will open a detail view with word information to fill in. Existing words are editable by tapping on a word row. This will open a detail view with the editable word information. 

The **Random 20 Section** shows 20 words picked randomly from all words of the current language. This is the part where users can test their knowledge. The translations can be hidden or shown by tapping on a word row. A word can be marked as repeatable in this section by swiping left. New random words can be picked by tapping the regenerate button in the navbar. The learning direction can be inverted from original to translation and vice versa by hitting the invert button.


**Repeat All** shows all words of a language that are marked as repeatable. Words can be unmarked by swiping left and will then disappear from the list. Again, translations can be hidden or shown by tapping on a word row. In this section the learning direction can be inverted by hitting the invert button in the navbar.

In the **Repeat 20 section** users can see 20 randomly picked words from the repetition list. The learning direction is invertable and the words can be picked again by tapping the regenerate button.

## Settings Screen
The Settings Screen shows general information - the email address of the user and the current language (if there is more than one).
From this screen the user can change the password, add or select a new language, delete a language, logout or delete the user account.
Add new language will trigger a Detail View where the language name and its first word can be set and saved. After saving a new language, it will be available inside of the selected language picker in the SettingsScreen where it can be set as the current language. Selecting a different language here will make the FlashcardScreen content reload. 
Tapping the logout button will dismiss the SettingsScreen and present the AuthScreen

## AuthScreen
This screen is the entry point of the app - users can either login with e-mail /  password or register. The registration is a two step process. Firstly, email and password need to be filled in. In the second step a language needs to be added by providing a language name and its first word. 
After successful registration or login, the FlashcardScreen will appear

# Architecture
## MVVM + Repository Pattern
The app uses the MVVM architecture with a repository pattern for data handling. State classes manage general, app-wide data (user and flashcard data). ViewModels are tied to specific views. Each ViewModel manages the view-specific state and handles presentation logic, like enabling buttons or formatting inputs.

Repositories manage data fetching and storage, keeping the global state classes cleaner. 

The Views are focusing on presentation and layout.

## View Models / States
The App has a FlashcardState for data concerning languages and words and a UserState for user-specific data.

The States and ViewModels use SwiftUI's Observation framework, which makes the data available and trackable for the views.

## Repositories
There are three repositories. The AuthRepository which handles user data (network only), the LanguageRepository which handles language data (network and local storage) and the FlashcardRepository, handling flashcard data. Flashcard repetition data is only saved locally.

## Local Storage / Network Service
The network service communicates with a firebase realtime database which stores user specific languages and flashcard data. It also handles the authentication by communicating with firebase auth.
As a local storage CoreData is used. It contains data about repeatable flashcards (uuids) and the user's languages.


## Folder Structure
The project is organized based on clean architecture with:

- Domain Layer: Entities and Errors
- Data Layer: Services (network / local storage) and repositories
- Presentation Layer: Views, view models, and states

Additionally there is a folder for Helpers, containing a logger and type extensions, a folder for resources like the String Catalogue and Assets like images, etc. Last but not least there is a Modules folder that hosts internal libraries that are used to make the app more modular. 

# Testing
## Unit Tests
The repositories and the local storage service are currently covered by unit tests. For testing Swift Testing framework was used.

# Libraries
The SharedComponents library was created to contain reusable elements and general information of the app like colors and constants.

# Localization
Localization via String Catalogue was added although there is only one language, as it allowed to concentrate all strings at a central point. Like this the views only know references to the string catalogue and there is a single source of truth for string management and translation.
