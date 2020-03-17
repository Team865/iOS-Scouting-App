//
//  EventCells.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/16/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit
class EventCells : UITableViewCell {
   
 private lazy var eventName : UILabel = {
     let label = UILabel(frame : CGRect(x : 10, y : 0, width : 370, height : 60))
     label.textAlignment = .left
     label.lineBreakMode = .byClipping
     label.numberOfLines = 0
     label.isHighlighted = true
     label.font = label.font.withSize(20)
     return label
 }()
    
  private lazy var eventInfo : UILabel = {
        let label = UILabel(frame : CGRect(x : 10, y : 55,  width : 400, height : 20))
        label.textAlignment = .left
    label.textColor = UIColor.blue
    label.font = label.font.withSize(17.5)
        return label
    }()
    
    func setEvent (event : Events){
        eventName.text = event.name
        eventInfo.text = event.info
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(eventName)
        addSubview(eventInfo)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
