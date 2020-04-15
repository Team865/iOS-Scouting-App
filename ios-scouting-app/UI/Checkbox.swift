//
//  Checkbox.swift
//  Scouting
//
//  Created by DUC LOC on 3/29/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class CheckBox : UIView{
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
        checkBox.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        checkBox.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: 20).isActive = true
        checkBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        label.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
        
    }
    }

