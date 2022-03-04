//
//  main.swift
//  CodeName
//
//  Created by Friden, Caleb on 2/19/22.
//  Copyright © 2022 Friden, Caleb. All rights reserved.
//

import Foundation
import ArgumentParser

struct CodeName: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "codename",
        abstract: "A command line tool for converting between common programming naming conventions.",
        version: "1.0.0")
    
    @Option(name: .shortAndLong, help: "The naming convention used by the input text.")
    var oldConvention: NamingConvention
    
    @Option(name: .shortAndLong, help: "The new naming convention to use for the output text.")
    var newConvention: NamingConvention
    
    @Argument(help: "The text to convert using the new convention.")
    var text: String
    
    mutating func run() throws {
        guard oldConvention != newConvention else {
            print(text)
            return
        }
        
        let components = oldConvention.seperate(text: text)
        let converted = newConvention.join(components: components)
        print(converted)
    }
}

CodeName.main()
