//
//  SwitchField.swift
//  Scouting
//
//  Created by DUC LOC on 4/16/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
public class SwitchField : UIView, InputControl {
    var scoutingActivity = ScoutingActivity()
    var value = -1
    var isHeldDown = false
    var lite = false
    var fieldData = FieldData()
    var switchButton = UIButton()
    
    func setUpView(data: FieldData) {
        self.fieldData = data
        
        self.tag = data.tag
        
        addSubview(switchButton)
        switchButton.setTitle(data.name, for: .normal)
        switchButton.titleLabel?.numberOfLines = 0
        switchButton.contentHorizontalAlignment = .center
        switchButton.titleLabel?.textAlignment = .center
        switchButton.titleLabel?.lineBreakMode = .byWordWrapping
        switchButton.titleLabel?.font = switchButton.titleLabel?.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        switchButton.tag = data.tag
        
        self.lite = data.is_lite
        
        self.scoutingActivity = data.scoutingActivity
        switchButton.addTarget(self, action: #selector(activateSwitch(sender:)), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(onHold(sender:)), for: .touchDown)
        switchButton.addTarget(self, action: #selector(dragOutOfBounds(sender:)), for: .touchUpOutside)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        switchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        switchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        switchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        updateControlState()
    }
    
    func onTimerStarted() {
        if (!self.fieldData.is_lite){
            self.switchButton.isEnabled = true
            self.switchButton.setTitleColor(UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00), for: .normal)
        }
        
    }
    
    func setSwitchState(){
        if (self.scoutingActivity.isStarted || self.lite){
            self.switchButton.isEnabled = true
            if (self.value == 1){
                if (self.fieldData.is_lite){
                    self.switchButton.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                    self.switchButton.setTitleColor(UIColor.white, for: .normal)
                } else {
                    self.switchButton.backgroundColor = UIColor.red
                    self.switchButton.setTitleColor(UIColor.white, for: .normal)
                }
            } else if (self.value == 0){
                if (self.fieldData.is_lite){
                    self.switchButton.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for : .normal)
                } else {
                    self.switchButton.setTitleColor(UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00), for: .normal)
                }
                self.switchButton.backgroundColor = UIColor.systemGray5
            }
            
        } else {
            self.switchButton.backgroundColor = UIColor.systemGray5
            self.switchButton.setTitleColor(UIColor.systemGray, for: .normal)
        }
        
    }
    
    func updateControlState() {
        let newPosition = self.scoutingActivity.qrEntry.lastValue(type: self.tag)?.value ?? 0
        
        if (self.value != newPosition){
            self.value = newPosition
            setSwitchState()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func activateSwitch(sender : UIButton){
        if (self.value == 0){
            self.value = 1
        } else {
            self.value = 0
        }
        
        self.scoutingActivity.matchEntry.isScouted = true
        
        let dataPoint = DataPoint(type_index: self.tag, value: self.value, time: self.scoutingActivity.dataTimer.getTimeStamp())
        
        self.scoutingActivity.qrEntry.addDataPoint(dp: dataPoint)
        
        self.scoutingActivity.playSoundOnAction()
        
        self.isHeldDown = false
        
        setSwitchState()
    }
    
    @objc func onHold(sender : UIButton){
            self.switchButton.darkenBackground()
            
            if (self.value == 1){
                self.switchButton.backgroundColor = UIColor(red: 1.00, green: 0.49, blue: 0.24, alpha: 1.00)
                
                if (self.fieldData.is_lite){
                    self.switchButton.backgroundColor = UIColor.init(red: 0.36, green: 0.54, blue: 1.00, alpha: 1.00)

                }
            }
            
        }
    
    @objc func dragOutOfBounds(sender: UIButton){
        setSwitchState()
    }
}
