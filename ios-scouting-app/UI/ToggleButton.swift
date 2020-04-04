//
//  ToggleButton.swift
//  Scouting
//
//  Created by DUC LOC on 3/29/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class ToggleButton : UIButton {
    var value : Int?
    var index : Int?
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setUpToggleButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("The view is null")
    }
    
    func setUpToggleButton(){
        titleLabel?.textAlignment = .center
        setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
        backgroundColor = UIColor.systemGray5
    }
}
