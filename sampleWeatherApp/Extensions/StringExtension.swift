//
//  StringExtension.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 01/02/24.
//

import Foundation

extension String {
    
    func getImageUrl() -> URL? {
        return URL(string: imageBaseUrl+self+imageExtension)
    }

    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }

    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }

    var camelized: String {
        guard !isEmpty else {
            return ""
        }

        let parts = self.components(separatedBy: CharacterSet.alphanumerics.inverted)

        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})

        return ([first] + rest).joined(separator: " ")
    }
}
