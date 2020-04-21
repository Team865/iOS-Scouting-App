//
//  ButtonField.swift
//  Scouting
//
//  Created by DUC LOC on 4/11/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class ButtonField : UIView{
    let counterField = UILabel()
    var button = UIButton()
    var value = 1
    var counter = 0
    var buttonTitle = ""
    override init (frame : CGRect){
        super.init(frame : frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButtonField(){
        counterField.text = String(self.counter)
        backgroundColor = UIColor.systemGray5
        addSubview(button)
        addSubview(counterField)
        
        button.setTitle(self.buttonTitle, for: .normal)
        button.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .center
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        backgroundColor = UIColor.systemGray5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 0).isActive = true
        button.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0).isActive = true
        button.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 0).isActive = true
        button.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 0).isActive = true
        
        counterField.translatesAutoresizingMaskIntoConstraints = false
        counterField.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 0.5).isActive = true
        counterField.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0.5).isActive = true
        counterField.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 0).isActive = false
        counterField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = false
    }
}
