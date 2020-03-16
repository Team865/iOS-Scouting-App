//
//  settingsCells.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/15/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit
class SettingsCell : UITableViewCell{
    var hideSwitch : Bool?
    var cellTitle : String?
    var cellDescription : String?
    var cellImage : UIImage?
    
    func setCell (settings : Settings){
        self.hideSwitch = settings.hideSwitch
        self.cellTitle = settings.title
        self.cellDescription = settings.description
        self.cellImage = settings.image
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
    
    //Adjust dimensions so image will fit screen
    lazy var imageControl : UIImageView =  {
        var image = UIImageView(frame : CGRect(x : 4, y : 6, width : 60, height : 30))
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel(frame : CGRect(x : 116, y : 0, width : 300, height : 60))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.isHighlighted = true
        label.font = label.font.withSize(20)
        return label
    }()
    
    lazy var descriptionLabel : UILabel = {
        let label = UILabel(frame : CGRect(x : 116, y : 48, width : 300, height : 30))
        label.textAlignment = .left
        label.font = label.font.withSize(15)
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(switchControl)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleSwitchAction(sender: UISwitch) {
        if sender.isOn {
            print("Turned on")
        } else {
            print("Turned off")
        }
    }
}
