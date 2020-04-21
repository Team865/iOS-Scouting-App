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
    let containerView = UIView()
    var index = 0
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setUpScoutingScreen(){
        addSubview(containerView)
        configrueView()
    }
    
    func configrueView(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
    }
}
