//
//  Events.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/16/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation

class Events {
    var name : String
    var info : String
    var key : String
    var date : String
    init(name : String, info : String, key : String, date : String){
        self.name = name
        self.info = info
        self.key = key
        self.date = date
    }
}
