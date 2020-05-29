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
    func setUpView(data: FieldData) {
        self.fieldData = data
        
        backgroundColor = UIColor.systemGray5
        
        self.tag = data.tag
        
        addSubview(label)
        addSubview(toggleButtons)
        
        self.scoutingActivity = data.scoutingActivity
        
        self.defaultValue = self.scoutingActivity.listOfUIContent[data.name] ?? (data.default_choice)
        
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
        
        let choice = self.fieldData.choice.count
        
        for i in 0..<choice{
            toggleButton = ToggleButton()
            toggleButton.setTitle(self.fieldData.choice[i], for: .normal)
            toggleButton.titleLabel?.textAlignment = .center
            toggleButton.addTarget(self, action: #selector(getSelectedToggleButton(sender:)), for: .touchUpInside)
            toggleButton.tag = i
            if (i == self.defaultValue){
                toggleButton.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                toggleButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                toggleButton.backgroundColor = UIColor.systemGray5
                toggleButton.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
            }
            
                self.listOfToggleButtons.append(toggleButton)
                self.toggleButtons.addArrangedSubview(toggleButton)
            
        }
    }
    
    func onItemClicked(){
        
    }
    
    
    func onTimerStarted() {
        //Toggle field does not do anything on timer started
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func getSelectedToggleButton(sender : ToggleButton){
        self.defaultValue = sender.tag
        
        self.scoutingActivity.listOfUIContent[self.fieldData.name] = self.defaultValue
        
            for i in 0..<self.listOfToggleButtons.count{
                if (i == self.defaultValue){
                    self.listOfToggleButtons[i].backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                    self.listOfToggleButtons[i].setTitleColor(UIColor.white, for: .normal)
                } else {
                    self.listOfToggleButtons[i].backgroundColor = UIColor.systemGray5
                    self.listOfToggleButtons[i].setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
                }
                
                self.scoutingActivity.scoutingView.reloadData()
            }
        

        
        let dataPoint = DataPoint(type_index: self.tag, value: sender.tag, time: self.scoutingActivity.dataTimer.getTimeStamp())
        
        self.scoutingActivity.qrEntry.addDataPoint(dp: dataPoint)
        
    }
    
}
