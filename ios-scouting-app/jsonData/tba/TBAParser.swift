//
//  MatchesEntryParser.swift
//  Scouting
//
//  Created by DUC LOC on 5/25/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class TBAParser {
    var key : String?
    var viewController : ViewController?
    
    //Parsing for main ViewController
    func getTBAJson(completed : @escaping () -> ()){
        
        let url = URL(string: "https://www.thebluealliance.com/api/v3/event/" + (self.viewController?.selectedEvent?.key ?? "") + "/matches/simple")!
        
        var request = URLRequest(url: url)
        request.setValue(self.key, forHTTPHeaderField: "X-TBA-Auth-Key")
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let jsonListOfMatches = try decoder.decode([Matches].self, from: data)
                self.viewController?.jsonListOfMatches = jsonListOfMatches
                DispatchQueue.main.async {
                    completed()
                }
                
            } catch _ {
                print("No key is found or no internet connection. Make sure to include the authorization key in TBAKey.swift")
            }
        }.resume()
    }
    
    
    
    func parseJSONDataToMatchSchedule(json : [Matches], board : String) -> [MatchSchedule]{
        var validMatchNumbers : [Int] = []
        var json = json
        var tempArr : [MatchSchedule] = []
        for i in 0..<json.count{
            if(json[i].comp_level == "qm"){
                validMatchNumbers.append(json[i].match_number)
            }
        }
        
        if(validMatchNumbers.count != 0){
            for i in 1...validMatchNumbers.sorted().count{
                for u in 0..<json.count{
                    if(json[u].comp_level == "qm"){
                        if(json[u].match_number == i){
                            for k in 0..<json[u].alliances.blue.team_keys.count{
                                let bTeam = json[u].alliances.blue.team_keys[k]
                                
                                let index = bTeam.index(bTeam.startIndex, offsetBy: 3)..<bTeam.endIndex
                                
                                let parsedBlue = bTeam[index]
                                
                                json[u].alliances.blue.team_keys[k] = String(parsedBlue)
                            }
                            for p in 0..<json[u].alliances.red.team_keys.count{
                                let rTeam = json[u].alliances.red.team_keys[p]
                                
                                let index = rTeam.index(rTeam.startIndex, offsetBy: 3)..<rTeam.endIndex
                                
                                let parsedRed = rTeam[index]
                                
                                json[u].alliances.red.team_keys[p] = String(parsedRed)
                            }
                            let match = MatchSchedule()
                            match.setUpMatchSchedule(imageName : "layers", matchNumber: i, redAlliance:  json[u].alliances.red.team_keys, blueAlliance: json[u].alliances.blue.team_keys, board: "B1", isScouted: false, scoutedData: "")
                            tempArr.append(match)
                        }
                    }
                    
                }
            }
        }
        
        return tempArr
        
    }
    
    //Parsing for eventSelectionController
    var teamNumber : String?
    var eventSelectionController : EventSelectionController?
    
    func getJSONEvents(completed : @escaping () -> ()){
        let url = URL(string: "https://www.thebluealliance.com/api/v3/team/frc" + (teamNumber ?? "") + "/events")!
        
        var request = URLRequest(url: url)
        request.setValue(self.key, forHTTPHeaderField: "X-TBA-Auth-Key")
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let jsonListOfEvents = try decoder.decode([jsonEvents].self, from: data)
                self.eventSelectionController?.jsonListOfEvents = jsonListOfEvents
                DispatchQueue.main.async {
                    completed()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
        
    }
    
    func createEventCells(jsonEvents : [jsonEvents], year : String) -> [Events]{
        var tempCell : [Events] = []
        
        for i in 0..<jsonEvents.count{
            if(jsonEvents[i].year == Int(year) ?? 0){
                let info = String(jsonEvents[i].start_date ?? "") + " in " + String(jsonEvents[i].city ?? "") + ", " + String(jsonEvents[i].state_prov ?? "") + String(jsonEvents[i].country ?? "")
                
                let event = Events(name: jsonEvents[i].name ?? "", info : info, key : (year) + (jsonEvents[i].event_code ?? ""))
                tempCell.append(event)
                
            }
        }
        
        return tempCell
    }
    
}
