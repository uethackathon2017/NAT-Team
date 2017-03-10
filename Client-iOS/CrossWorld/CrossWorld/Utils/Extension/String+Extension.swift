//
//  String+Extension.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit

extension String {
    
    // check string blank
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    // Validate Email
    var isEmail: Bool {
        get {
            do {
                let express = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
                return express.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
            } catch {
                return false
            }
        }
    }
    
    // Validate phone number
    var isPhone: Bool {
        let character  = CharacterSet(charactersIn: "+0123456789()-").inverted
        let inputString = self.components(separatedBy: character)
        let filtered = inputString.joined(separator: "")
        return self == filtered
    }
    
    // Validate full name
    var isFirstName: Bool {
        let arrString = matchesForRegexInText("[A-Z0-9a-z]", text: self)
        if arrString.count == self.characters.count {
            return true
        }
        return false
    }
    
    func matchesForRegexInText(_ regex: String!, text: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text,
                                        options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    var isNumber: Bool {
        let char = CharacterSet.init(charactersIn: "0123456789").inverted
        let inputString = components(separatedBy: char)
        let filtered = inputString.joined(separator: "")
        return self == filtered
    }
    
    // check have capital letter
    var haveCapitalLetter: Bool {
        let char = CharacterSet.uppercaseLetters.inverted
        let inputString = components(separatedBy: char)
        let filtered = inputString.joined(separator: "")
        return filtered != ""
    }
    
    // check have smaller letter
    var haveSmallLetter: Bool {
        let char = CharacterSet.lowercaseLetters.inverted
        let inputString = components(separatedBy: char)
        let filtered = inputString.joined(separator: "")
        return filtered != ""
    }
    
    func haveCharacterInString(_ string: String) -> Bool {
        let char = CharacterSet(charactersIn: string).inverted
        let inputString = components(separatedBy: char)
        let filtered = inputString.joined(separator: "")
        return filtered != ""
    }
    
    // check is password
    var isPassword: Bool {
        if self.characters.count > 5 {
            //            if self.haveSmallLetter && self.haveCapitalLetter && self.haveCharacterInString("$#%&@!*") {
            //                return true
            //            } else {
            //                return false
            //            }
            return true
        } else {
            return false
        }
    }
    
    // caculate width of string
    func getWidthOfString(_ fontSize: CGFloat) -> CGFloat {
        let label = UILabel()
        label.text = self
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.numberOfLines = 1
        label.sizeToFit()
        return label.frame.width
    }
    
    /**
     Convert number string to formated number string
     
     - Author: Anh Son
     - Parameters:
     - format: String format Float number (ex: ".3", ".2")
     - Returns: String of formated number
     - Throws:
     */
    func toFloat(format: String) -> String? {
        if let number = Float.init(self) {
            return String(format: "%\(format)f", number)
        }
        return nil
    }
}
