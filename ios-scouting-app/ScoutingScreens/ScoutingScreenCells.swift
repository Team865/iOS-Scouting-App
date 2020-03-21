//
//  ScoutingScreenCells.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/20/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class ScoutingScreenCells : UICollectionViewCell{
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var screenNameLabel : UILabel!
    
    func ScreenNameLabel(x : Double, y : Double, width: Double, height : Double) -> UILabel {
        let label = UILabel(frame : CGRect(x: x, y: y, width: width, height: height))
        label.textAlignment = .left
        label.font = label.font.withSize(self.screenHeight * 0.03)
        return label
    }

    func setScreen(screen : ScoutingScreen){
        screenNameLabel.text = screen.title
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.screenNameLabel = ScreenNameLabel(x: Double(self.screenWidth * 0.05), y: Double(self.screenHeight * 0.008), width: Double(self.screenWidth * 0.3), height: Double(self.screenHeight * 0.04))
       
           addSubview(self.screenNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
