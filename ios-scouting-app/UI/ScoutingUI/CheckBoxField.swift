//
//  Checkbox.swift
//  Scouting
//
//  Created by DUC LOC on 3/29/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class CheckBoxField : UIView, InputControl{
    var scoutingActivity = ScoutingActivity()
    var fieldData = FieldData()
    var checkBox = UIButton()
    var value = 0
    let label = UILabel()
    func setUpView(data : FieldData) {
        self.fieldData = data
        
        addSubview(label)
        addSubview(checkBox)
        
        backgroundColor = UIColor.systemGray5
        
        self.scoutingActivity = data.scoutingActivity
        
        self.tag = data.tag
        
        label.text = data.name
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.systemGray
        label.font = label.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        
        checkBox.layer.borderColor = UIColor.black.cgColor
        checkBox.layer.borderWidth = 1
        checkBox.addTarget(self, action: #selector(activateCheckBox(sender:)), for: .touchUpInside)
        checkBox.isEnabled = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2).isActive = true
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkBox.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -5).isActive = true
        checkBox.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
        checkBox.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4).isActive = true
        
        updateControlState()
    }
    
    func configureCheckBoxForCommentOptions(){
        self.backgroundColor = UIColor.white
        
        label.textColor = UIColor.black
        label.font = label.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.02))
        
        checkBox.backgroundColor = UIColor.white
        checkBox.isEnabled = true
        
        checkBox.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        checkBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (UIScreen.main.bounds.width * 0.05)).isActive = true
        checkBox.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.075).isActive = true
        checkBox.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: -(UIScreen.main.bounds.width * 0.1)).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
    
    func onTimerStarted() {
        self.label.textColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
        self.checkBox.isEnabled = true
  }
    
    func setCheckBoxState(){
        if (self.scoutingActivity.isStarted){
            self.checkBox.isEnabled = true
            if (self.value == 1){
                self.checkBox.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
            } else {
                self.checkBox.backgroundColor = UIColor.systemGray5
            }
           }
    }
    
    func updateControlState() {
        if (self.scoutingActivity.isStarted){
            self.label.textColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                   self.checkBox.isEnabled = true
        }
        
         let newPosition = self.scoutingActivity.qrEntry.lastValue(type: self.tag)?.value ?? 0
               if (self.value != newPosition){
                   self.value = newPosition
                   setCheckBoxState()
               }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("The check box is null")
    }
    
    @objc func activateCheckBox(sender : UIButton){
        if (self.value == 0){
            self.value = 1
        } else {
            self.value = 0
        }
        
        self.scoutingActivity.matchEntry.isScouted = true
        let dataPoint = DataPoint(type_index: self.tag, value: self.value, time: self.scoutingActivity.dataTimer.getTimeStamp())
        
        self.scoutingActivity.qrEntry.addDataPoint(dp: dataPoint)
        
        setCheckBoxState()
    }
}

