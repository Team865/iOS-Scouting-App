//
//  Checkbox.swift
//  Scouting
//
//  Created by DUC LOC on 3/29/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class CheckBox : UIStackView{
    var title : String?
    var checkBox = UIButton()
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("The check box is null")
    }
    
    func setUpCheckBox() {
        distribution = .fillEqually
        axis = .vertical
        spacing = 0
       
        print(self.bounds.height)
        
        for i in 0..<3{
           if(i == 1){
            let checkBoxView = UIStackView()
                    
            checkBoxView.distribution = .fillEqually
            checkBoxView.axis = .vertical
            checkBoxView.spacing = 0
            
            for k in 0..<3{
                let views = UIView()
                views.backgroundColor = UIColor.systemGray5
                if (k == 1){
                    let label = UILabel()
                    label.frame = CGRect(x : Double(UIScreen.main.bounds.width) * 0.05 + Double(UIScreen.main.bounds.height) * 0.85 * 0.0235 + 5, y : 0, width : Double(UIScreen.main.bounds.height) * 0.85 * 0.0235 * 10, height : Double(UIScreen.main.bounds.height) * 0.85 * 0.0235)
                    label.text = title
                    label.textAlignment = .left
                    label.textColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                    views.addSubview(checkBox)
                    views.addSubview(label)
                }
                checkBoxView.addArrangedSubview(views)
            }
            
            addArrangedSubview(checkBoxView)
                    
                } else {
                    let smallView = UIView()
                    smallView.backgroundColor = UIColor.systemGray5
                    addArrangedSubview(smallView)
                }
            }
            
        
        }
    }

