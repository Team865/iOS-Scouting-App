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
    var key = tbaKey()
    var listOfEvents = [event]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        settingsActionSection = createActionSettingsSection()
        settingsInfoSection = createInfoSettingsSection()
        
        getJSONEvents {
            for i in 0..<self.listOfEvents.count{
                print(self.listOfEvents[i].key)
                print(self.listOfEvents[i].year)
            }
        }
    }
    
    func createActionSettingsSection() -> [Settings]{
        var tempSection: [Settings] = []
        
        tempSection.append(Settings(image: UIImage(named : "whiteboi")!, title: "Select FRC Event", description: "Current Event", hideSwitch: true))
        tempSection.append(Settings(image: UIImage(named : "whiteboi")!, title: "Use Vibration", description : "Toggle Vibration",
            hideSwitch : false))
        
        return tempSection
    }
    
    func createInfoSettingsSection() -> [Settings]{
        var tempSection: [Settings] = []

        tempSection.append(Settings(image: UIImage(named : "whiteboi")!, title: "Team 865 iOS Scouting App", description : "", hideSwitch : true))
        tempSection.append(Settings(image: UIImage(named : "whiteboi")!, title: "Repository on GitHub", description: "Including sources and new releases boi this text is so long that it will not fit", hideSwitch: true))
        tempSection.append(Settings(image : UIImage(named: "whiteboi")!, title : "Open source Licenses", description : "", hideSwitch : true))
        
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
    
    private func getJSONEvents(completed : @escaping () -> ()){
        let url = URL(string: "https://www.thebluealliance.com/api/v3/team/frc865/events")!
        var request = URLRequest(url: url)
        request.setValue(self.key.key, forHTTPHeaderField: "X-TBA-Auth-Key")
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                self.listOfEvents = try decoder.decode([event].self, from: data)
                
                DispatchQueue.main.async {
                    completed()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
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
            cell.titleLabel.text = section1.title
            cell.descriptionLabel.text = section1.description
            cell.switchControl.isHidden = section1.hideSwitch ?? true
            cell.imageControl.image = section1.image
        case 1 :
            let section2 = settingsInfoSection[indexPath.row]
            cell.titleLabel.text = section2.title
            cell.descriptionLabel.text = section2.description
            cell.switchControl.isHidden = section2.hideSwitch ?? true
            cell.imageControl.image = section2.image
        default: cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    
  
}
