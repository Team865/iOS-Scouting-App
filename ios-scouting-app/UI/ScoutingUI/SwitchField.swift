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
    var value = 0
    var lite = false
    var fieldData = FieldData()
    
    func setUpView(data: FieldData) {
        self.fieldData = data
        
        addSubview(switchButton)
        switchButton.setTitle(data.name, for: .normal)
        switchButton.titleLabel?.numberOfLines = 0
        switchButton.contentHorizontalAlignment = .center
        switchButton.titleLabel?.textAlignment = .center
        switchButton.titleLabel?.lineBreakMode = .byWordWrapping
        switchButton.tag = data.tag
        self.lite = data.is_lite
        
        self.scoutingActivity = data.scoutingActivity
        switchButton.addTarget(self, action: #selector(activateSwitch(sender:)), for: .touchUpInside)
        
        self.value = self.scoutingActivity.listOfUIContent[data.name] ?? 0
        
        if (data.is_lite){
            switchButton.setTitleColor(UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00), for: .normal)
            backgroundColor = UIColor.systemGray5
            switchButton.isEnabled = true
        } else {
            switchButton.setTitleColor(UIColor.white, for: .normal)
            backgroundColor = UIColor.systemGray5
            switchButton.isEnabled = false
        }
        
        if (self.value == 0){
            switchButton.setTitleColor(UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00), for: .normal)
            backgroundColor = UIColor.systemGray5
        } else if (self.value == 1){
            self.switchButton.backgroundColor = UIColor.red
            self.switchButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        switchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        switchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        switchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
    }
 
    func onTimerStarted() {
        self.switchButton.isEnabled = true
        self.switchButton.setTitleColor(UIColor(red: 0.35, green: 0.76, blue: 0.00, alpha: 1.00), for: .normal)
    }
    
    var switchButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func activateSwitch(sender : UIButton){
       
        if(self.value == 0){
            //Turn on
            self.switchButton.backgroundColor = UIColor.red
            self.switchButton.setTitleColor(UIColor.white, for: .normal)
            
            if (self.lite){
                self.switchButton.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                self.switchButton.setTitleColor(UIColor.white, for: .normal)
            }
            
            self.value = 1
        } else if (self.value == 1){
            //Turn off
            self.switchButton.backgroundColor = UIColor.systemGray5
            self.switchButton.setTitleColor(UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00), for: .normal)
            self.value = 0
        }
        
        self.scoutingActivity.listOfUIContent[self.fieldData.name] = self.value
        self.scoutingActivity.matchEntry.isScouted = true
        self.scoutingActivity.scoutingView.reloadData()
        
        let dataPoint = DataPoint(type_index: self.tag, value: self.value, time: self.scoutingActivity.dataTimer.getTimeStamp())
        
        self.scoutingActivity.qrEntry.addDataPoint(dp: dataPoint)
    }
}
