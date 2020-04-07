//
//  DataPoint.swift
//  Scouting
//
//  Created by DUC LOC on 4/5/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
class DataPoint{
    var type_index : Int?
    var value : Int?
    var time : Float?
    
    init(type_index : Int, value : Int, time : Float) {
        self.type_index = type_index
        self.value = value
        self.time = time
    }
}
