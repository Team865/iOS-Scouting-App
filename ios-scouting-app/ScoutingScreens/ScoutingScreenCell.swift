//
//  ScoutingScreenCell.swift
//  Scouting
//
//  Created by DUC LOC on 4/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

var first = true

class ScoutingScreenCell : UICollectionViewCell {
    var reusing = false
    var index = 0
    var listOfItemsType : [[String]] = []
    var listOfItemsName : [[String]] = []
    var listOfToggleTitles : [[[String]]] = []
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        reusing = true
    }
    
    func formatTitleOfItem(string : String) -> String{
        let titleArr = string.components(separatedBy: "_")
        var title = ""
        
        for i in 0..<titleArr.count{
            title += titleArr[i].prefix(1).uppercased() + titleArr[i].lowercased().dropFirst() + " "
        }
        return title
    }
    
    func setUpScoutingScreen(){
        if(!reusing){
        let scoutingView = UIStackView()
        contentView.addSubview(scoutingView)
        contentView.backgroundColor = UIColor.white
        scoutingView.axis = .vertical
        scoutingView.distribution = .fillEqually
        scoutingView.spacing = 2.5
        scoutingView.frame = CGRect(x : 2.5, y : 0, width : contentView.frame.width - 5, height: contentView.frame.height)
            
        for i in 0..<self.listOfItemsType.count{
            let scoutingRow = UIStackView()
            scoutingRow.axis = .horizontal
            scoutingRow.distribution = .fillEqually
            scoutingRow.spacing = 2.5
            for k in 0..<self.listOfItemsType[i].count{
                let itemName = formatTitleOfItem(string: self.listOfItemsName[i][k])
                if (self.listOfItemsType[i][k] == "Button"){
                    let button = ButtonField()
                    scoutingRow.addArrangedSubview(button)
                    button.buttonTitle = itemName
                    button.setUpButtonField()
                }
                if (self.listOfItemsType[i][k] == "MultiToggle"){
                    let toggle = MultiToggleField()
                    scoutingRow.addArrangedSubview(toggle)
                    toggle.numberOfButtons = self.listOfToggleTitles[i][k].count
                    toggle.listOfToggleTitles = self.listOfToggleTitles[i][k]
                    toggle.title = itemName
                    toggle.setUpToggleField()
                }
                if(self.listOfItemsType[i][k] == "Switch"){
                    let switchField = SwitchField()
                    scoutingRow.addArrangedSubview(switchField)
                    switchField.title = itemName
                    switchField.value = 0
                    switchField.setUpSwitchField()
                }
                if(self.listOfItemsType[i][k] == "Checkbox"){
                    let checkBox = CheckBoxField()
                    scoutingRow.addArrangedSubview(checkBox)
                    checkBox.title = itemName
                    checkBox.value = 0
                    checkBox.setUpCheckBox()
                }
            }
            scoutingView.addArrangedSubview(scoutingRow)
            }
        }
    }
}
