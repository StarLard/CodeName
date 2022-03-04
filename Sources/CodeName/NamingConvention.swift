//
//  NamingConvention.swift
//  CodeName
//
//  Created by Friden, Caleb on 2/19/22.
//  Copyright © 2022 Friden, Caleb. All rights reserved.
//

import Foundation
import ArgumentParser

enum NamingConvention: String, ExpressibleByArgument {
    case camel, kebab, natural, snake
    
    func seperate(text: String) -> [String] {
        switch self {
        case .camel:
            var components: [String] = []
            
            var componentChars: [String.UnicodeScalarView.Element] = []
            var lastChar: String.UnicodeScalarView.Element?
            
            func closeComponent() {
                defer { componentChars = [] }
                var component = ""
                component.unicodeScalars.append(contentsOf: componentChars)
                guard !component.isEmpty else { return }
                components.append(component)
            }
            
            for char in text.unicodeScalars {
                defer { lastChar = char }
                guard char.isLetter else {
                    componentChars.append(char)
                    continue
                }
                if char.isCapitalLetter {
                    if let lastChar = lastChar, !lastChar.isCapitalLetter {
                        closeComponent()
                    }
                    componentChars.append(char)
                } else {
                    if let lastChar = lastChar, lastChar.isCapitalLetter {
                        componentChars = componentChars.dropLast()
                        closeComponent()
                        componentChars = [lastChar, char]
                    } else {
                        componentChars.append(char)
                    }
                }
            }
            
            closeComponent()
            return components
        case .kebab:
            return text.split(separator: "-").map(String.init(_:))
        case .natural:
            return text.split(separator: " ").map(String.init(_:))
        case .snake:
            return text.split(separator: "_").map(String.init(_:))
        }
    }
    
    func join(components: [String]) -> String {
        switch self {
        case .camel:
            guard let head = components.first?.lowercased() else { return "" }
            let tail = components.dropFirst()
            guard !tail.isEmpty else { return head }
            return head + tail.map(\.firstLetterCapitalized).joined()
        case .kebab:
            return components.joined(separator: "-")
        case .natural:
            return components.joined(separator: " ")
        case .snake:
            return components.joined(separator: "_")
        }
    }
}

private extension String.UnicodeScalarView.Element {
    var isLetter: Bool {
        return CharacterSet.letters.contains(self)
    }
    
    var isCapitalLetter: Bool {
        return CharacterSet.uppercaseLetters.contains(self)
    }
}

private extension String {
    var firstLetterCapitalized: String {
        let firstChar = String(prefix(1)).capitalized
        let remainder = String(dropFirst())
        return firstChar + remainder
    }
}
