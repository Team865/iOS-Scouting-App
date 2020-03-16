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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationItem.title = "Settings"
        settingsActionSection = createActionSettingsSection()
        settingsInfoSection = createInfoSettingsSection()
        
    }
    
    
    func createActionSettingsSection() -> [Settings]{
        var tempSection: [Settings] = []
        
        tempSection.append(Settings(image: UIImage(named : "white")!, title: "Select FRC Event", description: "Current Event", hideSwitch: true))
        tempSection.append(Settings(image: UIImage(named : "white")!, title: "Use Vibration", description : "Vibrate when the app successfully complete an action",
            hideSwitch : false))
        
        return tempSection
    }
    
    func createInfoSettingsSection() -> [Settings]{
        var tempSection: [Settings] = []

        tempSection.append(Settings(image: UIImage(named : "warp7")!, title: "Team 865 iOS Scouting App", description : "Version : 2020.1.0 debug", hideSwitch : true))
        tempSection.append(Settings(image: UIImage(named : "white")!, title: "Repository on GitHub", description: "Including sources and new releases", hideSwitch: true))
        tempSection.append(Settings(image : UIImage(named: "white")!, title : "Open source Licenses", description : "", hideSwitch : true))
        
        return tempSection
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
    }


    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if(indexPath.row == 0){
               let eventSelection = UIStoryboard(name : "Main", bundle: nil)
               
               guard let eventSelectionVC = eventSelection.instantiateViewController(withIdentifier: "EventSelectionController") as?
                   EventSelectionController else { return }
               
               self.navigationController?.pushViewController(eventSelectionVC, animated: true)
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for : indexPath) as! SettingsCell
        switch indexPath.section {
        case 0 :
            let section1 = settingsActionSection[indexPath.row]
            cell.setCell(settings: section1)
        case 1 :
            let section2 = settingsInfoSection[indexPath.row]
            cell.setCell(settings: section2)
        default: cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    
  
}
