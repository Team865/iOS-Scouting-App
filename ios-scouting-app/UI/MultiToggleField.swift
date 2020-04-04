//
//  MultiToggle.swift
//  Scouting
//
//  Created by DUC LOC on 4/4/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class MultiToggleField : UIView{
    let viewHeight = Double(UIScreen.main.bounds.height) * 0.85
    var title : String?
    var numberOfRows : Int?
    var listOfToggles : [ToggleButton] = []
    override init(frame: CGRect) {
        super.init(frame : frame)
        setUpToggleField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpToggleField(){
        backgroundColor = UIColor.systemGray5
        let label = UILabel()

        label.frame = CGRect(x : 0.0, y : self.viewHeight / Double(self.numberOfRows ?? 1) * 0.01, width: Double(UIScreen.main.bounds.width), height: self.viewHeight / Double(self.numberOfRows ?? 1) * 0.22)
        label.text = self.title
        label.textAlignment = .center
        addSubview(label)
        
        let toggleView = UIStackView()
        toggleView.frame = CGRect(x : 0, y : viewHeight / Double(self.numberOfRows ?? 1) * 0.25, width : Double(UIScreen.main.bounds.width) - 14, height : viewHeight / Double(self.numberOfRows ?? 1) * 0.56)
        
        toggleView.axis = .horizontal
        toggleView.spacing = 0
        toggleView.distribution = .fillEqually
        
        for i in 0..<self.listOfToggles.count{
            toggleView.addArrangedSubview(listOfToggles[i])
        }
        
        addSubview(toggleView)
    }
}
