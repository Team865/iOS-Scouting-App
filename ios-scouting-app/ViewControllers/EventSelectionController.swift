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
    var tbaParser = TBAParser()
    var coreData = CoreData()
    var selectedEvent : Events!
    
    var eventTable : UITableView!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let viewDimension = 40
    
    var key = TBAKey()
    var idsAndKeys = IDsAndKeys()
    
    var jsonListOfEvents = [jsonEvents]()
    var listOfEvents : [Events] = []
    
    var yearText = UITextField()
    var teamText = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listOfEvents.removeAll()
        self.coreData.fetchDataFromCore()
        self.listOfEvents = self.coreData.loadListOfEventsFromCore()
        
        configureTeamTextField()
        configureYearTextField()
        configureTableView()
        setUpNavigationBar()
        
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
    
    //Create list view when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        yearText.resignFirstResponder()
        teamText.resignFirstResponder()
        
        self.listOfEvents.removeAll()
        
        self.tbaParser.teamNumber = self.teamText.text ?? ""
        self.tbaParser.key = self.key.key
        self.tbaParser.eventSelectionController = self
        
        self.coreData.clearCoreData(entity: self.idsAndKeys.eventsCoreID)
        self.tbaParser.eventSelectionController = self
        self.tbaParser.getJSONEvents {
            let alert = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
            
            self.listOfEvents = self.tbaParser.createEventCells(jsonEvents : self.jsonListOfEvents, year: self.yearText.text ?? "")
            self.coreData.moveListOfEventsToCore(listOfEvents: self.listOfEvents)
            self.eventTable.reloadData()
        }
        
        UserDefaults.standard.set(teamText.text ?? "", forKey: self.idsAndKeys.userTeam)
        
        return true
    }
    
    private func setUpNavigationBar(){
        navigationItem.title = "Select FRC Event"
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
            self.performSegue(withIdentifier: "passEventKey", sender: self)
        }
        
        let cancel = UIAlertAction(title : "Cancel", style : .cancel, handler : nil)
        
        alert.addAction(getName)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}


