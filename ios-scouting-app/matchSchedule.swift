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
    var icon : UIImage
    var matchNumber : String
    var blueAlliance : String
    var redAlliance : String
   
    
    
    init(icon : UIImage, matchNumber : String, blueAlliance : String, redAlliance : String){
        self.icon = icon
        self.matchNumber = matchNumber
        self.blueAlliance = blueAlliance
        self.redAlliance = redAlliance
    }
}
