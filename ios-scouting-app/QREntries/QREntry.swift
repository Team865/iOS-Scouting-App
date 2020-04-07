//
//  QREntry.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/26/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
class Entry : ReflectedStringConvertible{
    var match : String = ""
    var team : Int = 1
    var scout : String = ""
    var board : String = ""
    var timeStamp : Float = 00
    var data_point : [DataPoint] = []
    
    init(match : String, team : Int, scout : String, board : String, timeStamp : Float, data_point : [DataPoint]) {
        self.match = match
        self.team = team
        self.scout = scout
        self.board = board
        self.timeStamp = timeStamp
        self.data_point = data_point
    }
}
