//
//  MatchEntry.swift
//  Scouting
//
//  Created by DUC LOC on 5/20/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
class MatchEntry {
    var board : String = ""
    var scoutName : String = ""
    var matchNumber : String = ""
    var opposingTeamNumber : String = ""
    var teamNumber : String = ""
    var eventKey : String = ""
    func setMatchEntry(board : String, scoutName : String, matchNumber : String, opposingTeamNumber : String, teamNumber : String, eventKey : String) {
        self.board = board
        self.scoutName = scoutName
        self.matchNumber = matchNumber
        self.opposingTeamNumber = opposingTeamNumber
        self.teamNumber = teamNumber
        self.eventKey = eventKey
    }
}
