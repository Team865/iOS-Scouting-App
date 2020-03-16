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
    var red1 : String
    var red2 : String
    var red3 : String
    var blue1 : String
    var blue2 : String
    var blue3 : String
    
    
    
    init(icon : UIImage, matchNumber : String, blue1 : String, blue2 : String, blue3 : String, red1 : String, red2: String, red3 : String){
        self.icon = icon
        self.matchNumber = matchNumber
        
        self.blue1 = blue1
        self.blue2 = blue2
        self.blue3 = blue3
        
        self.red1 = red1
        self.red2 = red2
        self.red3 = red3
    }
}
