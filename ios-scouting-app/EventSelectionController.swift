//
//  EventSelectionController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/16/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class EventSelectionController : UIViewController{
    
    var eventTable : UITableView!
    let y = Int(UIScreen.main.bounds.height / 10)
    let viewDimension = 40
    var key = tbaKey()
    var jsonListOfEvents = [jsonEvents]()
    var listOfEvents : [Events] = []
    var listOfKeys : [String] = []
    var yearText : UITextField!
    var teamText : UITextField!
    let viewController = ViewController()
    
    override func viewDidLoad() {
           super.viewDidLoad()
//        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action : #selector(dismissKeyboard(sender:)))
//
//        view.addGestureRecognizer(tap)
           self.yearText = yearTextField(hint: "Year", tag : 1,  x: 15 + (Int(UIScreen.main.bounds.width / 10)))
           self.teamText = teamTextField(hint: "Team", tag : 2, x: Int(UIScreen.main.bounds.width * 0.47) + (Int(UIScreen.main.bounds.width / 10)))
           
        configureTableView()
        setUpNavigationBar()
        setUpView(team : self.teamText, year : self.yearText)

       }
    
    private func createButton(image : String, x : Int) -> UIButton {
        let button = UIButton(type : .system)
        button.setImage(UIImage(named : image)?.withRenderingMode(.alwaysOriginal), for : .normal)
        button.contentMode = .scaleAspectFit
        button.frame = CGRect(x : x, y : self.y, width: Int(UIScreen.main.bounds.width / 10), height : self.viewDimension)
        button.addTarget(self, action: #selector(onClick(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(dismissKeyboard(sender:)) , for: .touchUpInside)
        return button
    }
    
    private func createImageView(image : String, x : Int) -> UIImageView
    {
        let imageView = UIImageView(frame: CGRect(x : x, y : self.y, width: Int(UIScreen.main.bounds.width / 10), height: self.viewDimension))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named : image)
        
        return imageView
    }
    
    private func yearTextField(hint : String, tag : Int, x : Int) -> UITextField{
        let textField = UITextField(frame: CGRect(x : x, y : self.y, width : (Int(UIScreen.main.bounds.width / 3)), height : self.viewDimension))
        textField.placeholder = hint
        textField.tag = tag
        textField.textAlignment = .center
        return textField
    }
    
    private func teamTextField(hint : String, tag : Int, x : Int) -> UITextField{
        let textField = UITextField(frame: CGRect(x : x, y : self.y, width : Int(UIScreen.main.bounds.width / 3), height : self.viewDimension))
        textField.placeholder = hint
        textField.tag = tag
        textField.textAlignment = .center
        return textField
    }
    
    private func createEventCells() -> [Events]{
        var tempCell : [Events] = []
                for i in 0..<self.jsonListOfEvents.count{
                    if(jsonListOfEvents[i].year == Int(self.yearText.text!) ?? 0){
                        let event = Events.init(name: jsonListOfEvents[i].name, info : jsonListOfEvents[i].start_date + " in " + jsonListOfEvents[i].city + ", " + jsonListOfEvents[i].state_prov + ", " + jsonListOfEvents[i].country)
                        tempCell.append(event)
                        self.listOfKeys.append(self.yearText.text! + jsonListOfEvents[i].event_code)
                    }
                }
        return tempCell
    }
    
    private func setUpView(team : UITextField, year : UITextField){
        self.view.addSubview(createImageView(image: "calendar", x: 15))
        self.view.addSubview(year)
        self.view.addSubview(createImageView(image: "team", x: Int(UIScreen.main.bounds.width * 0.47)))
        self.view.addSubview(team)
        self.view.addSubview(createButton(image: "search", x: Int(UIScreen.main.bounds.width * 0.87)))
    }
    
    private func configureTableView() {
        eventTable = UITableView()
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.rowHeight = 80
        
        
        eventTable.register(EventCells.self, forCellReuseIdentifier: "EventCells")
        view.addSubview(eventTable)
        
        let tableY = self.y + self.viewDimension
        eventTable.frame = CGRect(x: 0, y: tableY, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.height))
        eventTable.tableFooterView = UIView()
    }
    
    @objc func dismissKeyboard(sender : UIButton){
        view.endEditing(true)
    }
    
    @objc func onClick (sender : UIButton){
        getJSONEvents {
            self.listOfEvents = self.createEventCells()
            self.eventTable.reloadData()
        }
        
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
        let mainController = UIStoryboard(name : "Main", bundle: nil)
        guard let mainVC = mainController.instantiateViewController(withIdentifier: "MainController") as?
                           ViewController else { return }
        mainVC.eventKey = self.listOfKeys[indexPath.row]
        self.navigationController?.pushViewController(mainVC, animated: true)
        }
}
