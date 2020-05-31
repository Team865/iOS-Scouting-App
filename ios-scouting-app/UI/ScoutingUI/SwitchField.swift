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
    var switchButton = UIButton()
    
    func setUpView(data: FieldData) {
        self.fieldData = data
        
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
        
        self.value = self.scoutingActivity.listOfUIContent[data.name] ?? 0
        
        switchButton.setTitleColor(UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00), for: .normal)
        backgroundColor = UIColor.systemGray5
        
        if (data.is_lite){
            if (self.value == 1){
                self.switchButton.backgroundColor = UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00)
                self.switchButton.setTitleColor(UIColor.white, for: .normal)
            } else if (self.value == 0){
                self.switchButton.setTitleColor(UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00), for: .normal)
                self.switchButton.backgroundColor = UIColor.systemGray5
            }
            switchButton.isEnabled = true
        } else {
            switchButton.isEnabled = false
        }
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        switchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        switchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        switchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
    }
    
    func onTimerStarted() {
        self.switchButton.isEnabled = true
        if (self.value == 0){
            self.switchButton.setTitleColor(UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00), for: .normal)
            self.switchButton.backgroundColor = UIColor.systemGray5
        } else if (self.value == 1){
            self.switchButton.backgroundColor = UIColor.red
            self.switchButton.setTitleColor(UIColor.white, for: .normal)
            
            if (self.lite){
                self.switchButton.backgroundColor = UIColor(red: 0.12, green: 0.67, blue: 0.19, alpha: 1.00)
                self.switchButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func activateSwitch(sender : UIButton){
        if(self.value == 0){
            //Turn on
            
            self.value = 1
        } else if (self.value == 1){
            //Turn off
            
            self.value = 0
        }
        
        self.scoutingActivity.listOfUIContent[self.fieldData.name] = self.value
        self.scoutingActivity.matchEntry.isScouted = true
        self.scoutingActivity.scoutingView.reloadData()
        
        let dataPoint = DataPoint(type_index: self.tag, value: self.value, time: self.scoutingActivity.dataTimer.getTimeStamp())
        
        self.scoutingActivity.qrEntry.addDataPoint(dp: dataPoint)
    }
}
