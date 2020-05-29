//
//  matchSchedules.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 2/23/20.
//  Copyright © 2020 Warp7. All rights reserved.
//
import Foundation
import UIKit
class MatchSchedule{
    var imageName : String = ""
    var matchNumber : Int = 0
    var redAlliance : [String] = []
    var blueAlliance : [String] = []
    var board : String = ""
    var isScouted : Bool = false
    var scoutedData : String = ""
    func setUpMatchSchedule(imageName : String, matchNumber : Int, redAlliance : [String], blueAlliance : [String], board : String, isScouted : Bool, scoutedData : String){
        self.imageName = imageName
        self.matchNumber = matchNumber
        self.board = board
        self.isScouted = isScouted
        self.scoutedData = scoutedData
        
        self.blueAlliance.append(contentsOf: blueAlliance)
        
        self.redAlliance.append(contentsOf: redAlliance)
    }
}
