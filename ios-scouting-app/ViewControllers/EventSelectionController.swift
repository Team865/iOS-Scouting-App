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
    
    var eventTable : UITableView!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let viewDimension = 40
    
    var key = tbaKey()
    
    var jsonListOfEvents = [jsonEvents]()
    var listOfEvents : [Events] = []
    var listOfKeys : [String] = []
    var listOfNames : [String] = []
    var selectedEventKey = ""
    var selectedName = ""
    
    var yearText : UITextField!
    var teamText : UITextField!
    
    let viewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInputFields()
        configureTableView()
        setUpNavigationBar()
        
        //Load data from cache
        if let eventKeys = UserDefaults.standard.object(forKey: "EventKeys") as? [String]{
            self.listOfKeys = eventKeys
        }
        
        if let eventInfo = UserDefaults.standard.object(forKey: "EventInfos") as? [String], let eventName = UserDefaults.standard.object(forKey: "EventNames") as? [String]{
            self.listOfEvents = self.loadEventListFromCore(name : eventName, info : eventInfo)
            self.listOfNames = eventName
            self.eventTable.reloadData()
        }
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        yearText.resignFirstResponder()
        teamText.resignFirstResponder()
        
        self.selectedName = ""
        self.selectedEventKey = ""
        
        viewController.currentEvent = ""
        viewController.eventKey = ""
        
        self.listOfNames.removeAll()
        self.listOfKeys.removeAll()
        
        getJSONEvents {
            self.listOfEvents = self.createEventCells()
            self.eventTable.reloadData()
        }
        return true
    }
    //UI Configurations
    private func configureTableView() {
        eventTable = UITableView()
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.rowHeight = UIScreen.main.bounds.height * 0.1
        
        eventTable.register(EventCells.self, forCellReuseIdentifier: "EventCells")
        view.addSubview(eventTable)
        
        eventTable.translatesAutoresizingMaskIntoConstraints = false
        eventTable.topAnchor.constraint(equalTo: yearText.bottomAnchor).isActive = true
        eventTable.leadingAnchor.constraint(equalTo : self.view.leadingAnchor).isActive = true
        eventTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        eventTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        eventTable.tableFooterView = UIView()
    }
    
    private func configureInputFields(){
        yearText = UITextField()
        teamText = UITextField()
        
        yearText.delegate = self
        teamText.delegate = self
        
        yearText.placeholder = "Year"
        yearText.textAlignment = .center
        
        teamText.placeholder = "Team (e.g 865)"
        teamText.textAlignment = .center
        
        let calendar = UIImageView()
        calendar.image = UIImage(named: "calendar")
        
        let teams = UIImageView()
        teams.image = UIImage(named : "team")
        
        yearText.leftViewMode = .always
        yearText.leftView = calendar
        
        teamText.leftViewMode = .always
        teamText.leftView = teams
        
        view.addSubview(yearText)
        view.addSubview(teamText)
        
        yearText.translatesAutoresizingMaskIntoConstraints = false
        yearText.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        yearText.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: UIScreen.main.bounds.width * 0.05).isActive = true
        yearText.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -5).isActive = true
        yearText.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        teamText.translatesAutoresizingMaskIntoConstraints = false
        teamText.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        teamText.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 5).isActive = true
        teamText.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        teamText.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
    
        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.black.cgColor
        bottomLine.frame = CGRect(x : 0, y : UIScreen.main.bounds.height * 0.045, width : UIScreen.main.bounds.width * 0.45 - 10, height : 1)
        yearText.borderStyle = .none
        yearText.layer.addSublayer(bottomLine)
        
        let bottomLine2 = CALayer()
        bottomLine2.backgroundColor = UIColor.black.cgColor
        bottomLine2.frame = CGRect(x : 0, y : UIScreen.main.bounds.height * 0.045, width : UIScreen.main.bounds.width * 0.45, height : 1)
        teamText.borderStyle = .none
        teamText.layer.addSublayer(bottomLine2)

    }
    
    private func loadEventListFromCore(name : [String], info : [String]) -> [Events]{
        var tempEvent : [Events] = []
        for i in 0..<info.count{
            tempEvent.append(Events.init(name: name[i], info: info[i]))
        }
        
        return tempEvent
    }
    
    private func createEventCells() -> [Events]{
        var tempCell : [Events] = []
        
        var listOfInfo : [String] = []
        
                for i in 0..<self.jsonListOfEvents.count{
                    if(jsonListOfEvents[i].year == Int(self.yearText.text!) ?? 0){
                        let event = Events.init(name: jsonListOfEvents[i].name, info : jsonListOfEvents[i].start_date + " in " + jsonListOfEvents[i].city + ", " + jsonListOfEvents[i].state_prov + ", " + jsonListOfEvents[i].country)
                        tempCell.append(event)
                        listOfInfo.append(jsonListOfEvents[i].start_date + " in " + jsonListOfEvents[i].city + ", " + jsonListOfEvents[i].state_prov + ", " + jsonListOfEvents[i].country)
                        self.listOfKeys.append(self.yearText.text! + jsonListOfEvents[i].event_code)
                        self.listOfNames.append(self.jsonListOfEvents[i].name)
                    }
                }
        UserDefaults.standard.set(self.yearText.text!, forKey: "year")
        UserDefaults.standard.set(self.listOfKeys, forKey: "EventKeys")
        
        UserDefaults.standard.set(self.listOfNames, forKey: "EventNames")
        UserDefaults.standard.set(listOfInfo, forKey: "EventInfos")
        
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
        vc.eventKey = self.selectedEventKey
        vc.currentEvent = self.selectedName
    }
}

extension EventSelectionController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = self.listOfEvents[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCells", for : indexPath) as! EventCells
        cell.setEvent(event: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            let alert = UIAlertController(title: "Warning", message: "You will delete all data of current event, are you sure ?", preferredStyle: .alert)
                
                let getName = UIAlertAction(title: "OK", style: .default){
                    alert in
                    self.selectedEventKey = self.listOfKeys[indexPath.row]
                    self.selectedName = self.listOfNames[indexPath.row]
                    self.performSegue(withIdentifier: "passEventKey", sender: self)
                    
                }
                
                let cancel = UIAlertAction(title : "Cancel", style : .cancel, handler : nil)
                
                alert.addAction(getName)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
        }


