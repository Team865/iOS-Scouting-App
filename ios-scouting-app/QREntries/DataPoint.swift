//
//  DataPoint.swift
//  Scouting
//
//  Created by DUC LOC on 4/5/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
public class DataPoint{
    var type_index = 0
    var value = 0
    var time : Float = 0.0
    
    init(type_index : Int, value : Int, time : Float) {
        self.type_index = type_index
        self.value = value
        self.time = time
    }
}
