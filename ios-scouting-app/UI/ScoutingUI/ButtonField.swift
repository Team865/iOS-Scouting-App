//
//  ButtonField.swift
//  Scouting
//
//  Created by DUC LOC on 4/11/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

public class ButtonField : UIView, InputControl{
    
    var isBeingFocused = false
    var isHeldDown = false
    var scoutingActivity = ScoutingActivity()
    let counterField = UILabel()
    var button = UIButton()
    var fieldData = FieldData()
    
    var timeStamp : Float = -2.0
    
    func setUpView(data: FieldData) {
        self.fieldData = data
        self.scoutingActivity = data.scoutingActivity
        
        counterField.font = counterField.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        backgroundColor = UIColor.systemGray5
        addSubview(button)
        addSubview(counterField)
        
        button.setTitle(data.name, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .center
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.font = button.titleLabel?.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        button.addTarget(self, action: #selector(updateCounter(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(recognizeTap(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(dragOutOfBounds(sender:)), for: .touchUpOutside)
        button.tag = data.tag
        
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
        
        updateControlState()
    }
    
    func onTimerStarted() {
        self.button.isEnabled = true
        self.button.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
    }
    
    func isFocused() -> Bool{
        if (self.scoutingActivity.dataTimer.getTimeStamp() - self.timeStamp <= 1.0 && self.scoutingActivity.dataTimer.getTimeStamp() - self.timeStamp >= -1.0){
            self.isBeingFocused = true
        } else {
            self.isBeingFocused = false
        }

        return self.isBeingFocused
    }
    
    override init (frame : CGRect){
        super.init(frame : frame)
        
    }
    
    func updateUI(){
        if (self.scoutingActivity.isStarted){
             self.button.isEnabled = true
         if (self.isFocused()){
             self.button.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
             self.button.setTitleColor(UIColor.systemGray5, for: .normal)
             counterField.textColor = UIColor.systemGray5
         } else {
             counterField.textColor = UIColor.black
             self.button.backgroundColor = UIColor.systemGray5
             self.button.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
         }
         
        } else {
         self.button.isEnabled = false
         self.button.setTitleColor(UIColor.systemGray, for: .normal)
         }
    }
    
    func updateControlState() {
        self.counterField.text = String(self.scoutingActivity.qrEntry.count(type: self.fieldData.tag))
    
        self.timeStamp = self.scoutingActivity.qrEntry.lastValue(type: self.button.tag)?.time ?? -2.0
        
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateCounter(sender : UIButton){
        self.scoutingActivity.matchEntry.isScouted = true
        let dataPoint = DataPoint(type_index: sender.tag, value: 1, time: self.scoutingActivity.dataTimer.getTimeStamp())
        
        self.scoutingActivity.qrEntry.addDataPoint(dp: dataPoint)
        
        self.scoutingActivity.playSoundOnAction()
        
        self.isHeldDown = false
        
        self.timeStamp = self.scoutingActivity.dataTimer.getTimeStamp()
        
        updateControlState()
    }
    
    @objc func recognizeTap(sender : UIButton){
        sender.darkenBackground()
    }
    
    @objc func dragOutOfBounds(sender : UIButton){
        sender.backgroundColor = UIColor.systemGray5
    }
}
