//
//  FieldData.swift
//  Scouting
//
//  Created by DUC LOC on 5/24/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
class FieldData {
    var name : String = ""
    var type : String = ""
    var choice : [String] = []
    var is_lite : Bool = false
    var tag : Int = 0
    var default_choice : Int = 0
    var scoutingActivity = ScoutingActivity()
    
    func setUpField(name : String, type : String, choice : [String], is_lite : Bool, tag : Int, default_choice : Int, scoutingActivity : ScoutingActivity){
        self.name = name
        self.type = type
        self.choice = choice
        self.is_lite = is_lite
        self.tag = tag
        self.default_choice = default_choice
        self.scoutingActivity = scoutingActivity
    }
}
