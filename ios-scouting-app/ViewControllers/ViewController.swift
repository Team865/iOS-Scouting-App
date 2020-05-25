//
//  ViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 2/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//
import UIKit

public var isTimerEnabled = false
var listOfSelectedTeams : [String] = []
var listOfOpposingTeams : [String] = []
var selectedIndex = 0
var newMatch = 0
var newTeam = ""
var numberOfAddedEntriesIndices : [Int] = []
var listOfNewMatches : [Int] = []
class ViewController: UIViewController {
    var selectedMatchEntry : MatchEntry?
    var selectedEvent : Events?
    
    var idsAndKeys = IDsAndKeys()
    
    var matchTable = UITableView()
    
    var key = tbaKey()
    
    var addedEntry = false
    
    var selectedBoard = "B1"
    var scoutName = "First L"
    
    var selectedTeam = ""
    var selectedMatch = "M"
    
    let settingsTag = 1;
    let additemTag = 2;
    let editNameTag = 3;
    let boardSelectionTag = 4;
    
    var listOfMatches : [matchSchedule] = []
    var jsonListOfMatches = [Matches]()
    
    var currentEventLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        self.configureEventNameLabel()
        self.configureTableView()
        
        self.view.addSubview(currentEventLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.selectedEvent = Events(name: "", info: "", key : "")
        self.getMatchScheduleFromCache()
        
        isTimerEnabled = false
    }
    
