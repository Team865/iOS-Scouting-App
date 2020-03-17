//
//  settingsCells.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/15/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit
class SettingsCell : UITableViewCell{
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
    
    //Adjust dimensions so image will fit screen
    lazy var imageControl : UIImageView = {
        var image = UIImageView(frame : CGRect(x : 12, y : 0, width : 60, height : 50))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        return image
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel(frame : CGRect(x : 80, y : 10, width : 300, height : 20))
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.isHighlighted = true
        label.font = label.font.withSize(12)
        return label
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel(frame : CGRect(x : 80, y : 20, width : 200, height : 40))
        label.textAlignment = .left
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
        label.font = label.font.withSize(10)
        return label
    }()
    
   
    func setCell(settings : Settings){
        titleLabel.text = settings.title
        descriptionLabel.text = settings.description
        switchControl.isHidden = settings.hideSwitch ?? true
        imageControl.image = settings.image
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(switchControl)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(imageControl)
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
