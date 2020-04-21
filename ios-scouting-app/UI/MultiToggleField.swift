//
//  MultiToggle.swift
//  Scouting
//
//  Created by DUC LOC on 4/4/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class MultiToggleField : UIView{
    var title : String?
    var numberOfButtons = 0
    var listOfToggleTitles : [String] = []
    //We know that the default value is 2, but we need to be able to change this dynamically
    var value = 2
    override init(frame: CGRect) {
        super.init(frame : frame)
        setUpToggleField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpToggleField(){
        backgroundColor = UIColor.systemGray5
        
        let label = UILabel()
        let toggleButtons = UIStackView()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        toggleButtons.axis = .horizontal
        toggleButtons.distribution = .fillEqually
        toggleButtons.spacing = 0
        
        toggleButtons.translatesAutoresizingMaskIntoConstraints = false
        toggleButtons.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        toggleButtons.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        toggleButtons.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        for i in 0..<numberOfButtons{
            let toggleButton = UIButton()
            if (i == value){
            toggleButton.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
            toggleButton.titleLabel?.textColor = UIColor.systemGray5
            } else {
                toggleButton.backgroundColor = UIColor.systemGray5
                toggleButton.titleLabel?.textColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
            }
            toggleButton.setTitle(listOfToggleTitles[i], for: .normal)
            toggleButton.titleLabel?.textAlignment = .center
        }
        
        addSubview(label)
        addSubview(toggleButtons)
    }
    
   
}
