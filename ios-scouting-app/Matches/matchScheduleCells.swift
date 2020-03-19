//
//  matchSchedule.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 2/23/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit

class matchScheduleCells: UITableViewCell {

    @IBOutlet weak var dataIcon: UIImageView!
    @IBOutlet weak var matchNumber: UILabel!
    @IBOutlet weak var red1: UILabel!
    @IBOutlet weak var red2: UILabel!
    @IBOutlet weak var red3: UILabel!
    
    @IBOutlet weak var blue1: UILabel!
    @IBOutlet weak var blue2: UILabel!
    @IBOutlet weak var blue3: UILabel!
    
    func setMatch(match : matchSchedule){
        dataIcon.image = match.icon
        matchNumber.text = match.matchNumber
        matchNumber.textColor = UIColor.black
        red1.text = match.redAlliance[0]
        red2.text = match.redAlliance[1]
        red3.text = match.redAlliance[2]
        
        blue1.text = match.blueAlliance[0]
        blue2.text = match.blueAlliance[1]
        blue3.text = match.blueAlliance[2]
    }
}
