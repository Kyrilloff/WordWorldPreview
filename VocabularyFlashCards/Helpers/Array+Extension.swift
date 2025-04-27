//
//  Array+Extension.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 08.12.24.
//

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}

extension Array where Element: Comparable {
    func binarySearch(
        for searchText: String,
        keySelector: (Element) -> String
    ) -> [Element] {
        var matches = [Element]()
        let lowercasedSearchText = searchText.lowercased()
        
        // Define search range
        var low = 0
        var high = self.count - 1
        
        while low <= high {
            let mid = (low + high) / 2
            let key = keySelector(self[mid]).lowercased()
            
            if key.contains(lowercasedSearchText) {
                // If the current element matches, search in both directions for additional matches
                matches.append(self[mid])
                
                // Search left of the match
                var left = mid - 1
                while left >= 0 && keySelector(self[left]).lowercased().contains(lowercasedSearchText) {
                    matches.append(self[left])
                    left -= 1
                }
                
                // Search right of the match
                var right = mid + 1
                while right < self.count && keySelector(self[right]).lowercased().contains(lowercasedSearchText) {
                    matches.append(self[right])
                    right += 1
                }
                
                break
            } else if key < lowercasedSearchText {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        
        return matches
    }
}
