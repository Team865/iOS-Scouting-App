//
//  CheckBoxButton.swift
//  Scouting
//
//  Created by DUC LOC on 4/4/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class CheckBoxButton : UIButton {
    var index : Int?
    var value = 0
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setUpCheckBoxButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Check box not initialized")
    }
    
    func setUpCheckBoxButton(){
        frame = CGRect(x : Double(UIScreen.main.bounds.width) * 0.05, y : 0, width : Double(UIScreen.main.bounds.height) * 0.85 * 0.0235, height : Double(UIScreen.main.bounds.height) * 0.85 * 0.0235)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
    }
}