    //UI Configurations
    private func configureTableView(){
        let borderView = UIView()
        borderView.backgroundColor = UIColor.gray
        
        matchTable = UITableView()
        matchTable.delegate = self
        matchTable.dataSource = self
        matchTable.rowHeight = UIScreen.main.bounds.height * 0.08
        matchTable.register(matchScheduleCells.self, forCellReuseIdentifier: self.idsAndKeys.matchScheduleCellID)
        
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
        currentEventLabel.text = self.selectedEvent?.name ?? ""
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
                self.listOfMatches.removeAll()
                listOfSelectedTeams.removeAll()
                listOfOpposingTeams.removeAll()
                numberOfAddedEntriesIndices.removeAll()
                listOfNewMatches.removeAll()
                
                var validMatchNumbers : [Int] = []
                
                self.getTBAJson {
                    for i in 0..<self.jsonListOfMatches.count{
                        if(self.jsonListOfMatches[i].comp_level == "qm"){
                            validMatchNumbers.append(self.jsonListOfMatches[i].match_number)
                        }
                    }
                    
                    self.listOfMatches =  self.createMatchSchedule(validMatchNumbers : validMatchNumbers)
                    
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
                    self.currentEventLabel.text = self.selectedEvent?.name
                    self.updateBoard(board: self.selectedBoard, scout: self.scoutName)
                    
                    print(self.selectedEvent?.key ?? "")
                    
                    self.matchTable.reloadData()
                    
                    self.updateCache()
                }
            }
        }
    }
    
    func getTBAJson(completed : @escaping () -> ()){
        let url = URL(string: "https://www.thebluealliance.com/api/v3/event/" + (self.selectedEvent?.key ?? "") + "/matches/simple")!
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
    
    func createMatchSchedule(validMatchNumbers : [Int]) -> [matchSchedule]{
        var tempMatch : [matchSchedule] = []
        if(validMatchNumbers.count != 0){
            for i in 1...validMatchNumbers.sorted().count{
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
                            let match = matchSchedule(imageName : "layers", matchNumber: i, redAlliance:  self.jsonListOfMatches[u].alliances.red.team_keys, blueAlliance: self.jsonListOfMatches[u].alliances.blue.team_keys, board: self.selectedBoard, isScouted: false, scoutedData: "")
                            tempMatch.append(match)
                        }
                    }
                    
                }
            }
        }
        
        
        return tempMatch
    }
    
    //Handle clicking objects
    @objc func clickHandler(srcObj : UIButton) -> Void{
        if(srcObj.tag == settingsTag){
            let settingsBoard = UIStoryboard(name : "Main", bundle: nil)
            
            guard let settingsVC = settingsBoard.instantiateViewController(withIdentifier: self.idsAndKeys.settingsViewController) as?
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
                
                let entry = MatchEntry()
                entry.setMatchEntry(board: self.selectedBoard, scoutName: self.scoutName, matchNumber: match, opposingTeamNumber: "", teamNumber: team, eventKey: self.selectedEvent?.key ?? "")
                scoutingVC.matchEntry = entry
                
                newMatch = Int(match) ?? 0
                newTeam = team
                
                self.addedEntry = true
                
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
                UserDefaults.standard.set(self.scoutName, forKey: "scoutName")
                self.updateBoard(board: self.selectedBoard, scout: self.scoutName)
            }
            
            let cancel = UIAlertAction(title : "Cancel", style : .cancel, handler : nil)
            
            alert.addAction(getName)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
        if(srcObj.tag == boardSelectionTag){
            let alert = UIAlertController(title: "Select board", message: "", preferredStyle: .alert)
            
            let listOfBoardsTitles = ["Blue 1", "Blue 2", "Blue 3", "Red 1", "Red 2", "Red 3", "Blue Super Scout", "Red Super Scout"]
            let listOfBoards = ["B1", "B2", "B3", "R1", "R2", "R3", "BX", "RX"]
            
            for i in 0..<listOfBoards.count{
                let board = UIAlertAction(title : listOfBoardsTitles[i], style: .default){
                    (ACTION) in
                    self.updateBoard(board: listOfBoards[i], scout: self.scoutName)
                    self.selectedBoard = listOfBoards[i]
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
    
    private func updateSelectedTeamsList(list : [matchSchedule], index : Int, board : String){
        if (board == "BX"){
            for i in 0..<list.count{
                listOfSelectedTeams.append(list[i].blueAlliance[0] + " " + list[i].blueAlliance[1] + " " + list[i].blueAlliance[2])
                listOfOpposingTeams.append(list[i].redAlliance[0] + " " + list[i].redAlliance[1] + " " + list[i].redAlliance[2])
            }
        }
        
        if (board == "RX"){
            for i in 0..<list.count{
                listOfSelectedTeams.append(list[i].redAlliance[0] + " " + list[i].redAlliance[1] + " " + list[i].redAlliance[2])
                listOfOpposingTeams.append(list[i].blueAlliance[0] + " " + list[i].blueAlliance[1] + " " + list[i].blueAlliance[2])
            }
        }
        
        if (board.prefix(1) == "B"){
            for i in 0..<list.count{
                listOfSelectedTeams.append(list[i].blueAlliance[index])
            }
        }
        
        if (board.prefix(1) == "R"){
            for i in 0..<list.count{
                listOfSelectedTeams.append(list[i].redAlliance[index])
            }
        }
        
    }
    
    //Update board after an action is performed
    private func updateBoard(board : String, scout : String){
        let selectedBoard = UITextField(frame: .init(x: 0, y: 0, width: 34, height: 34))
        selectedBoard.isUserInteractionEnabled = false
        selectedBoard.text = board
        
        listOfSelectedTeams.removeAll()
        listOfOpposingTeams.removeAll()
        
        switch(board){
        case "B1" : selectedBoard.textColor = UIColor.blue
        self.updateSelectedTeamsList(list: self.listOfMatches, index: 0, board: "B")
        case "B2" : selectedBoard.textColor = UIColor.blue
        self.updateSelectedTeamsList(list: self.listOfMatches, index: 1, board: "B")
        case "B3" : selectedBoard.textColor = UIColor.blue
        self.updateSelectedTeamsList(list: self.listOfMatches, index: 2, board: "B")
        case "R1" : selectedBoard.textColor = UIColor.red
        self.updateSelectedTeamsList(list: self.listOfMatches, index: 0, board: "R")
        case "R2" : selectedBoard.textColor = UIColor.red
        self.updateSelectedTeamsList(list: self.listOfMatches, index: 1, board: "R")
        case "R3" : selectedBoard.textColor = UIColor.red
        self.updateSelectedTeamsList(list: self.listOfMatches, index: 2, board: "B")
        case "BX" : selectedBoard.textColor = UIColor.blue
        self.updateSelectedTeamsList(list: self.listOfMatches, index: 0, board: "BX")
        case "RX" : selectedBoard.textColor = UIColor.red
        self.updateSelectedTeamsList(list: self.listOfMatches, index: 0, board: "RX")
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
        if let numberOfAddedEntriesIndicesCache = UserDefaults.standard.object(forKey: self.idsAndKeys.numberOfAddedEntriesIndices) as? [Int] {
            numberOfAddedEntriesIndices = numberOfAddedEntriesIndicesCache
        }
        
        if let listOfNewMatchesCache = UserDefaults.standard.object(forKey: self.idsAndKeys.listOfNewMatches) as? [Int]{
            listOfNewMatches = listOfNewMatchesCache
        }
        if let blueAlliance = UserDefaults.standard.object(forKey: self.idsAndKeys.blueAlliance) as? [[String]]
            ,let redAlliance = UserDefaults.standard.object(forKey: self.idsAndKeys.redAlliance) as? [[String]]
            ,let matchNumber = UserDefaults.standard.object(forKey: self.idsAndKeys.matchNumber) as? [Int]
            , let imageName = UserDefaults.standard.object(forKey: self.idsAndKeys.imageName) as? [String]
            , let boards = UserDefaults.standard.object(forKey: self.idsAndKeys.boards) as? [String]
            , let isScouted = UserDefaults.standard.object(forKey: self.idsAndKeys.isScouted) as? [Bool]
            , let scoutedData = UserDefaults.standard.object(forKey: self.idsAndKeys.scoutedData) as? [String]{
            self.listOfMatches = self.loadMatchScheduleFromCache(blueAlliance: blueAlliance, redAlliance: redAlliance, matchNumber: matchNumber, imageName: imageName, boards: boards, isScouted: isScouted, scoutedData: scoutedData)
        }
        
        
        
        if(isTimerEnabled){
            var redAlliances : [String] = []
            var blueAlliances : [String] = []
            var icon = "check"
            var matchNumber = 0
            
            if (addedEntry){
                let listOfBoards : [String] = []
                icon = "addicon"
                let emptyboi = "_ _ _"
                matchNumber = newMatch
                for i in 0..<3{
                    if(self.selectedMatchEntry?.board == listOfBoards[i]){
                        blueAlliances.append(self.selectedMatchEntry?.teamNumber ?? "")
                    } else {
                        blueAlliances.append(emptyboi)
                    }
                }
                
                for i in 3..<6{
                    if(self.selectedMatchEntry?.board == listOfBoards[i]){
                        redAlliances.append(self.selectedMatchEntry?.teamNumber ?? "")
                    } else {
                        redAlliances.append(emptyboi)
                    }
                }
            } else {
                redAlliances = self.listOfMatches[selectedIndex].redAlliance
                blueAlliances = self.listOfMatches[selectedIndex].blueAlliance
                matchNumber = self.listOfMatches[selectedIndex].matchNumber
            }
            
            let newMatchSchedule = matchSchedule.init(imageName: icon, matchNumber: matchNumber, redAlliance: redAlliances , blueAlliance: blueAlliances, board : self.selectedMatchEntry?.board ?? "", isScouted: true, scoutedData: "")
            self.listOfMatches.append(newMatchSchedule)
            
            self.listOfMatches.sort(by: { $0.matchNumber < $1.matchNumber })
            
            listOfNewMatches.append(newMatch)
            listOfNewMatches.sort()
            
            var tempArr : [Int] = []
            var pointer = 0
            for i in 0..<self.listOfMatches.count{
                if (pointer < listOfNewMatches.count){
                    if (self.listOfMatches[i].isScouted){
                        tempArr.append(i)
                        pointer += 1
                    }
                }
                
            }
            
            numberOfAddedEntriesIndices = tempArr
            
        }
        
        if let currentEvent = UserDefaults.standard.object(forKey: self.idsAndKeys.currentEvent) as? String{
            self.currentEventLabel.text = currentEvent
        }
        
        if let selectedBoard = UserDefaults.standard.object(forKey: self.idsAndKeys.selectedBoard) as? String{
            self.selectedBoard = selectedBoard
            self.updateBoard(board: selectedBoard, scout: scoutName)
        }
        
        if let scoutName = UserDefaults.standard.object(forKey: self.idsAndKeys.scoutName) as? String{
            self.scoutName = scoutName
            self.updateBoard(board: self.selectedBoard, scout: scoutName)
        }
        
        if let eventKey = UserDefaults.standard.object(forKey: self.idsAndKeys.eventKey) as? String {
            self.selectedEvent?.key = eventKey
        }
        
        updateCache()
        self.matchTable.reloadData()
        
    }
    
    func updateCache(){
        var blueAlliance : [[String]] = []
        var redAlliance : [[String]] = []
        var matchNumber : [Int] = []
        var imageName : [String] = []
        var boards : [String] = []
        var isScouted : [Bool] = []
        var scoutedData : [String] = []
        
        for i in 0..<self.listOfMatches.count{
            blueAlliance.append(self.listOfMatches[i].blueAlliance)
            redAlliance.append(self.listOfMatches[i].redAlliance)
            matchNumber.append(self.listOfMatches[i].matchNumber)
            imageName.append(self.listOfMatches[i].imageName)
            boards.append(self.listOfMatches[i].board)
            isScouted.append(self.listOfMatches[i].isScouted)
            scoutedData.append(self.listOfMatches[i].scoutedData)
        }
        
        UserDefaults.standard.set(blueAlliance, forKey: self.idsAndKeys.blueAlliance)
        UserDefaults.standard.set(redAlliance, forKey: self.idsAndKeys.redAlliance)
        UserDefaults.standard.set(matchNumber, forKey: self.idsAndKeys.matchNumber)
        UserDefaults.standard.set(imageName, forKey: self.idsAndKeys.imageName)
        UserDefaults.standard.set(boards, forKey: self.idsAndKeys.boards)
        UserDefaults.standard.set(scoutedData, forKey: self.idsAndKeys.scoutedData)
        UserDefaults.standard.set(self.selectedEvent?.key, forKey: self.idsAndKeys.eventKey)
        UserDefaults.standard.set(numberOfAddedEntriesIndices, forKey: self.idsAndKeys.numberOfAddedEntriesIndices)
        UserDefaults.standard.set(listOfNewMatches, forKey: self.idsAndKeys.listOfNewMatches)
        UserDefaults.standard.set(isScouted, forKey: self.idsAndKeys.isScouted)
        UserDefaults.standard.set(self.currentEventLabel.text, forKey: self.idsAndKeys.currentEvent)
        
    }
    
    func loadMatchScheduleFromCache(blueAlliance : [[String]], redAlliance : [[String]], matchNumber : [Int], imageName : [String], boards : [String], isScouted : [Bool], scoutedData : [String]) -> [matchSchedule]{
        var tempMatch : [matchSchedule] = []
        
        for i in 0..<matchNumber.count{
            tempMatch.append(matchSchedule.init(imageName: imageName[i], matchNumber: matchNumber[i], redAlliance: redAlliance[i], blueAlliance: blueAlliance[i], board: boards[i], isScouted: isScouted[i], scoutedData: scoutedData[i]))
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.idsAndKeys.matchScheduleCellID, for : indexPath) as! matchScheduleCells
        
        cell.setMatch(match: match)
        
        let boards : [UILabel] = [cell.blue1, cell.blue2, cell.blue3, cell.red1, cell.red2, cell.red3]
        
        for i in 0..<boards.count{
            boards[i].textColor = UIColor.gray
        }
        
        switch(match.board){
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
        let scoutingVC = scoutingActivity.instantiateViewController(withIdentifier: self.idsAndKeys.scoutingActivity) as! ScoutingActivity
        
        if (self.listOfMatches[indexPath.row].isScouted){
            let arr = self.listOfMatches[indexPath.row].scoutedData.components(separatedBy: ":")
            
            let alert = UIAlertController(title: arr[0], message: "", preferredStyle: .alert)
            
            let qrGenerator = QRCodeGenerator()
            
            let qrImageView = qrGenerator.generateQRCode(from : self.listOfMatches[indexPath.row].scoutedData)
            
            let maxSize = CGSize(width : 245, height : 245)
            let imageSize = qrImageView!.size
            
            var ratio : CGFloat!
            if (imageSize.width > imageSize.height){
                ratio = maxSize.width / imageSize.width
            } else {
                ratio = maxSize.height / imageSize.height
            }
            
            let scaledSize = CGSize(width : imageSize.width * ratio, height: imageSize.height * ratio)
            
            let resizeImage = qrImageView?.imageWithSize(scaledSize)
            
            let qrAction = UIAlertAction(title: "", style: .default, handler: nil)
            qrAction.isEnabled = false
            qrAction.setValue(resizeImage?.withRenderingMode(.alwaysOriginal), forKey: "image")
            alert.addAction(qrAction)
            
            let cancel = UIAlertAction(title : "OK", style: .destructive)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        } else {
            var opposingTeamNumber = ""
            if (self.selectedBoard == "BX" || self.selectedBoard == "RX"){
                opposingTeamNumber = listOfOpposingTeams[indexPath.row]
            }
            
            let entry = MatchEntry()
            entry.setMatchEntry(board: self.listOfMatches[indexPath.row].board, scoutName: self.scoutName, matchNumber: String(listOfMatches[indexPath.row].matchNumber), opposingTeamNumber: opposingTeamNumber, teamNumber: listOfSelectedTeams[indexPath.row], eventKey: self.selectedEvent?.key ?? "")
            scoutingVC.matchEntry = entry
            
            selectedIndex = indexPath.row
            self.addedEntry = false
            
            self.navigationController?.pushViewController(scoutingVC, animated: true)
            UserDefaults.standard.set(self.selectedBoard, forKey: self.idsAndKeys.selectedBoard)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = self.listOfMatches[indexPath.row].isScouted ? UIColor(red: 0.40, green: 1.00, blue: 0.53, alpha: 0.38): UIColor.white
    }
}
