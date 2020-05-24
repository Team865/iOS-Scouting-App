//
//  QREntry.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/26/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation

class Entry {
    var encodedData = ""
    var encodedDataPoints = ""
    var DataPoints = [DataPoint]()
    
    var match : String = ""
    var team : String = ""
    var scout : String = ""
    var board : String = ""
    var referenceTime : Float = 0.0
    var data_point : [DataPoint] = []
    var eventKey : String = ""
    var comment : String = ""
    
    func initializeEntry(selectedEntry : MatchEntry) {
        self.match = selectedEntry.matchNumber
        self.team = selectedEntry.teamNumber
        self.scout = selectedEntry.scoutName
        self.board = selectedEntry.board
        self.eventKey = selectedEntry.eventKey
        self.referenceTime = Float(Date().timeIntervalSinceReferenceDate)
        self.data_point = []
    }
    
    func addDataPoint(dp : DataPoint){
        self.data_point.append(dp)
    }
    
    func updateComment(comment : String){
        
    }
    
    func updateQREntry(entry : Entry){
        self.match = entry.match
        self.team = entry.team
        self.scout = entry.scout
        self.board = entry.board
        self.referenceTime = entry.referenceTime
        self.data_point = entry.data_point
  
    }
    
    func getQREntry() -> Entry {
        return self
    }
}
