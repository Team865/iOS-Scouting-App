//
//  jsonMatchScheduleStructure.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/11/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation

struct Matches : Decodable {
    var alliances : Alliance
    var comp_level : String
    var match_number : Int
}

struct Alliance : Decodable {
    var blue : blueTeam
    var red : redTeam
    
}

struct blueTeam : Decodable {
    var team_keys : [String]
}

struct redTeam : Decodable{
    var team_keys : [String]
}
