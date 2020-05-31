//
//  ScoutingScreenCell.swift
//  Scouting
//
//  Created by DUC LOC on 4/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class ScoutingScreenCell : UICollectionViewCell {
    var reusing = false
    var listOfFieldData : [[FieldData]] = []
    var listOfInputControl : [InputControl] = []
    var scoutingView = UIStackView()
    var scoutingActivity = ScoutingActivity()
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    var index : Int?{
        willSet{
            configureBlankView()
            configureScoutingStackView()
            setUpScoutingScreen()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureBlankView(){
        let blankView = UIView()
        contentView.addSubview(blankView)
        blankView.frame = CGRect(x : 0, y : 0, width : contentView.frame.width, height: contentView.frame.height)
        blankView.backgroundColor = UIColor.white
    }
    
    func configureScoutingStackView(){
        scoutingView = UIStackView()
        contentView.addSubview(scoutingView)
        contentView.backgroundColor = UIColor.white
        scoutingView.axis = .vertical
        scoutingView.distribution = .fillEqually
        scoutingView.spacing = 2.5
        scoutingView.frame = CGRect(x : 2.5, y : 0, width : contentView.frame.width - 5, height: contentView.frame.height)
    }
    
    func setUpScoutingScreen() {
        for i in 0..<self.listOfFieldData.count{
            let scoutingRow = UIStackView()
            scoutingRow.axis = .horizontal
            scoutingRow.distribution = .fillEqually
            scoutingRow.spacing = 2.5
            for j in 0..<self.listOfFieldData[i].count{
                var item : InputControl?
                switch self.listOfFieldData[i][j].type {
                case "Button":
                    item = ButtonField()
                    item?.setUpView(data: listOfFieldData[i][j])
                case "Switch":
                    item = SwitchField()
                    item?.setUpView(data: listOfFieldData[i][j])
                    
                case "MultiToggle":
                    item = MultiToggleField()
                    item?.setUpView(data: listOfFieldData[i][j])
                    
                case "Checkbox":
                    item = CheckBoxField()
                    item?.setUpView(data: listOfFieldData[i][j])
                    
                default:
                    item = UnknownField()
                }
                
                listOfInputControl.append(item!)
                scoutingRow.addArrangedSubview(item!)
            }
            scoutingView.addArrangedSubview(scoutingRow)
        }
        
    }
    
}



