//
//  ViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 2/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//
import UIKit

public var isTimerEnabled = false
public var isNewEventSelected = false
public var firstTimeBoot = true
public var prevEvent = 0
var selectedIndex = 0
var addedEntry = false
var entrySelection = false
var newMatch = 0
var newTeam = ""
var numberOfAddedEntriesIndices : [Int] = []
var listOfNewMatches : [Int] = []
class ViewController: UIViewController {

var matchTable = UITableView()

var key = tbaKey()
    
var validMatchNumber : [Int] = []
var index = 0
    
var selectedBoard = "B1"
var selectedTeam = ""
var selectedMatch = "M"

var listOfSelectedTeams : [String] = []
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
    
    self.configureEventNameLabel()
    self.configureTableView()
    
    self.view.addSubview(currentEventLabel)
    configureTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.getMatchScheduleFromCache()

        isTimerEnabled = false

        DataPoints.removeAll()
        encodedData = ""
        encodedDataPoints = ""
    }
    
    //UI Configurations
    private func configureTableView(){
        let borderView = UIView()
        borderView.backgroundColor = UIColor.gray
        
        matchTable = UITableView()
        matchTable.delegate = self
        matchTable.dataSource = self
        matchTable.rowHeight = UIScreen.main.bounds.height * 0.08
        matchTable.register(matchScheduleCells.self, forCellReuseIdentifier: "matchScheduleCells")
           
        view.addSubview(matchTable)
        view.addSubview(borderView)
                
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.topAnchor.constraint(equalTo: currentEventLabel.bottomAnchor, constant: 1).isActive = true
        borderView.leadingAnchor.constraint(equalTo : self.view.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        borderView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.0005).isActive = true
        
        matchTable.translatesAutoresizingMaskIntoConstraints = false
        matchTable.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 1).isActive = true
        matchTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        matchTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        matchTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        matchTable.tableFooterView = UIView()
       }
    
    private func configureEventNameLabel(){
        currentEventLabel = UILabel()
        currentEventLabel.textColor = UIColor.blue
        currentEventLabel.textAlignment = .center
        currentEventLabel.text = self.currentEvent
        self.view.addSubview(currentEventLabel)
        
        currentEventLabel.translatesAutoresizingMaskIntoConstraints = false
        currentEventLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        currentEventLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: UIScreen.main.bounds.width * 0.05).isActive = true
        currentEventLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        currentEventLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
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
    
    //Updaters, Listeners, hanlders, other stuff
    //Segue to update board
    //https://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                var blueAlliance : [[String]] = []
                var redAlliance : [[String]] = []
                var matchNumber : [Int] = []
                var imageName : [String] = []
                var boards : [String] = []
                var isScouted : [Bool] = []
                
                firstTimeBoot = false
                
                if (isNewEventSelected && !firstTimeBoot){
                    self.listOfMatches.removeAll()
                    self.listOfSelectedTeams.removeAll()
                    numberOfAddedEntriesIndices.removeAll()
                    listOfNewMatches.removeAll()
                }
                
                self.getTBAJson {
                    for i in 0..<self.jsonListOfMatches.count{
                                if(self.jsonListOfMatches[i].comp_level == "qm"){
                                    self.validMatchNumber.append(self.jsonListOfMatches[i].match_number)
                                   }
                               }
                    self.currentEventLabel.text = self.currentEvent
                    self.view.addSubview(self.currentEventLabel)
                    self.listOfMatches.append(contentsOf : self.createMatchSchedule())
                    
                    self.listOfMatches.sort(by: { $0.matchNumber < $1.matchNumber })
                    
                    var tempArr : [Int] = []
                    var pointer = 0
                    for i in 0..<self.listOfMatches.count{
                        if (pointer < listOfNewMatches.count){
                            if (self.listOfMatches[i].matchNumber == listOfNewMatches[pointer] && self.listOfMatches[i].isScouted){
                                tempArr.append(i)
                                pointer += 1
                            }
                        }
                        
                    }
                    numberOfAddedEntriesIndices = tempArr
                    self.matchTable.reloadData()
                    
                    for i in 0..<self.listOfMatches.count{
                        blueAlliance.append(self.listOfMatches[i].blueAlliance)
                        redAlliance.append(self.listOfMatches[i].redAlliance)
                        matchNumber.append(self.listOfMatches[i].matchNumber)
                        imageName.append(self.listOfMatches[i].imageName)
                        boards.append(self.listOfMatches[i].board)
                        isScouted.append(self.listOfMatches[i].isScouted)
                    }
                    
                    
                    UserDefaults.standard.set(blueAlliance, forKey: "blueAlliance")
                    UserDefaults.standard.set(redAlliance, forKey: "redAlliance")
                    UserDefaults.standard.set(matchNumber, forKey: "matchNumber")
                    UserDefaults.standard.set(imageName, forKey: "icon")
                    UserDefaults.standard.set(boards, forKey: "boards")
                    UserDefaults.standard.set(isScouted, forKey: "isScouted")
                    UserDefaults.standard.set(self.currentEvent, forKey: "currentEvent")
                    UserDefaults.standard.set(self.scoutName, forKey: "scout")
                    UserDefaults.standard.set(self.eventKey, forKey: "eventKey")
                    UserDefaults.standard.set(firstTimeBoot, forKey: "firstTimeBoot")
                    UserDefaults.standard.set(prevEvent, forKey: "prevEvent")
                    UserDefaults.standard.set(numberOfAddedEntriesIndices, forKey: "addedMatches")
                    UserDefaults.standard.set(listOfNewMatches, forKey: "addedMatchesNumber")
                
                }
            }
        }
    }
    
    func getTBAJson(completed : @escaping () -> ()){
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
    
    //Handle clicking objects
    @objc func clickHandler(srcObj : UIButton) -> Void{
        if(srcObj.tag == settingsTag){
            let settingsBoard = UIStoryboard(name : "Main", bundle: nil)
            
            guard let settingsVC = settingsBoard.instantiateViewController(withIdentifier: "SettingsViewController") as?
                SettingsViewController else { return }
            
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
        if(srcObj.tag == additemTag){
            let alert = UIAlertController(title: "Add new entry", message: "", preferredStyle: .alert)
            alert.addTextField {
                (UITextField) in UITextField.placeholder = "Match"
            }
            
            alert.addTextField {
                (UITextField) in UITextField.placeholder = "Team"
            }
            
            let getName = UIAlertAction(title: "OK", style: .default){
                [weak alert] (_) in
                let match = alert?.textFields?[0].text ?? ""
                let team = alert?.textFields?[1].text ?? ""
                
                let scoutingActivity = UIStoryboard(name : "Main", bundle: nil)
                let scoutingVC = scoutingActivity.instantiateViewController(withIdentifier: "ScoutingActivity") as! ScoutingActivity
                
                teamNumber = team
                matchNumber = "M" + match
                separatedMatchNumber = match
                boardName = self.selectedBoard
                
                newMatch = Int(match) ?? 0
                newTeam = team
                
                addedEntry = true
                entrySelection = false
                
                self.navigationController?.pushViewController(scoutingVC, animated: true)
                
            }
            
            let cancel = UIAlertAction(title : "Cancel", style : .cancel, handler : nil)
            
            alert.addAction(getName)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        if(srcObj.tag == editNameTag){
            let alert = UIAlertController(title: "Enter name", message: "Initial and Last", preferredStyle: .alert)
            alert.addTextField {
                (UITextField) in UITextField.placeholder = "First L"
                UITextField.text = self.scoutName
            }
            
            let getName = UIAlertAction(title: "OK", style: .default){
                [weak alert] (_) in
                let textField = alert?.textFields![0]
                self.scoutName = textField!.text ?? ""
                UserDefaults.standard.set(self.scoutName, forKey: "ScoutName")
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
                    UserDefaults.standard.set(self.selectedBoard, forKey: "SelectedBoard")
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
        
        var pointer = 0
        var updatedBoards : [String] = []
        for i in 0..<self.listOfMatches.count{
            if (pointer < numberOfAddedEntriesIndices.count){
            if (i == numberOfAddedEntriesIndices[pointer]){
                pointer += 1
            } else {
                self.listOfMatches[i].board = board
            }
            } else {
                self.listOfMatches[i].board = board
            }
            
            updatedBoards.append(listOfMatches[i].board)
        }
        UserDefaults.standard.set(updatedBoards, forKey: "boards")
                
        let scoutName = UITextField(frame: .init(x: 0, y: 0, width: 34, height: 34))
        scoutName.isUserInteractionEnabled = false
        scoutName.text = scout
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView : self.createSelectBoardButton()), UIBarButtonItem(customView: selectedBoard), UIBarButtonItem(customView: self.createEditNameButton()), UIBarButtonItem(customView: scoutName)]

    }
    
    func getMatchScheduleFromCache(){
        if let selectedBoard = UserDefaults.standard.object(forKey: "SelectedBoard") as? String{
               self.selectedBoard = selectedBoard
           }
           
           if let listOfSelectedBoard = UserDefaults.standard.object(forKey: "addedMatches") as? [Int] {
               numberOfAddedEntriesIndices = listOfSelectedBoard
           }
           
           if let listOfNewMatchesCache = UserDefaults.standard.object(forKey: "addedMatchesNumber") as? [Int]{
               listOfNewMatches = listOfNewMatchesCache
           }
    
           if let firstTimeBootCache = UserDefaults.standard.object(forKey: "firstTimeBoot") as? Bool{
                firstTimeBoot = firstTimeBootCache
           }
        
           if let prevEventCache = UserDefaults.standard.object(forKey: "prevEvent") as? Int{
                prevEvent = prevEventCache
            }
        
        if let blueAlliance = UserDefaults.standard.object(forKey: "blueAlliance") as? [[String]]{
                    if let redAlliance = UserDefaults.standard.object(forKey: "redAlliance") as? [[String]]{
                        if let matchNumber = UserDefaults.standard.object(forKey: "matchNumber") as? [Int]{
                            if let imageName = UserDefaults.standard.object(forKey: "icon") as? [String]{
                                if let boards = UserDefaults.standard.object(forKey: "boards") as? [String]{
                                    if let isScouted = UserDefaults.standard.object(forKey: "isScouted") as? [Bool]{
                                        self.listOfMatches = self.loadMatchScheduleFromCoreData(blueAlliance: blueAlliance, redAlliance: redAlliance, matchNumber: matchNumber, imageName: imageName, boards: boards, isScouted: isScouted)
                                }
                                }
                        }
                    }
                }
        }
        
        if(isTimerEnabled && entrySelection){
            self.listOfMatches[selectedIndex].isScouted = true
            listOfNewMatches.append(self.listOfMatches[selectedIndex].matchNumber)
            listOfNewMatches.sort()
            
            var tempArr : [Int] = []
            var pointer = 0
             for i in 0..<self.listOfMatches.count{
                 if (pointer < listOfNewMatches.count){
                     if (self.listOfMatches[i].matchNumber == listOfNewMatches[pointer] && self.listOfMatches[i].isScouted){
                         tempArr.append(i)
                         pointer += 1
                     }
                 }
                 
             }
            
             numberOfAddedEntriesIndices = tempArr
            
            updateCache()
        } else if(isTimerEnabled && addedEntry){
            let emptyboi = "_ _ _"
            
            var redAlliances : [String] = []
            var blueAlliances : [String] = []
            
            for i in 0..<3{
                if(boardName == self.listOfBoards[i]){
                    blueAlliances.append(teamNumber)
                } else {
                    blueAlliances.append(emptyboi)
                }
            }
            
            for i in 3..<6{
                if(boardName == self.listOfBoards[i]){
                    redAlliances.append(teamNumber)
                } else {
                    redAlliances.append(emptyboi)
                }
            }
            
            let newMatchSchedule = matchSchedule.init(imageName: "addicon", matchNumber: newMatch, redAlliance: redAlliances , blueAlliance: blueAlliances, board : boardName, isScouted: true)
            self.listOfMatches.append(newMatchSchedule)
            
            self.listOfMatches.sort(by: { $0.matchNumber < $1.matchNumber })
            
            listOfNewMatches.append(newMatch)
            listOfNewMatches.sort()
            
            var tempArr : [Int] = []
            var pointer = 0
            for i in 0..<self.listOfMatches.count{
                if (pointer < listOfNewMatches.count){
                    if (self.listOfMatches[i].matchNumber == listOfNewMatches[pointer] && self.listOfMatches[i].isScouted){
                        tempArr.append(i)
                        pointer += 1
                    }
                }
                
            }
           
            numberOfAddedEntriesIndices = tempArr
            
            updateCache()
        }

        if let currentEvent = UserDefaults.standard.object(forKey: "currentEvent") as? String{
            self.currentEventLabel.text = currentEvent
        }
        
        if let selectedBoard = UserDefaults.standard.object(forKey: "SelectedBoard") as? String{
            self.selectedBoard = selectedBoard
            self.updateBoard(board: selectedBoard, scout: scoutName)
        }
        if let selectedTeams = UserDefaults.standard.object(forKey: "SelectedTeams") as? [String]{
            self.listOfSelectedTeams = selectedTeams
        }
        
        if let scoutName = UserDefaults.standard.object(forKey: "ScoutName") as? String{
            self.scoutName = scoutName
            self.updateBoard(board: self.selectedBoard, scout: scoutName)
        }
        
        self.matchTable.reloadData()

    }
    
    func updateCache(){
        var blueAlliance : [[String]] = []
        var redAlliance : [[String]] = []
        var matchNumber : [Int] = []
        var imageName : [String] = []
        var boards : [String] = []
        var isScouted : [Bool] = []
        for i in 0..<self.listOfMatches.count{
            blueAlliance.append(self.listOfMatches[i].blueAlliance)
            redAlliance.append(self.listOfMatches[i].redAlliance)
            matchNumber.append(self.listOfMatches[i].matchNumber)
            imageName.append(self.listOfMatches[i].imageName)
            boards.append(self.listOfMatches[i].board)
            isScouted.append(self.listOfMatches[i].isScouted)
        }
        
        UserDefaults.standard.set(blueAlliance, forKey: "blueAlliance")
        UserDefaults.standard.set(redAlliance, forKey: "redAlliance")
        UserDefaults.standard.set(matchNumber, forKey: "matchNumber")
        UserDefaults.standard.set(imageName, forKey: "icon")
        UserDefaults.standard.set(boards, forKey: "boards")
        UserDefaults.standard.set(numberOfAddedEntriesIndices, forKey: "addedMatches")
        UserDefaults.standard.set(listOfNewMatches, forKey: "addedMatchesNumber")
        UserDefaults.standard.set(isScouted, forKey: "isScouted")
        
        print(isScouted)
    }
    
    func loadMatchScheduleFromCoreData(blueAlliance : [[String]], redAlliance : [[String]], matchNumber : [Int], imageName : [String], boards : [String], isScouted : [Bool]) -> [matchSchedule]{
        var tempMatch : [matchSchedule] = []
        
        for i in 0..<matchNumber.count{
            tempMatch.append(matchSchedule.init(imageName: imageName[i], matchNumber: matchNumber[i], redAlliance: redAlliance[i], blueAlliance: blueAlliance[i], board: boards[i], isScouted: isScouted[i]))
        }
        
        return tempMatch
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
                                    let match = matchSchedule(imageName : "layers", matchNumber: i, redAlliance:  self.jsonListOfMatches[u].alliances.red.team_keys, blueAlliance: self.jsonListOfMatches[u].alliances.blue.team_keys, board: self.selectedBoard, isScouted: false)
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

        let boards : [UILabel] = [cell.blue1, cell.blue2, cell.blue3, cell.red1, cell.red2, cell.red3]
        
        for i in 0..<boards.count{
            boards[i].textColor = UIColor.gray
        }
        switch(match.board){
            case "B1" : cell.blue1.textColor = UIColor.blue
            self.listOfSelectedTeams.append(cell.blue1.text!)
            case "B2" : cell.blue2.textColor = UIColor.blue
            self.listOfSelectedTeams.append(cell.blue2.text!)
            case "B3" : cell.blue3.textColor = UIColor.blue
            self.listOfSelectedTeams.append(cell.blue3.text!)

            case "R1" : cell.red1.textColor = UIColor.red
            self.listOfSelectedTeams.append(cell.red1.text!)
            case "R2" : cell.red2.textColor = UIColor.red
            self.listOfSelectedTeams.append(cell.red2.text!)
            case "R3" : cell.red3.textColor = UIColor.red
            self.listOfSelectedTeams.append(cell.red3.text!)
            case "BX" : for i in 0..<boards.count/2{
                boards[i].textColor = UIColor.blue
                self.listOfSelectedTeams.append(contentsOf: [cell.blue1.text!, cell.blue2.text!, cell.blue3.text!])
                }
            case "RX" : for i in boards.count/2..<boards.count{
                boards[i].textColor = UIColor.red
                self.listOfSelectedTeams.append(contentsOf: [cell.red1.text!, cell.red2.text!, cell.red3.text!])
                }
            default:
                break
            }
        
       
        
        return cell
       
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scoutingActivity = UIStoryboard(name : "Main", bundle: nil)
        let scoutingVC = scoutingActivity.instantiateViewController(withIdentifier: "ScoutingActivity") as! ScoutingActivity
        
        teamNumber = self.listOfSelectedTeams[indexPath.row]
        matchNumber = "M" + String(listOfMatches[indexPath.row].matchNumber)
        separatedMatchNumber = String(listOfMatches[indexPath.row].matchNumber)
        boardName = self.listOfMatches[indexPath.row].board
        selectedIndex = indexPath.row
        
        entrySelection = true
        addedEntry = false
        
        UserDefaults.standard.set(self.listOfSelectedTeams, forKey: "SelectedTeams")
        UserDefaults.standard.set(self.selectedBoard, forKey: "SelectedBoard")
        self.listOfSelectedTeams.removeAll()
    
        self.navigationController?.pushViewController(scoutingVC, animated: true)
        
        }
}
