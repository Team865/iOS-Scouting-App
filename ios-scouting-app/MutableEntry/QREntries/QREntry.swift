//
//  QREntry.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/26/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

public class Entry {
    var encodedDataPoints = ""
    
    var encoder = Encoder()
    
    var match : String = ""
    var team : String = ""
    var scout : String = ""
    var board : String = ""
    var referenceTime : Float = 0.0
    var data_point : [DataPoint] = []
    var eventKey : String = ""
    var comment : String = ""
    
    func setUpEntry(selectedEntry : MatchEntry) {
        self.match = selectedEntry.matchNumber
        self.team = selectedEntry.teamNumber
        self.scout = selectedEntry.scoutName
        self.board = selectedEntry.board
        self.eventKey = selectedEntry.eventKey
        self.referenceTime = Float(Date().timeIntervalSince1970)
        self.data_point = []
    }
    
    func addDataPoint(dp : DataPoint){
        self.data_point.append(dp)
    }
    
    func formatString(string : String) -> String{
        let arr = string.components(separatedBy : " ")
        var formmated = ""
        for i in 0..<arr.count{
            formmated += arr[i] + "_"
        }
        
        return formmated
    }
    
    func formatDataPointsToString(){
        var encodedDataPoints = ""
        for i in 0..<self.data_point.count{
            encodedDataPoints += self.encoder.dataPointToString(dp: data_point[i])
        }
        self.encodedDataPoints = encodedDataPoints
    }
    
    func getQRData() -> String {
        formatDataPointsToString()
        //Swift compiler cannot recognize the string if not broken down into smaller sub-expression
        //https://stackoverflow.com/questions/52382645/the-compiler-is-unable-to-type-check-this-expression-swift-4
        let timeToHexaDecimals = String(format:"%02X", String(self.referenceTime))
        
        let first = self.eventKey + "_" + self.match + ":"
        let second = self.team + ":" + self.formatString(string : self.scout) + ":" + self.board + ":"
        let third = timeToHexaDecimals + ":" + self.encodedDataPoints + ":" + self.formatString(string : self.comment)

        return (first + second + third)
    }
}
