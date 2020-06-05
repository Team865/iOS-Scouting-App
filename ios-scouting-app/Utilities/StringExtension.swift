//
//  StringExtension.swift
//  Scouting
//
//  Created by DUC LOC on 6/5/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
extension String
{
    func trim() -> String{
        return self.trimmingCharacters(in : .whitespacesAndNewlines)
    }
    
    var containsSpecialCharacter: Bool {
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
    
    var containsNumber : Bool{
        let decimalCharacters = CharacterSet.decimalDigits

        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
        
        return decimalRange != nil
    }
}





