//
//  EventCells.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/16/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit
class EventCells : UITableViewCell {
   
    let cellHeight = UIScreen.main.bounds.height
    let cellWidth = UIScreen.main.bounds.width
    
    let multiplier = 0.1
    
 private lazy var eventName : UILabel = {
    let label = UILabel(frame : CGRect(x: Double(self.cellWidth * 0.05), y: Double(self.cellHeight * 0.05) * self.multiplier, width: Double(self.cellWidth * 0.9), height: Double(self.cellHeight * 0.6) * self.multiplier))
     label.textAlignment = .left
     label.lineBreakMode = .byClipping
     label.numberOfLines = 0
     label.font = label.font.withSize(15)
     return label
 }()
    
  private lazy var eventInfo : UILabel = {
    let label = UILabel(frame : CGRect(x: Double(self.cellWidth * 0.05), y: Double(self.cellHeight * 0.50) * self.multiplier, width: Double(self.cellWidth * 0.9), height: Double(self.cellHeight * 0.4) * self.multiplier))
    label.textAlignment = .left
    label.textColor = UIColor.systemBlue
    label.font = label.font.withSize(15)
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
