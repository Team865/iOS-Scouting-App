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
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    func createMatchNumberLabel(x : Double, y : Double, width: Double, height : Double) -> UILabel {
        let label = UILabel(frame : CGRect(x: x, y: y, width: width, height: height))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "M1"
        return label
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        let matchNumber = createMatchNumberLabel(x: Double(self.screenWidth * 0.01), y: -Double(self.screenHeight * 0.025), width: Double(self.screenWidth * 0.2), height: Double(self.screenHeight * 0.15))
        addSubview(matchNumber)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
