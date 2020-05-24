//
//  Timer.swift
//  Scouting
//
//  Created by DUC LOC on 5/19/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
class DataTimer {
    var timeStamp : Float = 0
        
    func setTimeStamp(timeStamp : Float){
        self.timeStamp = timeStamp
    }
    
    func getTimeStamp() -> Float{
        return self.timeStamp
    }
}
