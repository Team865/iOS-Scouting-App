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
//func StringBuilder.appendDataPoint(dp: DataPoint) {
//    let intTime = (dp.time * 100).toInt()
//
//    let a = dp.type
//    let b = (dp.value shl 2) or ((intTime and (0b11 shl 12)) shr 12)
//    let c = (intTime and (0b111111 shl 6)) shr 6
//    let d = intTime and 0b111111
//
//    append(toBase64(a))
//    append(toBase64(b))
//    append(toBase64(c))
//    append(toBase64(d))
//}
//
//func encodeDataPoint(dp: DataPoint) -> String {
//    let builder = StringBuilder()
//    builder.appendDataPoint(dp)
//    return builder.toString()
//}
//
//func fromBase64(ch: Int) -> Int = when (ch) {
//    '/'.toInt() -> 63
//    '+'.toInt() -> 62
//    in 48..57 -> ch + 4
//    in 65..90 -> ch - 65
//    in 97..122 -> ch - 71
//    else -> throw IllegalArgumentException("Invalid Base64 Input")
//}
//
//func toBase64(i: Int) -> Character {
//    require(!(i < 0 || i > 63)) { "Invalid Integer Input" }
//    return when {
//        i < 26 -> (i + 65).toChar()
//        i < 52 -> (i + 71).toChar()
//        i < 62 -> (i - 4).toChar()
//        i == 62 -> '+'
//        else -> '/'
//    }
//}
