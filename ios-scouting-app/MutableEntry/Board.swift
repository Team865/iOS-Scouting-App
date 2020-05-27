//
//  Board.swift
//  Scouting
//
//  Created by DUC LOC on 5/20/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class Board {
    var name = ""
    var shortenedName = ""
    var color = UIColor()
    init(name : String, shortenedName : String, color : UIColor) {
        self.name = name
        self.shortenedName = shortenedName
        self.color = color
    }
    
}

enum SelectedBoard {
    
}
