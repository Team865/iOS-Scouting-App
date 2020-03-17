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
    
    var tableView : UITableView!
    let y = 100
    let viewDimension = 40
    var key = tbaKey()
    var jsonListOfEvents = [jsonEvents]()
    var listOfEvents : [Events] = []
    
    var yearText : UITextField!
    var teamText : UITextField!
    
    private func createButton(image : String, x : Int) -> UIButton {
        let button = UIButton(type : .system)
        button.setImage(UIImage(named : image)?.withRenderingMode(.alwaysOriginal), for : .normal)
        button.contentMode = .scaleAspectFit
        button.frame = CGRect(x : x, y : self.y, width: self.viewDimension, height : self.viewDimension)
        button.addTarget(self, action: #selector(onClick(sender:)), for: .touchUpInside)
        return button
    }
    
    private func createImageView(image : String, x : Int) -> UIImageView
    {
        let imageView = UIImageView(frame: CGRect(x : x, y : self.y, width: self.viewDimension, height: self.viewDimension))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named : image)
        
        return imageView
    }
    
    private func yearTextField(hint : String, tag : Int, x : Int) -> UITextField{
        let textField = UITextField(frame: CGRect(x : x, y : self.y, width : 80, height : self.viewDimension))
        textField.placeholder = hint
        textField.tag = tag
        textField.textAlignment = .left
        return textField
    }
    
    private func teamTextField(hint : String, tag : Int, x : Int) -> UITextField{
        let textField = UITextField(frame: CGRect(x : x, y : self.y, width : 80, height : self.viewDimension))
        textField.placeholder = hint
        textField.tag = tag
        textField.textAlignment = .left
        return textField
    }
    
    private func createEventCells() -> [Events]{
        var tempCell : [Events] = []
                for i in 0..<self.jsonListOfEvents.count{
                    if(jsonListOfEvents[i].year == Int(self.yearText.text!) ?? 0){
                        let event = Events.init(name: jsonListOfEvents[i].name, info : jsonListOfEvents[i].start_date + " in " + jsonListOfEvents[i].city + ", " + jsonListOfEvents[i].state_prov + ", " + jsonListOfEvents[i].country)
                        tempCell.append(event)
                    }
                }
        return tempCell
    }
    
    private func setUpView(team : UITextField, year : UITextField){
        self.view.addSubview(createImageView(image: "calendar", x: 20))
        self.view.addSubview(year)
        self.view.addSubview(createImageView(image: "team", x: 175))
        self.view.addSubview(team)
        self.view.addSubview(createButton(image: "search", x: 320 + self.viewDimension))
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        tableView.register(EventCells.self, forCellReuseIdentifier: "EventCells")
        view.addSubview(tableView)
        tableView.frame = CGRect(x : 0, y : 145, width: UIScreen.main.bounds.width, height : UIScreen.main.bounds.height)
        tableView.tableFooterView = UIView()
    }
    
    @objc func onClick (sender : UIButton){
        self.printText()
        
        getJSONEvents {
            self.listOfEvents = self.createEventCells()
            self.tableView.reloadData()
        }
        
    }
    
    private func printText(){
        print(self.yearText ?? "")
        print(self.teamText ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.yearText = yearTextField(hint: "Year", tag : 1,  x: 20 + self.viewDimension)
        self.teamText = teamTextField(hint: "Team", tag : 2, x: 175 + self.viewDimension)
        
        setUpNavigationBar()
        setUpView(team : self.teamText, year : self.yearText)
        configureTableView()

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
    
    
}



//for i in 0..<self.jsonListOfEvents.count{
//                if(self.jsonListOfEvents[i].year == 2019){
//                    self.indexes += 1
//                    print(self.jsonListOfEvents[i].name)
//                   print(self.jsonListOfEvents[i].start_date + " in " + self.jsonListOfEvents[i].city + ", " + self.jsonListOfEvents[i].state_prov + ", " + self.jsonListOfEvents[i].country)
//                }
//
//            }


