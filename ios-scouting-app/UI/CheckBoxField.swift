//
//  Checkbox.swift
//  Scouting
//
//  Created by DUC LOC on 3/29/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class CheckBoxField : UIView{
    var title : String?
    var value = 0
    var checkBox = UIButton()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("The check box is null")
    }
    
    func setUpCheckBox() {
        addSubview(label)
        addSubview(checkBox)
        backgroundColor = UIColor.systemGray5
        
        label.text = title
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
        
        checkBox.layer.borderColor = UIColor.black.cgColor
        checkBox.layer.borderWidth = 2
        checkBox.addTarget(self, action: #selector(activateCheckBox(sender:)), for: .touchUpInside)
        checkBox.tag = self.tag
        
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
        
    }
    
    @objc func activateCheckBox(sender : UIButton){
        let scoutingActivity = ScoutingActivity()
        var dataPoint = DataPoint(type_index: 0, value: 0, time: 0)
        if (self.value == 0){
            checkBox.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
            self.value = 1
        } else if (self.value == 1){
            checkBox.backgroundColor = UIColor.systemGray5
            self.value = 0
        }
        if let timeStamp = UserDefaults.standard.object(forKey: "timeStamp") as? Float{
            dataPoint = .init(type_index: sender.tag, value: self.value, time: timeStamp)
            scoutingActivity.encodeData(dataPoint : dataPoint)
        }
        
    }
}

