//
//  SwitchField.swift
//  Scouting
//
//  Created by DUC LOC on 4/16/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class SwitchField : UIView {
    var switchButton = UIButton()
    var title : String?
    var value = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setUpSwitchField(){
        addSubview(switchButton)
        switchButton.setTitle(self.title, for: .normal)
        switchButton.titleLabel?.numberOfLines = 0
        switchButton.contentHorizontalAlignment = .center
        switchButton.titleLabel?.textAlignment = .center
        switchButton.titleLabel?.lineBreakMode = .byWordWrapping
        switchButton.tag = self.tag
        switchButton.addTarget(self, action: #selector(activateSwitch(sender:)), for: .touchUpInside)
        if (value == 0){
            switchButton.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
        backgroundColor = UIColor.systemGray5
        } else {
            switchButton.setTitleColor(UIColor.white, for: .normal)
            backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
        }

        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        switchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        switchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        switchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func activateSwitch(sender : UIButton){
        let scoutingActivity = ScoutingActivity()
        var dataPoint = DataPoint(type_index: 0, value: 0, time: 0)
               
        if(self.value == 0){
            sender.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
            sender.setTitleColor(UIColor.white, for: .normal)
            self.value = 1
        } else if (self.value == 1){
            sender.backgroundColor = UIColor.systemGray5
            sender.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
            self.value = 0
        }
     
        if let timeStamp = UserDefaults.standard.object(forKey: "timeStamp") as? Float{
            dataPoint = .init(type_index: sender.tag, value: self.value, time: timeStamp)
            scoutingActivity.encodeData(dataPoint : dataPoint)
        }
    }
}
