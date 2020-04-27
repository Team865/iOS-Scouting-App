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
    var value : Int?
    var checkBox = UIButton()
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("The check box is null")
    }
    
    func setUpCheckBox() {
        backgroundColor = UIColor.systemGray5
        
        label.text = title
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        backgroundColor = UIColor.systemGray5
        
        checkBox.layer.borderColor = UIColor.black.cgColor
        checkBox.layer.borderWidth = 2
        
        addSubview(label)
        addSubview(checkBox)
        
    }
}

