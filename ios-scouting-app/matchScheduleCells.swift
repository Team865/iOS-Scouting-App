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
    @IBOutlet weak var blueAlliance: UILabel!
    @IBOutlet weak var redAlliance: UILabel!
    
    func setMatch(match : matchSchedule){
        dataIcon.image = match.icon
        matchNumber.text = match.matchNumber
        blueAlliance.text = match.blueAlliance
        redAlliance.text = match.redAlliance
    }
}
