//
//  matchSchedules.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 2/23/20.
//  Copyright © 2020 Warp7. All rights reserved.
//
import Foundation
import UIKit
class matchSchedule{
    var imageName : String
    var matchNumber : Int
    var redAlliance : [String] = []
    var blueAlliance : [String] = []
    var board : String
    var isScouted : Bool
    init(imageName : String, matchNumber : Int, redAlliance : [String], blueAlliance : [String], board : String, isScouted : Bool){
        self.imageName = imageName
        self.matchNumber = matchNumber
        self.board = board
        self.isScouted = isScouted
        self.blueAlliance.append(contentsOf: blueAlliance)
        
        self.redAlliance.append(contentsOf: redAlliance)
    }
}
