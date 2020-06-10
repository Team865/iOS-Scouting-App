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
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    func setUpToggleButton(tagOfToggle : Int, name : String){
        setTitle(name, for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.font = titleLabel?.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        tag = tagOfToggle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MultiToggleField : UIView, InputControl{
    var scoutingActivity = ScoutingActivity()
    var toggleButton = ToggleButton()
    var listOfToggleButtons = [ToggleButton]()
    var defaultValue = 0
    var fieldData = FieldData()
    let label = UILabel()
    let toggleButtons = UIStackView()
    
    var checkedPosition = -1
    
    func setUpView(data: FieldData) {
        self.fieldData = data
        
        backgroundColor = UIColor.systemGray5
        
        self.tag = data.tag
        
        addSubview(label)
        addSubview(toggleButtons)
        
        self.scoutingActivity = data.scoutingActivity
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15) .isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        label.font = label.font.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.015))
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = data.name
        
        toggleButtons.axis = .horizontal
        toggleButtons.distribution = .fillEqually
        toggleButtons.spacing = 0
        
        for i in 0..<self.fieldData.choice.count{
            toggleButton = ToggleButton()
            toggleButton.setUpToggleButton(tagOfToggle: i, name: self.fieldData.choice[i])
            toggleButton.addTarget(self, action: #selector(getSelectedToggleButton(sender:)), for: .touchUpInside)
            self.toggleButtons.addArrangedSubview(toggleButton)
            self.listOfToggleButtons.append(toggleButton)
        }
        
        toggleButtons.translatesAutoresizingMaskIntoConstraints = false
        toggleButtons.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toggleButtons.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        toggleButtons.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85).isActive = true
        toggleButtons.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        updateControlState()
    }
    
    func onTimerStarted() {
        //Toggle field does not do anything on timer started
    }
    
    func setCheckedPosition(){
        for i in 0..<listOfToggleButtons.count{
            if (i == self.checkedPosition){
                self.listOfToggleButtons[i].backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                self.listOfToggleButtons[i].setTitleColor(UIColor.white, for: .normal)
            } else {
                self.listOfToggleButtons[i].backgroundColor = UIColor.systemGray5
                self.listOfToggleButtons[i].setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
            }
        }
    }
    
    func updateControlState(){
        let newPosition = self.scoutingActivity.qrEntry.lastValue(type: self.tag)?.value ?? self.fieldData.default_choice
        
        if(checkedPosition != newPosition){
            checkedPosition = newPosition
            setCheckedPosition()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func getSelectedToggleButton(sender : ToggleButton){
        self.checkedPosition = sender.tag
        self.scoutingActivity.matchEntry.isScouted = true
        
        let dataPoint = DataPoint(type_index: self.tag, value: self.checkedPosition, time: self.scoutingActivity.dataTimer.getTimeStamp())
        
        self.scoutingActivity.qrEntry.addDataPoint(dp: dataPoint)
        
        self.scoutingActivity.playSoundOnAction()
        
        sender.pulsate()
        
        setCheckedPosition()
        
    }
}
