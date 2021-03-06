//
//  matchScheduleCells.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/19/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class MatchScheduleCells : UITableViewCell{
    var red1 : UILabel!
    var red2 : UILabel!
    var red3 : UILabel!
    var blue1 : UILabel!
    var blue2 : UILabel!
    var blue3 : UILabel!
    
    var matchNumber : UILabel!
    
    let labelWidth = 50.0
    let labelHeight = UIScreen.main.bounds.height * 0.08 * 0.35
    
    let imageHeight = UIScreen.main.bounds.height * 0.08 * 0.4
    
    let cellWidth = UIScreen.main.bounds.width
    let cellHeight = UIScreen.main.bounds.height * 0.08
    
    
    func setMatch(match : MatchSchedule){
        red1.text = match.redAlliance[0]
        red2.text = match.redAlliance[1]
        red3.text = match.redAlliance[2]
        
        blue1.text = match.blueAlliance[0]
        blue2.text = match.blueAlliance[1]
        blue3.text = match.blueAlliance[2]
        
        matchNumber.text = "M" + String(match.matchNumber)
        self.icon.image = UIImage(named : match.imageName) ?? UIImage(named : "layers")
    }
    
    func configureUILabel(x : Double, y : Double, width : Double, height : Double) -> UILabel{
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.textAlignment = .center
        return label
    }
    
    lazy var icon : UIImageView = {
        let yCoordinate = cellHeight * 0.125
        let image = UIImageView(frame : CGRect(x: Double(cellWidth * 0.05), y: Double(yCoordinate), width: Double(cellWidth * 0.3) - Double(cellWidth * 0.05), height: Double(imageHeight)))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let yCoordinate = cellHeight * 0.125
        let multiplier = 1.25
    
        red1 = configureUILabel(x: Double(cellWidth * 0.3) , y: Double(yCoordinate), width: labelWidth, height: Double(labelHeight))
        red2 = configureUILabel(x: Double(cellWidth * 0.3) + labelWidth, y: Double(yCoordinate), width: Double(labelWidth), height: Double(labelHeight))
        red3 = configureUILabel(x: Double(cellWidth * 0.3) + labelWidth * 2, y: Double(yCoordinate), width: Double(labelWidth), height: Double(labelHeight))

        blue1 = configureUILabel(x: Double(Int(cellWidth * 0.3)), y: Double(yCoordinate) + Double(labelHeight) * multiplier, width: Double(labelWidth), height: Double(labelHeight))
        blue2 = configureUILabel(x: Double(cellWidth * 0.3) + labelWidth, y: Double(yCoordinate) + Double(labelHeight) * multiplier, width: Double(labelWidth), height: Double(labelHeight))
        blue3 = configureUILabel(x: Double(cellWidth * 0.3) + labelWidth * 2, y: Double(yCoordinate) + Double(labelHeight) * multiplier, width: Double(labelWidth), height: Double(labelHeight))
        
        matchNumber = configureUILabel(x: Double(cellWidth * 0.05), y: Double(yCoordinate) + Double(imageHeight) * 1.15, width: Double(cellWidth * 0.3) - Double(cellWidth * 0.05), height: Double(labelHeight))
        
        addSubview(red1)
        addSubview(red2)
        addSubview(red3)
        addSubview(blue1)
        addSubview(blue2)
        addSubview(blue3)
        addSubview(icon)
        addSubview(matchNumber)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
