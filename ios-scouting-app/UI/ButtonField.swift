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
    var button = Button()
    var counter = 0
    override init (frame : CGRect){
        super.init(frame : frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButtonField(){
        let counter = UILabel()
        counter.text = String(self.counter)
        backgroundColor = UIColor.systemGray5
        addSubview(button)
        addSubview(counter)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 0).isActive = true
        button.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0).isActive = true
        button.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 0).isActive = true
        button.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 0).isActive = true
        
        counter.translatesAutoresizingMaskIntoConstraints = false
        counter.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 0.5).isActive = true
        counter.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0.5).isActive = true
        counter.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 0).isActive = false
        counter.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = false
    }
}
