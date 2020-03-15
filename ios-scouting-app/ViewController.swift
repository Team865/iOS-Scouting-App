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
    
var validMatchNumber : [Int] = []
    
var selectedBoard = "B1"
var scoutName = "First L"

var listOfMatches = [Matches]()
    
let settingsView = UIViewController()
    
    let settingsTag = 1;
    let additemTag = 2;
    let editNameTag = 3;
    let boardSelectionTag = 4;

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
            
            alert.addAction(getName)
            
            self.present(alert, animated: true, completion: nil)
        }
        if(srcObj.tag == boardSelectionTag){
            let alert = UIAlertController(title: "Select board", message: "", preferredStyle: .alert)
            
            let B1 = UIAlertAction(title : "B1", style: .default) {
                (ACTION) in self.updateBoard(board: "B1", scout: self.scoutName)
                self.selectedBoard = "B1"
                self.matchTable.reloadData()

            }
            let B2 = UIAlertAction(title : "B2", style: .default){
                (ACTION) in self.updateBoard(board: "B2", scout: self.scoutName)
                self.selectedBoard = "B2"
                self.matchTable.reloadData()
            }
            let B3 = UIAlertAction(title : "B3", style: .default){
                (ACTION) in self.updateBoard(board: "B3", scout: self.scoutName)
                self.selectedBoard = "B3"
                self.matchTable.reloadData()

            }
            let R1 = UIAlertAction(title : "R1", style: .default){
                (ACTION) in self.updateBoard(board: "R1", scout: self.scoutName)
                self.selectedBoard = "R1"
                self.matchTable.reloadData()

            }
            let R2 = UIAlertAction(title : "R2", style: .default){
                (ACTION) in self.updateBoard(board: "R2", scout: self.scoutName)
                self.selectedBoard = "R2"
                self.matchTable.reloadData()

            }
            let R3 = UIAlertAction(title : "R3", style: .default){
                (ACTION) in self.updateBoard(board: "R3", scout: self.scoutName)
                self.selectedBoard = "R3"
                self.matchTable.reloadData()

            }

            let BX = UIAlertAction(title: "BX", style: .default){
                (ACTION) in self.updateBoard(board: "BX", scout: self.scoutName)
                self.selectedBoard = "BX"
                self.matchTable.reloadData()

            }
            let RX = UIAlertAction(title: "RX", style: .default){
                (ACTION) in self.updateBoard(board: "RX", scout: self.scoutName)
                self.selectedBoard = "RX"
                self.matchTable.reloadData()

            }
            
            alert.addAction(B1)
            alert.addAction(B2)
            alert.addAction(B3)
            alert.addAction(R1)
            alert.addAction(R2)
            alert.addAction(R3)
            alert.addAction(RX)
            alert.addAction(BX)
            

            self.present(alert, animated: true, completion: nil)
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
