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
        
        yearText = yearTextField(x: Double(self.screenWidth * 0.05), y: Double(self.screenHeight * 0.06) , width: Double(screenWidth * 0.40), height: Double(self.screenHeight * 0.13), hint: "year")
        teamText = teamTextField(x: Double(self.screenWidth * 0.55), y: Double(self.screenHeight * 0.06) , width: Double(screenWidth * 0.40), height: Double(self.screenHeight * 0.13), hint: "team")
        
        yearText.delegate = self
        teamText.delegate = self
        
        configureTableView()
        setUpNavigationBar()
        setUpView(team : self.teamText, year : self.yearText)

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
    private func setUpView(team : UITextField, year : UITextField){
        view.addSubview(team)
        view.addSubview(year)
    }
    
    private func configureTableView() {
        eventTable = UITableView()
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.rowHeight = UIScreen.main.bounds.height * 0.1
        
        eventTable.register(EventCells.self, forCellReuseIdentifier: "EventCells")
        view.addSubview(eventTable)
        
        eventTable.frame = CGRect(x: 0, y: Double(self.screenHeight * 0.15), width: Double(UIScreen.main.bounds.width), height: Double(self.screenHeight * 0.85))
        eventTable.tableFooterView = UIView()
    }
    
    private func yearTextField(x : Double, y : Double, width : Double, height : Double, hint : String) -> UITextField{
        let textField = UITextField(frame: CGRect(x : x, y : y, width : width, height : height))
        textField.placeholder = hint
        textField.textAlignment = .center
        
        let image = UIImageView(frame : CGRect(x : 0, y : 0, width : width * 0.8, height : height * 0.75))
        image.image = UIImage(named : "calendar")
        
        let bottomLine = CALayer()
            bottomLine.frame = CGRect(x : 0, y : y * 1.45, width: width, height : 2)
        bottomLine.backgroundColor = UIColor.black.cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
        
        textField.font = textField.font?.withSize(15)
        
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = image
        return textField
    }
    
    private func teamTextField(x : Double, y : Double, width : Double, height : Double, hint : String) -> UITextField{
    let textField = UITextField(frame: CGRect(x : x, y : y, width : width, height : height))
    textField.placeholder = hint
    textField.textAlignment = .center
        
    let image = UIImageView(frame : CGRect(x : 0, y : 0, width : width, height : height))
    image.image = UIImage(named : "team")
    
    let bottomLine = CALayer()
        bottomLine.frame = CGRect(x : 0, y : y * 1.45, width: width, height : 2)
    bottomLine.backgroundColor = UIColor.black.cgColor
    textField.borderStyle = .none
    textField.layer.addSublayer(bottomLine)
        
    textField.font = textField.font?.withSize(15)
    textField.leftViewMode = UITextField.ViewMode.always
    textField.leftView = image
    return textField
    }
    
    private func createEventCells() -> [Events]{
        var tempCell : [Events] = []
                for i in 0..<self.jsonListOfEvents.count{
                    if(jsonListOfEvents[i].year == Int(self.yearText.text!) ?? 0){
                        let event = Events.init(name: jsonListOfEvents[i].name, info : jsonListOfEvents[i].start_date + " in " + jsonListOfEvents[i].city + ", " + jsonListOfEvents[i].state_prov + ", " + jsonListOfEvents[i].country)
                        tempCell.append(event)
                        self.listOfKeys.append(self.yearText.text! + jsonListOfEvents[i].event_code)
                        self.listOfNames.append(self.jsonListOfEvents[i].name)
                    }
                }
        return tempCell
    }
    
    private func setUpNavigationBar(){
           navigationItem.title = "Select FRC Event"
       }
    
    private func getJSONEvents(completed : @escaping () -> ()){
        let url = URL(string: "https://www.thebluealliance.com/api/v3/team/frc" + self.teamText.text! + "/events")!
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
                    [weak alert] (_) in
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


