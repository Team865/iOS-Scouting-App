//
//  Switch.swift
//  Scouting
//
//  Created by DUC LOC on 3/29/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class Switch : UIButton{
    var value = 0
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setUpSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("A NSCoder is not initialized")
    }
    
    func setUpSwitch(){
        titleLabel?.numberOfLines = 0
        contentHorizontalAlignment = .center
        titleLabel?.textAlignment = .center
        titleLabel?.lineBreakMode = .byWordWrapping
        setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
        backgroundColor = UIColor.systemGray5
              
    }
}
