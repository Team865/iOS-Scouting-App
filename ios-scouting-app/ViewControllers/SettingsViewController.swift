//
//  SettingsViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/15/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    var tableView : UITableView!
    var settingsActionSection = [Settings]()
    var settingsInfoSection = [Settings]()
    let idsAndKeys = IDsAndKeys()
    var sectionTitle : [String] = ["Configurations", "About"]
    var isUsingVibration = true
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationItem.title = "Settings"
        settingsActionSection = createActionSettingsSection()
        settingsInfoSection = createInfoSettingsSection()
    }
    
    
    func createActionSettingsSection() -> [Settings]{
        var tempSection: [Settings] = []
        
        var selectedEvent = "None"
        
        if let currentEvent = UserDefaults.standard.object(forKey: self.idsAndKeys.currentEventName) as? String{
            selectedEvent = currentEvent
        }
        
        tempSection.append(Settings(image : UIImage(named: "event")!,title: "Select FRC Event", description: selectedEvent, hideSwitch: true))
        tempSection.append(Settings(image : UIImage(named: "tools")!, title: "Allow sound", description : "Allow sounds to play as a feedback when a button is clicked", hideSwitch : false))
        
        return tempSection
    }
    
    func createInfoSettingsSection() -> [Settings]{
        var tempSection: [Settings] = []
        
        tempSection.append(Settings(image : UIImage(named: "warp7")!, title: "Team 865 iOS Scouting App", description : "Version : 2020.2.1", hideSwitch : true))
        tempSection.append(Settings(image : UIImage(named : "github")!, title: "Repository on GitHub", description: "Including source code and instruction on how to use the app", hideSwitch: true))
        tempSection.append(Settings(image : UIImage(named : "badge")!, title : "Open source Licenses", description : "MIT License", hideSwitch : true))
        
        return tempSection
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UIScreen.main.bounds.height * 0.15
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: self.idsAndKeys.settingsCell)
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                let eventSelection = UIStoryboard(name : "Main", bundle: nil)
                guard let eventSelectionVC = eventSelection.instantiateViewController(withIdentifier: self.idsAndKeys.eventSelectionController) as?
                    EventSelectionController else { return }
                
                self.navigationController?.pushViewController(eventSelectionVC, animated: true)
            }
        } else if (indexPath.section == 1){
            if (indexPath.row == 1){
                guard let url = URL(string: "https://github.com/Team865/iOS-Scouting-App") else { return }
                UIApplication.shared.open(url)
            }
            if (indexPath.row == 2){
                guard let url = URL(string: "https://github.com/Team865/iOS-Scouting-App/blob/master/LICENSE") else { return }
                UIApplication.shared.open(url)
            }
        }
    }
    
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : return 2
        case 1 : return 3
        default : return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = UIColor.systemGray6
        
        let title = UILabel()
        title.font = title.font.withSize(15)
        title.textColor = UIColor.black
        title.text = self.sectionTitle[section]
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.idsAndKeys.settingsCell, for : indexPath) as! SettingsCell
        switch indexPath.section {
        case 0 :
            let section1 = settingsActionSection[indexPath.row]
            cell.setCell(settings: section1)
            
            if(indexPath.row != 1){
                cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            }
        case 1 :
            let section2 = settingsInfoSection[indexPath.row]
            cell.setCell(settings: section2)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        default: cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    
    
}
