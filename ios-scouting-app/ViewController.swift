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

var key = tbaKey()
    
var validMatchNumber : [Int] = []
    
var selectedBoard = "B1"
var scoutName = "First L"
var boardList = ["B1", "B2", "B3", "R1", "R2", "R3", "RX", "BX"]
    
var listOfMatches = [Matches]()
    
let settingsView = UIViewController()
    
let settingsTag = 1;
let additemTag = 2;
let editNameTag = 3;
let boardSelectionTag = 4;

var event : String = ""
var year : Int = 0

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
            let settingsBoard = UIStoryboard(name : "Main", bundle: nil)
            
            guard let settingsVC = settingsBoard.instantiateViewController(withIdentifier: "SettingsViewController") as?
                SettingsViewController else { return }
            
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
        if(srcObj.tag == additemTag){
            print("Add item")
        }
        if(srcObj.tag == editNameTag){
            let alert = UIAlertController(title: "Enter name", message: "Initial and Last", preferredStyle: .alert)
            alert.addTextField {
                (UITextField) in UITextField.placeholder = "First L"
            }
            
            let getName = UIAlertAction(title: "OK", style: .default){
                [weak alert] (_) in
                let textField = alert?.textFields![0]
                self.scoutName = textField!.text ?? ""
                self.updateBoard(board: self.selectedBoard, scout: self.scoutName)
            }
            
            let cancel = UIAlertAction(title : "Cancel", style : .cancel, handler : nil)
            
            alert.addAction(getName)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        if(srcObj.tag == boardSelectionTag){
            let alert = UIAlertController(title: "Select board", message: "", preferredStyle: .alert)
            
            for i in 0..<self.boardList.count{
                let board = UIAlertAction(title : self.boardList[i], style: .default){
                    (ACTION) in self.updateBoard(board: self.boardList[i], scout: self.scoutName)
                    self.selectedBoard = self.boardList[i]
                    self.matchTable.reloadData()
                }
                alert.addAction(board)
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
   private func getTBAJson(completed : @escaping () -> ()){
        let url = URL(string: "https://www.thebluealliance.com/api/v3/event/2019onwin/matches/simple")!
        var request = URLRequest(url: url)
        //Remember to remove keys before committing
    request.setValue(self.key.key, forHTTPHeaderField: "X-TBA-Auth-Key")
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
    
    
    
    private func updateBoard(board : String, scout : String){
        let selectedBoard = UITextField(frame: .init(x: 0, y: 0, width: 34, height: 34))
        selectedBoard.isUserInteractionEnabled = false
        selectedBoard.text = board
        
        let scoutName = UITextField(frame: .init(x: 0, y: 0, width: 34, height: 34))
        scoutName.isUserInteractionEnabled = false
        scoutName.text = scout
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView : self.createSelectBoardButton()), UIBarButtonItem(customView: selectedBoard), UIBarButtonItem(customView: self.createEditNameButton()), UIBarButtonItem(customView: scoutName)]
    }
    
    private func createSelectBoardButton() -> UIButton{
        let selectBoardButton = UIButton(type : .system)
        selectBoardButton.setImage(UIImage (named : "paste")?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectBoardButton.frame = CGRect(x : 0, y : 0, width : 34, height : 34)
        selectBoardButton.tag = self.boardSelectionTag
        selectBoardButton.addTarget(self, action: #selector(self.clickHandler(srcObj:)), for: .touchUpInside)
        
        return selectBoardButton
    }
    
    private func createEditNameButton() -> UIButton{
        let editNameButton = UIButton(type : .system)
        editNameButton.setImage(UIImage(named : "users")?.withRenderingMode(.alwaysOriginal), for: .normal)
        editNameButton.tag = self.editNameTag
        editNameButton.addTarget(self, action: #selector(self.clickHandler(srcObj:)), for: .touchUpInside)
        editNameButton.frame = CGRect(x : 0, y : 0, width : 34, height : 34)

        return editNameButton
    }
    
    private func rightSideButtonsNavBar() -> [UIButton]{
        var listOfButtons : [UIButton] = []
        
        let addIconButton = UIButton(type: .system)
        addIconButton.setImage(UIImage(named: "addicon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addIconButton.frame = CGRect(x : 0, y : 0, width : 34, height : 34)
        
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(named : "settingsIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        addIconButton.addTarget(self, action: #selector(self.clickHandler(srcObj:)), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(self.clickHandler(srcObj:)), for: .touchUpInside)
        
        addIconButton.tag = self.additemTag
        settingButton.tag = self.settingsTag
        
        listOfButtons.append(addIconButton)
        listOfButtons.append(settingButton)
        
        return listOfButtons
        
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.backgroundColor = UIColor.white
        let selectedBoard = UITextField(frame: .init(x: 0, y: 0, width: 34, height: 34))
        selectedBoard.isUserInteractionEnabled = false
        selectedBoard.text = "B1"
        
        let scoutName = UITextField(frame : .init(x : 0, y : 0, width: 34, height: 34))
        scoutName.isUserInteractionEnabled = false
        scoutName.text = "First L"
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightSideButtonsNavBar()[0]), UIBarButtonItem(customView: rightSideButtonsNavBar()[1])]
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: self.createSelectBoardButton()), UIBarButtonItem(customView: selectedBoard), UIBarButtonItem(customView: self.createEditNameButton()), UIBarButtonItem(customView: scoutName)]
    }
    
    func createMatchSchedule() -> [matchSchedule]{
        var tempMatch : [matchSchedule] = []
        for i in 1...self.validMatchNumber.sorted().count{
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
                                let match = matchSchedule(icon : UIImage(named : "layers")!, matchNumber: String(i), blue1: self.listOfMatches[u].alliances.blue.team_keys[0], blue2: self.listOfMatches[u].alliances.blue.team_keys[1],
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
        return self.matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = matches[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Alliances") as! matchScheduleCells
        cell.setMatch(match: match)
        cell.backgroundColor = UIColor.white
        switch self.selectedBoard {
        case "B1":
            cell.blue1.textColor = UIColor.blue
            cell.blue2.textColor = UIColor.black
            cell.blue3.textColor = UIColor.black
            
            cell.red1.textColor = UIColor.black
            cell.red2.textColor = UIColor.black
            cell.red3.textColor = UIColor.black

        case "B2":
            cell.blue1.textColor = UIColor.black
            cell.blue2.textColor = UIColor.blue
            cell.blue3.textColor = UIColor.black
            
            cell.red1.textColor = UIColor.black
            cell.red2.textColor = UIColor.black
            cell.red3.textColor = UIColor.black
        case "B3":
            cell.blue1.textColor = UIColor.black
            cell.blue2.textColor = UIColor.black
            cell.blue3.textColor = UIColor.blue
            
            cell.red1.textColor = UIColor.black
            cell.red2.textColor = UIColor.black
            cell.red3.textColor = UIColor.black
        case "R1":
            cell.blue1.textColor = UIColor.black
            cell.blue2.textColor = UIColor.black
            cell.blue3.textColor = UIColor.black
            
            cell.red1.textColor = UIColor.red
            cell.red2.textColor = UIColor.black
            cell.red3.textColor = UIColor.black
        case "R2":
            cell.blue1.textColor = UIColor.black
            cell.blue2.textColor = UIColor.black
            cell.blue3.textColor = UIColor.black
            
            cell.red1.textColor = UIColor.black
            cell.red2.textColor = UIColor.red
            cell.red3.textColor = UIColor.black
            
        case "R3":
            cell.blue1.textColor = UIColor.black
            cell.blue2.textColor = UIColor.black
            cell.blue3.textColor = UIColor.black
        
            cell.red1.textColor = UIColor.black
            cell.red2.textColor = UIColor.black
            cell.red3.textColor = UIColor.red
            
        case "RX":
            cell.red1.textColor = UIColor.red
            cell.red2.textColor = UIColor.red
            cell.red3.textColor = UIColor.red
            
            cell.blue1.textColor = UIColor.black
            cell.blue2.textColor = UIColor.black
            cell.blue3.textColor = UIColor.black
            
        case "BX":
            cell.blue1.textColor = UIColor.blue
            cell.blue2.textColor = UIColor.blue
            cell.blue3.textColor = UIColor.blue
        
        default:
            cell.blue1.textColor = UIColor.black
            cell.blue2.textColor = UIColor.black
            cell.blue3.textColor = UIColor.black
            cell.red1.textColor = UIColor.black
            cell.red2.textColor = UIColor.black
            cell.red3.textColor = UIColor.black
}
        
        return cell
       
}


}
