//
//  MultiToggle.swift
//  Scouting
//
//  Created by DUC LOC on 4/4/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

public class ToggleButton : UIButton{
    var value = 0
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MultiToggleField : UIView, InputControl{
    var scoutingActivity = ScoutingActivity()

    func setUpView(data: FieldData) {
        backgroundColor = UIColor.systemGray5
        
        let label = UILabel()
        let toggleButtons = UIStackView()
        
        addSubview(label)
        addSubview(toggleButtons)
        
        self.scoutingActivity = data.scoutingActivity
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3) .isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        label.textAlignment = .center
        label.textColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
        label.text = data.name
        
        toggleButtons.axis = .horizontal
        toggleButtons.distribution = .fillEqually
        toggleButtons.spacing = 0
        
        toggleButtons.translatesAutoresizingMaskIntoConstraints = false
        toggleButtons.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toggleButtons.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        toggleButtons.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        toggleButtons.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        let choice = data.choice?.count ?? 0
        
        for i in 0..<choice{
            toggleButton = ToggleButton()
            toggleButton.setTitle(data.choice?[i], for: .normal)
            toggleButton.titleLabel?.textAlignment = .center
            toggleButton.addTarget(self, action: #selector(getSelectedToggleButton(sender:)), for: .touchUpInside)
            toggleButton.tag = self.tag
            toggleButton.value = i
            if (i == data.default_choice){
                toggleButton.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                toggleButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                toggleButton.backgroundColor = UIColor.systemGray5
                toggleButton.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
            }
            
            toggleButtons.addArrangedSubview(toggleButton)
        }
    }
    
    func onTimerStarted() {
        //MultiToggle does not have any action when the timer is started
    }
    
    var toggleButton = ToggleButton()
    var defaultValue = 0
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func getSelectedToggleButton(sender : ToggleButton){
        self.defaultValue = sender.value
    }
    
}
