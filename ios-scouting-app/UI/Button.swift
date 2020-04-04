//
//  Button.swift
//  Scouting
//
//  Created by DUC LOC on 3/29/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class Button : UIButton {
    var value = 1
    var index : Int?
    override init (frame : CGRect){
        super.init(frame : frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButton(){
        setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
        titleLabel?.numberOfLines = 0
        contentHorizontalAlignment = .center
        titleLabel?.textAlignment = .center
        titleLabel?.lineBreakMode = .byWordWrapping
        backgroundColor = UIColor.systemGray5
        
    }
}
