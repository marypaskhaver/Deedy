//
//  TextFileReader.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/23/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation

class TextFileReader {
    func returnRandomLineFromFile(withName fileName: String) -> String {
        var randomLine = ""

        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                // Reads text file into String
                let data = try String(contentsOfFile: path, encoding: .utf8)
                
                // dropLast() needed to exclude blank line at end of txt file
                let lines = data.components(separatedBy: .newlines).dropLast()
                
                // Pick a random line from the text file, otherwise print an error
                randomLine = lines.randomElement()!
            } catch {
                print("Error getting quote \(error)") 
            }
        }

        return randomLine
    }
}
