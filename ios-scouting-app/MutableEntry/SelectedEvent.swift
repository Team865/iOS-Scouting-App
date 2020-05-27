//
//  SelectedEvent.swift
//  Scouting
//
//  Created by DUC LOC on 5/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
class SelectedEvent {
    var year = ""
    var eventKey = ""
    var eventName = ""
    
    func setEvent(year : String, eventKey : String, eventName : String){
        self.year = year
        self.eventKey = eventKey
        self.eventName = eventName
    }
}
