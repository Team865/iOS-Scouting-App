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
    
    
    var scoutingActivity = ScoutingActivity()
    let counterField = UILabel()
    var button = UIButton()
    var counter = 0
    var fieldData = FieldData()
    
    func setUpView(data: FieldData) {
        self.fieldData = data
        self.scoutingActivity = data.scoutingActivity
        
        counterField.text = String(counter)
        counterField.font = counterField.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        backgroundColor = UIColor.systemGray5
        addSubview(button)
        addSubview(counterField)
        
        button.setTitle(data.name, for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .center
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.font = button.titleLabel?.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        button.addTarget(self, action: #selector(updateCounter(sender:)), for: .touchUpInside)
        button.tag = data.tag
        button.isEnabled = false
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
        
        updateControlState()
    }
    
    func onTimerStarted() {
        self.button.isEnabled = true
        self.button.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
    }
    
    override init (frame : CGRect){
        super.init(frame : frame)
        
    }
    
    func updateControlState() {
       if (self.scoutingActivity.isStarted){
            self.button.isEnabled = true
            self.button.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
        }
        
        self.counterField.text = String(self.scoutingActivity.qrEntry.count(type: self.fieldData.tag))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateCounter(sender : UIButton){
        self.scoutingActivity.matchEntry.isScouted = true
        let dataPoint = DataPoint(type_index: sender.tag, value: 1, time: self.scoutingActivity.dataTimer.getTimeStamp())
        
        self.scoutingActivity.qrEntry.addDataPoint(dp: dataPoint)
        
        updateControlState()
    }
}
