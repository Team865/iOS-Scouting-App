//
//  ViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 2/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
var matchTable: UITableView!

var key = tbaKey()
    
var validMatchNumber : [Int] = []
    
var selectedBoard = "B1"
var scoutName = "First L"
var listOfBoardsTitles = ["Blue 1", "Blue 2", "Blue 3", "Red 1", "Red 2", "Red 3", "Blue Super Scout", "Red Super Scout"]
var listOfBoards = ["B1", "B2", "B3", "R1", "R2", "R3", "BX", "RX"]
    
let settingsView = UIViewController()
    
let settingsTag = 1;
let additemTag = 2;
let editNameTag = 3;
let boardSelectionTag = 4;

var event : String = ""
var year : Int = 0
var eventKey : String = ""
var currentEvent : String = "Current Event : None"
var listOfMatches : [matchSchedule] = []
var jsonListOfMatches = [Matches]()

var currentEventLabel : UILabel!
    
override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    
    let border = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.1695, width: UIScreen.main.bounds.width, height: 1))
    border.backgroundColor = UIColor.lightGray
    
    self.view.addSubview(border)
    
    currentEventLabel = self.createCurrentEventName()
    currentEventLabel.text = self.currentEvent
    
    self.view.addSubview(currentEventLabel)
    configureTableView()
    
}
    //Segue to update board
    //https://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                print(self.currentEvent)
                self.getTBAJson {
                               for i in 0..<self.jsonListOfMatches.count{
                                if(self.jsonListOfMatches[i].comp_level == "qm"){
                                    self.validMatchNumber.append(self.jsonListOfMatches[i].match_number)
                                   }
                               }
                    self.currentEventLabel.text = self.currentEvent
                    self.view.addSubview(self.currentEventLabel)
                    self.listOfMatches = self.createMatchSchedule()
                    self.matchTable.reloadData()
                }
            }
        }
    }
    
    //Handle clicking objects
    @objc func clickHandler(srcObj : UIButton) -> Void{
        if(srcObj.tag == settingsTag){
            let settingsBoard = UIStoryboard(name : "Main", bundle: nil)
            
            guard let settingsVC = settingsBoard.instantiateViewController(withIdentifier: "SettingsViewController") as?
                SettingsViewController else { return }
            
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
        if(srcObj.tag == additemTag){
            print("hi")
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
            
            for i in 0..<self.listOfBoards.count{
                let board = UIAlertAction(title : self.listOfBoardsTitles[i], style: .default){
                    (ACTION) in
                    self.updateBoard(board: self.listOfBoards[i], scout: self.scoutName)
                    self.selectedBoard = self.listOfBoards[i]
                    self.matchTable.reloadData()
                }
                alert.addAction(board)
            }
            
            let cancel = UIAlertAction(title : "Cancel", style: .cancel)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Update board after an action is performed
    private func updateBoard(board : String, scout : String){
        let selectedBoard = UITextField(frame: .init(x: 0, y: 0, width: 34, height: 34))
        selectedBoard.isUserInteractionEnabled = false
        selectedBoard.text = board
        
        switch(board){
        case "B1" : selectedBoard.textColor = UIColor.blue
        case "B2" : selectedBoard.textColor = UIColor.blue
        case "B3" : selectedBoard.textColor = UIColor.blue
        case "R1" : selectedBoard.textColor = UIColor.red
        case "R2" : selectedBoard.textColor = UIColor.red
        case "R3" : selectedBoard.textColor = UIColor.red
        case "BX" : selectedBoard.textColor = UIColor.blue
        case "RX" : selectedBoard.textColor = UIColor.red
        default :
            selectedBoard.textColor = UIColor.black
        }
        
        let scoutName = UITextField(frame: .init(x: 0, y: 0, width: 34, height: 34))
        scoutName.isUserInteractionEnabled = false
        scoutName.text = scout
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView : self.createSelectBoardButton()), UIBarButtonItem(customView: selectedBoard), UIBarButtonItem(customView: self.createEditNameButton()), UIBarButtonItem(customView: scoutName)]
    }
    //UI Configurations
    private func configureTableView(){
           matchTable = UITableView()
           matchTable.delegate = self
           matchTable.dataSource = self
           matchTable.rowHeight = UIScreen.main.bounds.height * 0.08
           
           matchTable.register(matchScheduleCells.self, forCellReuseIdentifier: "matchScheduleCells")
           view.addSubview(matchTable)
            matchTable.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.17, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.85)
           matchTable.tableFooterView = UIView()
       }
    
    private func createCurrentEventName() -> UILabel{
        let label = UILabel(frame: CGRect(x : Double(UIScreen.main.bounds.width * 0.05), y: Double(UIScreen.main.bounds.height * 0.075), width: Double(UIScreen.main.bounds.width * 0.9), height: Double(UIScreen.main.bounds.height * 0.12)))
        label.textAlignment = .center
        label.textColor = UIColor.systemBlue
        return label
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
        selectedBoard.textColor = UIColor.blue
        
        let scoutName = UITextField(frame : .init(x : 0, y : 0, width: 34, height: 34))
        scoutName.isUserInteractionEnabled = false
        scoutName.text = "First L"
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightSideButtonsNavBar()[0]), UIBarButtonItem(customView: rightSideButtonsNavBar()[1])]
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: self.createSelectBoardButton()), UIBarButtonItem(customView: selectedBoard), UIBarButtonItem(customView: self.createEditNameButton()), UIBarButtonItem(customView: scoutName)]
    }
    
    
    func getTBAJson(completed : @escaping () -> ()){
        print(self.eventKey)
        let url = URL(string: "https://www.thebluealliance.com/api/v3/event/" + self.eventKey + "/matches/simple")!
        var request = URLRequest(url: url)
        //Remember to remove keys before committing
    request.setValue(self.key.key, forHTTPHeaderField: "X-TBA-Auth-Key")
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                self.jsonListOfMatches = try decoder.decode([Matches].self, from: data)
                
                DispatchQueue.main.async {
                    completed()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
    }
    
    func createMatchSchedule() -> [matchSchedule]{
        var tempMatch : [matchSchedule] = []
        if(self.validMatchNumber.count != 0){
            for i in 1...self.validMatchNumber.sorted().count{
                        for u in 0..<self.jsonListOfMatches.count{
                            if(self.jsonListOfMatches[u].comp_level == "qm"){
                                if(self.jsonListOfMatches[u].match_number == i){
                                    for k in 0..<self.jsonListOfMatches[u].alliances.blue.team_keys.count{
                                        let bTeam = self.jsonListOfMatches[u].alliances.blue.team_keys[k]
            
                                        let index = bTeam.index(bTeam.startIndex, offsetBy: 3)..<bTeam.endIndex
            
                                        let parsedBlue = bTeam[index]
            
                                        self.jsonListOfMatches[u].alliances.blue.team_keys[k] = String(parsedBlue)
                                    }
                                    for p in 0..<self.jsonListOfMatches[u].alliances.red.team_keys.count{
                                        let rTeam = self.jsonListOfMatches[u].alliances.red.team_keys[p]
            
                                        let index = rTeam.index(rTeam.startIndex, offsetBy: 3)..<rTeam.endIndex
            
                                        let parsedRed = rTeam[index]
            
                                        self.jsonListOfMatches[u].alliances.red.team_keys[p] = String(parsedRed)
                                    }
                                    let match = matchSchedule(icon : UIImage(named : "layers")!, matchNumber: String(i), redAlliance:  self.jsonListOfMatches[u].alliances.red.team_keys, blueAlliance: self.jsonListOfMatches[u].alliances.blue.team_keys)
                                    tempMatch.append(match)
                                }
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
        return self.listOfMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = self.listOfMatches[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchScheduleCells", for : indexPath) as! matchScheduleCells
        cell.setMatch(match: match)
        cell.backgroundColor = UIColor.white
        
        let boards : [UILabel] = [cell.blue1, cell.blue2, cell.blue3, cell.red1, cell.red2, cell.red3]
        
        for i in 0..<boards.count{
            boards[i].textColor = UIColor.gray
        }
        
        switch(self.selectedBoard){
        case "B1" : cell.blue1.textColor = UIColor.blue
        case "B2" : cell.blue2.textColor = UIColor.blue
        case "B3" : cell.blue3.textColor = UIColor.blue
        case "R1" : cell.red1.textColor = UIColor.red
        case "R2" : cell.red2.textColor = UIColor.red
        case "R3" : cell.red3.textColor = UIColor.red
        case "BX" : for i in 0..<boards.count/2{
            boards[i].textColor = UIColor.blue
            }
        case "RX" : for i in boards.count/2..<boards.count{
            boards[i].textColor = UIColor.red
            }
        default:
            break
        }
        
        return cell
       
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scoutingActivity = UIStoryboard(name : "Main", bundle: nil)
        
        guard let scoutingVC = scoutingActivity.instantiateViewController(withIdentifier: "ScoutingViewController") as?
            ScoutingViewController else { return }
        
        self.navigationController?.pushViewController(scoutingVC, animated: true)
    }

}
