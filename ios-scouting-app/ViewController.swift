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

var numbers = [1,2,3,4,5]

var validMatchNumber : [Int] = []

var listOfMatches = [Matches]()
    
let settingsView = UIViewController()
    
    let settingsTag = 1;
    let additemTag = 2;
    let boardSelectionTag = 3;

override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()

    getTBAJson {
        for i in 0..<self.listOfMatches.count{
            if(self.listOfMatches[i].comp_level == "qm"){
                self.validMatchNumber.append(self.listOfMatches[i].match_number)
            }
        }
        
        self.matches = self.createMatchSchedule()
        
        self.matchTable.reloadData()
    }
}
    @objc func clickHandler(srcObj : UIButton) -> Void{
        if(srcObj.tag == settingsTag){
            print("Settings")
        }
        if(srcObj.tag == additemTag){
            print("Add item")
        }
        if(srcObj.tag == boardSelectionTag){
            let alert = UIAlertController(title: "Select board", message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
   private func getTBAJson(completed : @escaping () -> ()){
        let url = URL(string: "https://www.thebluealliance.com/api/v3/event/2019onwin/matches/simple")!
        var request = URLRequest(url: url)
        //Remember to remove keys before committing
        request.setValue("key", forHTTPHeaderField: "X-TBA-Auth-Key")
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
        
        let selectBoardButton = UIButton(type : .system)
        selectBoardButton.setImage(UIImage (named : "paste")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: settingButton), UIBarButtonItem(customView: addIconButton)]
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: selectBoardButton)]
        
        addIconButton.tag = self.additemTag
        settingButton.tag = self.settingsTag
        selectBoardButton.tag = self.boardSelectionTag
        
        addIconButton.addTarget(self, action: #selector(self.clickHandler(srcObj:)), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(self.clickHandler(srcObj:)), for: .touchUpInside)
        selectBoardButton.addTarget(self, action: #selector(self.clickHandler(srcObj:)), for: .touchUpInside)
    }
    
    func createMatchSchedule() -> [matchSchedule]{
        var tempMatch : [matchSchedule] = []
              for i in 0..<self.validMatchNumber.sorted().count{
                    for u in 0..<self.listOfMatches.count{
                        if(self.listOfMatches[u].comp_level == "qm"){
                            if(self.listOfMatches[u].match_number == i){
                                for k in 0..<self.listOfMatches[u].alliances.blue.team_keys.count{
                                    let bTeam = self.listOfMatches[u].alliances.blue.team_keys[k]
        
                                    let index = bTeam.index(bTeam.startIndex, offsetBy: 3)..<bTeam.endIndex
        
                                    let parsedBlue = bTeam[index]
        
                                    self.listOfMatches[u].alliances.blue.team_keys[k] = String(parsedBlue)
                                }
                                for p in 0..<self.listOfMatches[u].alliances.red.team_keys.count{
                                    let rTeam = self.listOfMatches[u].alliances.red.team_keys[p]
        
                                    let index = rTeam.index(rTeam.startIndex, offsetBy: 3)..<rTeam.endIndex
        
                                    let parsedRed = rTeam[index]
        
                                    self.listOfMatches[u].alliances.red.team_keys[p] = String(parsedRed)
                                }
                                let match = matchSchedule(icon : UIImage(named : "database")!, matchNumber: String(i), blue1: self.listOfMatches[u].alliances.blue.team_keys[0], blue2: self.listOfMatches[u].alliances.blue.team_keys[1],
                                                          blue3: self.listOfMatches[u].alliances.blue.team_keys[2],
                                                          red1: self.listOfMatches[u].alliances.red.team_keys[0],
                                                          red2: self.listOfMatches[u].alliances.red.team_keys[1],
                                                          red3: self.listOfMatches[u].alliances.red.team_keys[2])
                                tempMatch.append(match)
                            }
                        }
        
                    }
                }
        
        return tempMatch
    }
}
extension ViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.validMatchNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = matches[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Alliances") as! matchScheduleCells
        cell.setMatch(match: match)
        //cell.blue1.textColor = UIColor.blue
        return cell
    }
}


