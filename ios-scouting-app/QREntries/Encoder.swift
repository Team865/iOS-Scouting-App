//
//  Encoder.swift
//  Scouting
//
//  Created by DUC LOC on 4/9/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
/**
 * 24-bit data point encoder, into 4 base64 chars
 * 000000 000000 000000 000000
 * bit 1-6: type
 * bit 7-10: value
 * bit 11-24: time
 */
var data = ""

class Encoder {
    
func require(format : Bool, integer : Int) -> Bool{
        if !(integer < 0 || integer > 63) {
            return true
        } else {
            return false
        }
    }
    
func dataPointToString(dp: DataPoint) {
    let intTime = Int(dp.time * 100)

    let a = dp.type_index
    let b = (dp.value << 2) | ((intTime & (0b11 << 12)) >> 12)
    let c = (intTime & (0b111111 << 6)) >> 6
    let d = intTime & 0b111111

    data += String(toBase64(i: a))
    data += String(toBase64(i: b))
    data += String(toBase64(i: c))
    data += String(toBase64(i: d))
}

func fromBase64(ch: Int) -> Int {
    var valueToReturn = 0
    if (ch == Character("/").asciiValue ?? 0){
        valueToReturn = 63
    } else if (ch == Character("+").asciiValue ?? 0){
        valueToReturn = 62
    } else if (ch >= 48 && ch <= 57){
        valueToReturn = ch + 4
    } else if (ch >= 65 && ch <= 90){
        valueToReturn = ch - 65
    } else if (ch >= 97 && ch <= 122){
        valueToReturn = ch - 71
    } else {
        
    }
    return valueToReturn
}

    
func toBase64(i: Int) -> Character {
    if require(format: !(i < 0 || i > 63), integer: i) { print("Invalid Integer Input") }
    
    if (i < 26){
        return Character(UnicodeScalar(i + 65)!)
    } else if (i < 52){
        return Character(UnicodeScalar(i + 71)!)
    } else if (i < 62){
        return Character(UnicodeScalar(i - 4)!)
    } else if (i == 62){
        return "+"
    } else {
        return "/"
    }
    }
}
