//
//  MatchEntry.swift
//  Scouting
//
//  Created by DUC LOC on 5/20/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
class MatchEntry {
    var board = ""
    var scoutName = ""
    var matchNumber = ""
    var opposingTeamNumber = ""
    var teamNumber = ""
    var eventKey = ""
    var scoutedData = ""
    var atIndex = 0
    var isScouted = false
    var addedEntry = false
    func setMatchEntry(board : String, scoutName : String, matchNumber : String, opposingTeamNumber : String, teamNumber : String, eventKey : String, atIndex : Int, isScouted : Bool, addedEntry : Bool, scoutedData : String) {
        self.board = board 
        self.scoutName = scoutName
        self.matchNumber = matchNumber
        self.opposingTeamNumber = opposingTeamNumber
        self.teamNumber = teamNumber
        self.eventKey = eventKey
        self.atIndex = atIndex
        self.isScouted = isScouted
        self.addedEntry = addedEntry
        self.scoutedData = scoutedData
    }
}
