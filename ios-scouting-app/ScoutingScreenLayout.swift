//
//  ScoutingScreenLayout.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/24/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation

struct ScoutingScreenLayout : Decodable {
    var year : Int
    var revision : Int
    var robot_scout : robot_scout
}

struct robot_scout : Decodable {
    var screens : [screens]
}

struct screens : Decodable{
    var title : String
    var layout : [[layout]]
}
//
struct layout : Decodable {
   var name : String
    var type : String
}

