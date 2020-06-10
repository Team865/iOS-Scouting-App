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
    var value = -1
    let label = UILabel()
    var isCommentOption = false
    func setUpView(data : FieldData) {
        self.fieldData = data
        
        addSubview(checkBox)
        
        backgroundColor = UIColor.systemGray5
        
        self.scoutingActivity = data.scoutingActivity
        
        self.tag = data.tag
        
        checkBox.setTitle(data.name, for: .normal)
        checkBox.titleLabel?.font = checkBox.titleLabel?.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        checkBox.setImage(UIImage(named: "uncheck"), for: .normal)
        checkBox.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        checkBox.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        checkBox.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        checkBox.addTarget(self, action: #selector(activateCheckBox(sender:)), for: .touchUpInside)
        
        if (!isCommentOption){
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
            checkBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
            checkBox.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            checkBox.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true

        } else {
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
            checkBox.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            checkBox.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55).isActive = true
            
            checkBox.titleLabel?.font = checkBox.titleLabel?.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.02))

        }
        
        updateControlState()
    }
    
    func configureCheckBoxForCommentOptions(){
        self.backgroundColor = UIColor.white
        
        checkBox.backgroundColor = UIColor.white
        checkBox.setTitleColor(UIColor.black, for: .normal)
        checkBox.isEnabled = true
        
        self.isCommentOption = true
        
        updateControlState()
    }
    
    func onTimerStarted() {
        self.checkBox.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
        self.checkBox.isEnabled = true
  }
    
    func setCheckBoxState(){
        if ((self.scoutingActivity.isStarted) || isCommentOption){
            self.checkBox.isEnabled = true
            self.checkBox.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
            if (self.value == 1){
                self.checkBox.setImage(UIImage(named : "checked"), for: .normal)
                checkBox.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                checkBox.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            } else {
                    self.checkBox.setImage(UIImage(named : "uncheck"), for: .normal)
                    checkBox.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    checkBox.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    
            }
        } else {
            self.checkBox.setTitleColor(UIColor.systemGray, for: .normal)
            self.checkBox.isEnabled = false
        }
        
    }
    
    func updateControlState() {
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
        
        self.scoutingActivity.playSoundOnAction()
        
        sender.pulsate()
        
        setCheckBoxState()
    }
}

