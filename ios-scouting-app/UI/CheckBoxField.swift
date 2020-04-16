//
//  Checkbox.swift
//  Scouting
//
//  Created by DUC LOC on 3/29/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class CheckBoxField : UIView{
    var title : String?
    var checkBox = CheckBoxButton()
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("The check box is null")
    }
    
    func setUpCheckBox() {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        backgroundColor = UIColor.systemGray5
        addSubview(label)
        addSubview(checkBox)
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 5).isActive = true
        checkBox.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 1.5).isActive = true
        checkBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 6).isActive = true
        label.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 5.5).isActive = true
            
    }
    }

