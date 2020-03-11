//
//  ViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 2/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var matchTable: UITableView!
    var matches : [matchSchedule] = []
    
    var blueTeam : [String] = []
    var redTeam : [String] = []
    var validMatchNumber : [Int] = []
    
    var listOfMatches = [Matches]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        getTBAJson {
            self.matchTable.reloadData()
            for i in 0..<self.listOfMatches.count{
                if(self.listOfMatches[i].comp_level == "qm"){
                    self.validMatchNumber.append(self.listOfMatches[i].match_number)
                }
            }
            print(self.validMatchNumber.sorted())
            self.matches = self.createMatchSchedule()
        }
        
        

        }

    private func getTBAJson(completed : @escaping () -> ()){
        let url = URL(string: "https://www.thebluealliance.com/api/v3/event/2019onwin/matches/simple")!
                        var request = URLRequest(url: url)
                    //Remember to remove keys before committing
    request.setValue("NTFtIarABYtYkZ4u3VmlDsWUtv39Sp5kiowxP1CArw3fiHi3IQ0XcenrH5ONqGOx", forHTTPHeaderField: "X-TBA-Auth-Key")
                        URLSession.shared.dataTask(with: request) {
                            (data, response, error) in
                            guard let data = data else { return }
                            do {
                                let decoder = JSONDecoder()
                                self.listOfMatches = try decoder.decode([Matches].self, from: data)
                                
                                DispatchQueue.main.async {
                                    completed()
                                }
                            } catch let jsonErr {
                                print(jsonErr)
                            }
             }.resume()
    }

    private func setupNavigationBar(){
        let addIconButton = UIButton(type: .system)
        addIconButton.setImage(UIImage(named: "addIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addIconButton.frame = CGRect(x : 0, y : 0, width : 34, height : 34)
        
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(named : "settingsIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: settingButton), UIBarButtonItem(customView: addIconButton)]
        }
    
    func createMatchSchedule() -> [matchSchedule]{
        var tempMatch : [matchSchedule] = []
        
        for i in 0...(self.listOfMatches.count - 1){
            for k in 0...(self.listOfMatches[i].alliances.blue.team_keys.count - 1){
                let bTeam = self.listOfMatches[i].alliances.blue.team_keys[k]
                
                let index = bTeam.index(bTeam.startIndex, offsetBy: 3)..<bTeam.endIndex
                
                let parsedBlue = bTeam[index]
                
                self.listOfMatches[i].alliances.blue.team_keys[k] = String(parsedBlue)
            }
            
            for p in 0...(self.listOfMatches[i].alliances.red.team_keys.count - 1){
                let rTeam = self.listOfMatches[i].alliances.red.team_keys[p]
                
                let index = rTeam.index(rTeam.startIndex, offsetBy: 3)..<rTeam.endIndex
                
                let parsedRed = rTeam[index]
                
                self.listOfMatches[i].alliances.red.team_keys[p] = String(parsedRed)
            }
            
            let match = matchSchedule(icon : UIImage(named : "database")!, matchNumber: String(i), blueAlliance: self.listOfMatches[i].alliances.blue.team_keys.joined(separator: " "), redAlliance: self.listOfMatches[i].alliances.red.team_keys.joined(separator: " "))
            
            //listOfMatches[i].alliances.blue.team_keys.joined(separator: " ")
            tempMatch.append(match)
        }
        return tempMatch
    }
}
extension ViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = matches[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "Alliances") as! matchScheduleCells
        cell.setMatch(match: match)
        
        return cell
    }
}

//                                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                                if let array = json as? [Any]
//                                {
//                                    for obj in array {
//                                        if let dictionary = obj as? [String : Any]{
//                                            if let alliances = dictionary["alliances"] as? [String : Any]{
//                                                if let blue = alliances["blue"] as? [String : Any]{
//                                                    if let blueTeam = blue["team_keys"] as? [Any]{
//                                                        for case let blue as String in blueTeam{
//                                                            let r = blue.index(blue.startIndex, offsetBy: 3)..<blue.endIndex
//                                                            let bTeam = blue[r]
//                                                            print(bTeam)
//                                                     }
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
