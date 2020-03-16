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
    
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var team: UITextField!
    @IBOutlet weak var searchEvent: UIButton!
    
//    @IBAction func click(_ sender: Any) {
//        print(team.text!)
//
//    }

    var key = tbaKey()
    var jsonListOfEvents = [jsonEvents]()
    var listOfEvents : [Events] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        self.listOfEvents = self.createListOfEvents()

        getJSONEvents {
        
        }
    }
    
    private func setUpNavigationBar(){
           navigationItem.title = "Select FRC Event"
       }
    
    func createListOfEvents() -> [Events]{
        var tempEvent : [Events] = []
        

        for _ in 0...10 {
            let event = Events.init(name : "Hi", location : "Hello")
            tempEvent.append(event)
        }
        
        return tempEvent
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



//for i in 0..<self.jsonListOfEvents.count{
//                if(self.jsonListOfEvents[i].year == 2019){
//                    self.indexes += 1
//                    print(self.jsonListOfEvents[i].name)
//                   print(self.jsonListOfEvents[i].start_date + " in " + self.jsonListOfEvents[i].city + ", " + self.jsonListOfEvents[i].state_prov + ", " + self.jsonListOfEvents[i].country)
//                }
//
//            }

//        for i in 0..<self.jsonListOfEvents.count{
//            if(jsonListOfEvents[i].year == 2019){
//                let event = Events.init(name: jsonListOfEvents[i].name, location : jsonListOfEvents[i].start_date + " in " + jsonListOfEvents[i].city + ", " + jsonListOfEvents[i].state_prov + ", " + jsonListOfEvents[i].country)
//                tempEvent.append(event)
//            }
//        }
