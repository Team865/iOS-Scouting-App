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
    var scoutingActivity : ScoutingActivity?
    
    var encodedDataPoints = ""
    var encoder = Encoder()
    
    var match : String = ""
    var team : String = ""
    var scout : String = ""
    var board : String = ""
    var referenceTime : Float = 0.0
    var dataPoints : [DataPoint] = []
    var eventKey : String = ""
    var comment : String = ""
    
    func setUpEntry(selectedEntry : MatchEntry) {
        self.match = selectedEntry.matchNumber
        self.team = selectedEntry.teamNumber
        self.scout = selectedEntry.scoutName
        self.board = selectedEntry.board
        self.eventKey = selectedEntry.eventKey
        self.referenceTime = Float(Date().timeIntervalSince1970)
        self.dataPoints = []
    }
    
    func addDataPoint(dp : DataPoint){
        self.dataPoints.insert(dp, at: self.getNextIndexRelavtiveToTime())
    }
    
    func formatString(string : String) -> String{
        let arr = string.trim().components(separatedBy : " ")
        var formmated = ""
        for i in 0..<arr.count{
            formmated += arr[i]
            if (i != arr.count - 1 && arr[i] != ""){
                formmated += "_"
            }
        }
        
        return formmated
    }
    
    func formatDataPointsToString(){
        var encodedDataPoints = ""
        for i in 0..<self.dataPoints.count{
            encodedDataPoints += self.encoder.dataPointToString(dp: dataPoints[i])
        }
        self.encodedDataPoints = encodedDataPoints
    }
    
    func getQRData() -> String {
        formatDataPointsToString()
        //Swift compiler cannot recognize the string if not broken down into smaller sub-expressions
        //https://stackoverflow.com/questions/52382645/the-compiler-is-unable-to-type-check-this-expression-swift-4
        let convertedTimeInterval = Int(self.referenceTime)
        
        let timeToHexaDecimals = String(format : "%02X", convertedTimeInterval)
        
        var formatTeam = self.formatString(string: self.team)
        
        if (self.board.suffix(1) == "X"){
            formatTeam = self.formatString(string: self.team + (" " + (self.scoutingActivity?.matchEntry.opposingTeamNumber ?? "")))
        }
        
        
        let first = self.eventKey + "_" + self.match + ":"
        let second = formatTeam + ":" + self.formatString(string : self.scout) + ":" + self.board + ":"
        let third = timeToHexaDecimals + ":" + self.encodedDataPoints + ":" + self.formatString(string : self.comment)
        
        return (first + second + third)
    }
    
    func undo() -> DataPoint?{
        let nextIndex = self.getNextIndexRelavtiveToTime()
        if (nextIndex == 0){
            return nil
        } else {
            return self.dataPoints.remove(at: nextIndex - 1)
        }
    }
    
    func count(type: Int) -> Int {
        let nextIndex = self.getNextIndexRelavtiveToTime()
        var count = 0
        for i in 0..<nextIndex {
            if (dataPoints[i].type_index == type){
                count += 1
            }
        }
        return count
    }
    
    func lastValue(type: Int) -> DataPoint? {
        let nextIndex = self.getNextIndexRelavtiveToTime()
        
        for i in stride(from: nextIndex - 1, to: -1, by: -1) {
            let dp = dataPoints[i]
            if (dp.type_index == type) {
                return dp
            }
        }
        
        return nil
    }
    
    
    
    func getNextIndexRelavtiveToTime() -> Int{
        let currentTime = self.scoutingActivity?.dataTimer.getTimeStamp() ?? 0
        
        if (dataPoints.count == 0) {
            return 0
        }
        
        // Fix: Don't use <= because we want the last of data points with first time
        if (currentTime < dataPoints[0].time) {
            return 1
        }
        
        if (currentTime >= dataPoints[dataPoints.count - 1].time) {
            return dataPoints.count
        }
        
        var low = 0
        var high = dataPoints.count - 1
        
        // To get the element that we want, use a binary search algorithm
        // instead of iterating over a for-loop. A binary search is O(log(n))
        // whereas searching using a loop is O(n).
        
        while (low != high) {
            let mid = (low + high) / 2
            if (dataPoints[mid].time <= currentTime) {
                low = mid + 1
            } else {
                high = mid
            }
        }
        
        return low
    }
}
