//
//  settingsCells.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/15/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit
class SettingsCell : UITableViewCell{
    let cellHeight = UIScreen.main.bounds.height * 0.15
    let cellWidth = UIScreen.main.bounds.width
    let coreData = CoreData()
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = coreData.isPlayingSounds()
        switchControl.onTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl
    }()
    
    lazy var imageControl : UIImageView = {
        var image = UIImageView(frame : CGRect(x : Double(self.cellWidth * 0.05), y : Double(self.cellHeight * 0.05), width : Double(self.cellWidth * 0.1), height : Double(self.cellHeight * 0.9)))
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel(frame : CGRect(x : Double(self.cellWidth * 0.2), y : Double(self.cellHeight * 0.1), width : Double(self.cellWidth * 0.6), height : Double(self.cellHeight * 0.45)))
        label.textAlignment = .left
        label.isHighlighted = true
        return label
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel(frame : CGRect(x : Double(self.cellWidth * 0.2), y : Double(self.cellHeight * 0.4), width : Double(self.cellWidth * 0.6), height : Double(self.cellHeight * 0.5)))
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.lightGray
        return label
    }()
    
   
    func setCell(settings : Settings){
        titleLabel.text = settings.title
        descriptionLabel.text = settings.description
        switchControl.isHidden = settings.hideSwitch ?? true
        imageControl.image = settings.image
        
        titleLabel.sizeToFit()
        titleLabel.baselineAdjustment = .alignCenters
        
        descriptionLabel.sizeToFit()
        descriptionLabel.baselineAdjustment = .alignCenters
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
            self.coreData.saveIsPlayingSoundsOption(state : true)
        } else {
            self.coreData.saveIsPlayingSoundsOption(state : false)
        }
    }
}
