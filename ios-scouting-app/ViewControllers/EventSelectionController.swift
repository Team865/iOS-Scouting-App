//
//  EventSelectionController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/16/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class EventSelectionController : UIViewController, UITextFieldDelegate{
    
    var selectedEvent : Events!
    
    var eventTable : UITableView!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let viewDimension = 40
    
    var key = tbaKey()
    var idsAndKeys = IDsAndKeys()
    
    var jsonListOfEvents = [jsonEvents]()
    var listOfEvents : [Events] = []
    
    var yearText = UITextField()
    var teamText = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTeamTextField()
        configureYearTextField()
        configureTableView()
        setUpNavigationBar()
        
        //Load data from cache
        loadEventListFromCache()
    }
    
    //UI Configurations
    private func configureTableView() {
        eventTable = UITableView()
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.rowHeight = UIScreen.main.bounds.height * 0.1
        
        eventTable.register(EventCells.self, forCellReuseIdentifier: self.idsAndKeys.eventCells)
        view.addSubview(eventTable)
        
        eventTable.translatesAutoresizingMaskIntoConstraints = false
        eventTable.topAnchor.constraint(equalTo: yearText.bottomAnchor).isActive = true
        eventTable.leadingAnchor.constraint(equalTo : self.view.leadingAnchor).isActive = true
        eventTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        eventTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        eventTable.tableFooterView = UIView()
    }
    
    private func configureYearTextField(){
        yearText.delegate = self
        yearText.leftViewMode = .always
        yearText.placeholder = "Year"
        yearText.textAlignment = .center
        
        let calendar = UIImageView()
        calendar.image = UIImage(named: "calendar")
        
        yearText.leftView = calendar
        
        view.addSubview(yearText)
        
        
        yearText.translatesAutoresizingMaskIntoConstraints = false
        yearText.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        yearText.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: UIScreen.main.bounds.width * 0.05).isActive = true
        yearText.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -5).isActive = true
        yearText.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.black.cgColor
        bottomLine.frame = CGRect(x : 0, y : UIScreen.main.bounds.height * 0.045, width : UIScreen.main.bounds.width * 0.45 - 10, height : 1)
        yearText.borderStyle = .none
        yearText.layer.addSublayer(bottomLine)
        
    }
    
    private func configureTeamTextField(){
        teamText.delegate = self
        
        teamText.placeholder = "Team (e.g 865)"
        teamText.textAlignment = .center
        
        let teams = UIImageView()
        teams.image = UIImage(named : "team")
        
        teamText.leftViewMode = .always
        teamText.leftView = teams
        
        view.addSubview(teamText)
        
        teamText.translatesAutoresizingMaskIntoConstraints = false
        teamText.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        teamText.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 5).isActive = true
        teamText.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        teamText.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        let bottomLine2 = CALayer()
        bottomLine2.backgroundColor = UIColor.black.cgColor
        bottomLine2.frame = CGRect(x : 0, y : UIScreen.main.bounds.height * 0.045, width : UIScreen.main.bounds.width * 0.45, height : 1)
        teamText.borderStyle = .none
        teamText.layer.addSublayer(bottomLine2)
    }
    
    private func loadEventListFromCache(){
        if let eventKeys = UserDefaults.standard.object(forKey: self.idsAndKeys.eventKeys) as? [String],
            let eventInfo = UserDefaults.standard.object(forKey: self.idsAndKeys.eventInfos) as? [String],
            let eventName = UserDefaults.standard.object(forKey: self.idsAndKeys.eventNames) as? [String]{
            self.listOfEvents = self.createEventListFromCache(name : eventName, info : eventInfo, keys : eventKeys)
            self.eventTable.reloadData()
        }
    }
    
    private func createEventListFromCache(name : [String], info : [String], keys : [String]) -> [Events]{
        var tempEvent : [Events] = []
        for i in 0..<info.count{
            let event = Events(name: name[i], info: info[i], key: keys[i])
            tempEvent.append(event)
        }
        
        return tempEvent
    }
    
    //Create list view when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        yearText.resignFirstResponder()
        teamText.resignFirstResponder()
        
        self.listOfEvents.removeAll()
        
        getJSONEvents {
            self.listOfEvents = self.createEventCells()
            self.eventTable.reloadData()
        }
        
        return true
    }
    
    private func createEventCells() -> [Events]{
        var tempCell : [Events] = []
        
        var listOfInfo : [String] = []
        var listOfKeys : [String] = []
        var listOfNames : [String] = []
        
        for i in 0..<self.jsonListOfEvents.count{
            if(jsonListOfEvents[i].year == Int(self.yearText.text!) ?? 0){
                let info = jsonListOfEvents[i].start_date + " in " + jsonListOfEvents[i].city + ", " + jsonListOfEvents[i].state_prov + ", " + jsonListOfEvents[i].country
                
                let event = Events(name: jsonListOfEvents[i].name, info : info, key : self.yearText.text! + jsonListOfEvents[i].event_code)
                tempCell.append(event)
                
                listOfKeys.append(self.yearText.text! + jsonListOfEvents[i].event_code)
                listOfNames.append(self.jsonListOfEvents[i].name)
                listOfInfo.append(info)
            }
        }
        UserDefaults.standard.set(self.yearText.text!, forKey: self.idsAndKeys.year)
        UserDefaults.standard.set(listOfKeys, forKey: self.idsAndKeys.eventKeys)
        UserDefaults.standard.set(listOfNames, forKey: self.idsAndKeys.eventNames)
        UserDefaults.standard.set(listOfInfo, forKey: self.idsAndKeys.eventInfos)
        
        return tempCell
    }
    
    private func setUpNavigationBar(){
        navigationItem.title = "Select FRC Event"
    }
    
    private func getJSONEvents(completed : @escaping () -> ()){
        let url = URL(string: "https://www.thebluealliance.com/api/v3/team/frc" + self.teamText.text! + "/events")!
        UserDefaults.standard.set(self.teamText.text!, forKey: "teamNumber")
        var request = URLRequest(url: url)
        request.setValue(self.key.key, forHTTPHeaderField: "X-TBA-Auth-Key")
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                self.jsonListOfEvents = try decoder.decode([jsonEvents].self, from: data)
                
                DispatchQueue.main.async {
                    completed()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.selectedEvent = self.selectedEvent
    }
}

extension EventSelectionController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = self.listOfEvents[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.idsAndKeys.eventCells, for : indexPath) as! EventCells
        cell.setEvent(event: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Warning", message: "You will delete all data of current event, are you sure ?", preferredStyle: .alert)
        
        let getName = UIAlertAction(title: "OK", style: .default){
            alert in
            
            self.selectedEvent = self.listOfEvents[indexPath.row]
            UserDefaults.standard.set(self.selectedEvent.name, forKey: self.idsAndKeys.currentEvent)
            self.performSegue(withIdentifier: "passEventKey", sender: self)
        }
        
        let cancel = UIAlertAction(title : "Cancel", style : .cancel, handler : nil)
        
        alert.addAction(getName)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}


