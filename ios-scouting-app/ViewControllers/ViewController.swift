//
//  ViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 2/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    var selectedMatchEntry = MatchEntry()
    var selectedEvent : Events?
    var matchEntryParser = TBAParser()
    var idsAndKeys = IDsAndKeys()
    var key = TBAKey()
    var coreData = CoreData()
    
    var matchTable = UITableView()
    
    var listOfSelectedTeams : [String] = []
    var listOfOpposingTeams : [String] = []
    
    var selectedBoard = "B1"
    var scoutName = "First L"
    var currentEvent = ""
    
    let settingsTag = 1;
    let additemTag = 2;
    let editNameTag = 3;
    let boardSelectionTag = 4;
    
    var listOfMatches : [MatchSchedule] = []
    var jsonListOfMatches = [Matches]()
    
    var currentEventLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataInCore()
        
        self.updateScoutedEntries(matchEntry : self.selectedMatchEntry)
        self.updateBoard(board: self.selectedBoard, scout: self.scoutName)
        
        self.setupNavigationBar()
        self.configureEventNameLabel()
        self.configureTableView()
        
        
    }
    
    //UI Configurations
    private func configureTableView(){
        let borderView = UIView()
        borderView.backgroundColor = UIColor.gray
        
        matchTable = UITableView()
        matchTable.delegate = self
        matchTable.dataSource = self
        matchTable.rowHeight = UIScreen.main.bounds.height * 0.08
        matchTable.register(MatchScheduleCells.self, forCellReuseIdentifier: self.idsAndKeys.matchScheduleCellID)
        
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
        self.view.addSubview(currentEventLabel)
        
        currentEventLabel.textColor = UIColor.blue
        currentEventLabel.textAlignment = .center
        
        self.currentEvent = self.selectedEvent?.name ?? "Current Event : None"
        
        currentEventLabel.text = currentEvent
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
        selectedBoard.text = self.selectedBoard
        
        if (self.selectedBoard.prefix(1) == "B"){
            selectedBoard.textColor = UIColor.blue
        } else if (self.selectedBoard.prefix(1) == "R"){
            selectedBoard.textColor = UIColor.red
        }
        
        let scoutName = UITextField(frame : .init(x : 0, y : 0, width: 34, height: 34))
        scoutName.isUserInteractionEnabled = false
        scoutName.text = self.scoutName
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightSideButtonsNavBar()[0]), UIBarButtonItem(customView: rightSideButtonsNavBar()[1])]
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: self.createSelectBoardButton()), UIBarButtonItem(customView: selectedBoard), UIBarButtonItem(customView: self.createEditNameButton()), UIBarButtonItem(customView: scoutName)]
    }
    
    func updateDataInCore(){
        self.coreData.clearCoreData(entity : self.idsAndKeys.matchScheduleCoreID)
        self.coreData.saveUIElementsContent(viewController: self)
        self.coreData.moveMatchScheduleToCore(matchSchedule : self.listOfMatches)
        self.coreData.saveSelectedEventEntry(viewController: self)
    }
    
    func loadDataInCore(){
        self.coreData.fetchDataFromCore()
        self.coreData.loadUIElementsContent(viewController: self)
        self.listOfMatches = self.coreData.loadMatchScheduleFromCore()
        self.selectedEvent = self.coreData.loadSelectedEventEntry()
    }
    
    //Updaters, Listeners, hanlders, other stuff
    //Segue to update board
    //https://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.listOfMatches.removeAll()
                self.listOfSelectedTeams.removeAll()
                self.listOfOpposingTeams.removeAll()
                self.matchEntryParser.viewController = self
                self.matchEntryParser.key = self.key.key
                
                self.matchEntryParser.getTBAJson{
                    self.listOfMatches = self.matchEntryParser.parseJSONDataToMatchSchedule(json: self.jsonListOfMatches, board : self.selectedBoard)
                    self.updateBoard(board: self.selectedBoard, scout: self.scoutName)
                    self.currentEventLabel.text = self.selectedEvent?.name
                    self.coreData.clearCoreData(entity : self.idsAndKeys.matchScheduleCoreID)
                    self.coreData.saveUIElementsContent(viewController: self)
                    self.coreData.moveMatchScheduleToCore(matchSchedule : self.listOfMatches)
                    self.coreData.saveSelectedEventEntry(viewController: self)
                    self.matchTable.reloadData()
                }
                
            }
        }
    }
    
    func updateScoutedEntries(matchEntry : MatchEntry){
        let index = matchEntry.atIndex
        
        let matchSchedule = MatchSchedule()
        matchSchedule.setUpMatchSchedule(imageName: "check", matchNumber: Int(matchEntry.matchNumber) ?? 0, redAlliance: self.listOfMatches[index].redAlliance, blueAlliance: self.listOfMatches[index].redAlliance, board: matchEntry.board, isScouted: matchEntry.isScouted, scoutedData: matchEntry.scoutedData)
        
        if (matchEntry.addedEntry){
            let emptyBoi = "_ _ _"
            let imageName = "addicon"
            var redAlliance : [String] = []
            var blueAlliance : [String] = []
            let boardNumber = Int(matchSchedule.board.suffix(1)) ?? 1
            if (matchEntry.board.prefix(1) == "B"){
                redAlliance = [emptyBoi, emptyBoi, emptyBoi]
                
                for i in 0..<3{
                    if (i == boardNumber - 1){
                        blueAlliance.append(matchEntry.teamNumber)
                    } else {
                        blueAlliance.append(emptyBoi)
                    }
                }
            } else {
                blueAlliance = [emptyBoi, emptyBoi, emptyBoi]
                
                for i in 0..<3{
                    if (i == boardNumber - 1){
                        redAlliance.append(matchEntry.teamNumber)
                    } else {
                        redAlliance.append(emptyBoi)
                    }
                }
            }
            
            matchSchedule.imageName = imageName
            matchSchedule.blueAlliance = blueAlliance
            matchSchedule.redAlliance = redAlliance
            
        }
        
        if (matchEntry.isScouted){
            self.listOfMatches.append(matchSchedule)
            self.updateDataInCore()
        }
        
        self.listOfMatches.sort(by: { $0.matchNumber < $1.matchNumber })
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
                let scoutingVC = scoutingActivity.instantiateViewController(withIdentifier: self.idsAndKeys.scoutingActivity) as! ScoutingActivity
                
                let entry = MatchEntry()
                entry.setMatchEntry(board: self.selectedBoard, scoutName: self.scoutName, matchNumber: match, opposingTeamNumber: "", teamNumber: team, eventKey: self.selectedEvent?.key ?? "", atIndex : 0, isScouted: false, addedEntry : true, scoutedData: "")
                scoutingVC.matchEntry = entry
                
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
                self.updateDataInCore()
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
                    self.selectedBoard = listOfBoards[i]
                    self.updateBoard(board: listOfBoards[i], scout: self.scoutName)
                    self.coreData.saveUIElementsContent(viewController: self)
                }
                alert.addAction(board)
            }
            
            let cancel = UIAlertAction(title : "Cancel", style: .cancel)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func updateListOfSelectedTeams(list : [MatchSchedule], index : Int, board : String){
        var blueX : [String] = []
        var redX : [String] = []
        
        var blue : [String] = []
        var red : [String] = []
        
        for i in 0..<list.count{
            blueX.append(list[i].blueAlliance[0] + " " + list[i].blueAlliance[1] + " " + list[i].blueAlliance[2])
            redX.append(list[i].redAlliance[0] + " " + list[i].redAlliance[1] + " " + list[i].redAlliance[2])
            blue.append(list[i].blueAlliance[index])
            red.append(list[i].redAlliance[index])
        }
        
        if (board == "BX"){
            self.listOfSelectedTeams = blueX
            self.listOfOpposingTeams = redX
        } else if (board == "RX") {
            self.listOfSelectedTeams = redX
            self.listOfOpposingTeams = blueX
        } else if (board.prefix(1) == "B"){
            self.listOfSelectedTeams = blue
        } else if (board.prefix(1) == "R"){
            self.listOfSelectedTeams = red
        }
        
    }
    
    //Update board after an action is performed
    private func updateBoard(board : String, scout : String){
        let selectedBoard = UITextField(frame: .init(x: 0, y: 0, width: 34, height: 34))
        selectedBoard.isUserInteractionEnabled = false
        selectedBoard.text = board
        
        listOfSelectedTeams.removeAll()
        listOfOpposingTeams.removeAll()
        
        if (self.selectedBoard.prefix(1) == "B"){
            selectedBoard.textColor = UIColor.blue
        } else if (self.selectedBoard.prefix(1) == "R"){
            selectedBoard.textColor = UIColor.red
        }
        
        self.updateListOfSelectedTeams(list: self.listOfMatches, index: ((Int(String(board.suffix(1))) ?? 1) - 1), board: board)
        
        //Update boards in match schedules entry
        for i in 0..<self.listOfMatches.count{
            if (!self.listOfMatches[i].isScouted){
                self.listOfMatches[i].board = self.selectedBoard
            }
        }
        
        let scoutName = UITextField(frame: .init(x: 0, y: 0, width: 34, height: 34))
        scoutName.isUserInteractionEnabled = false
        scoutName.text = scout
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView : self.createSelectBoardButton()), UIBarButtonItem(customView: selectedBoard), UIBarButtonItem(customView: self.createEditNameButton()), UIBarButtonItem(customView: scoutName)]
        
        self.matchTable.reloadData()
    }
    
}
extension ViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = self.listOfMatches[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.idsAndKeys.matchScheduleCellID, for : indexPath) as! MatchScheduleCells
        
        cell.setMatch(match: match)
        
        let boards : [UILabel] = [cell.blue1, cell.blue2, cell.blue3, cell.red1, cell.red2, cell.red3]
        
        for i in 0..<boards.count{
            boards[i].textColor = UIColor.gray
        }
        
        switch(match.board){
        case "B1" : cell.blue1.textColor = UIColor.blue
        case "B2" : cell.blue2.textColor = UIColor.blue;
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
            
            self.selectedMatchEntry = MatchEntry()
            self.selectedMatchEntry.setMatchEntry(board: self.listOfMatches[indexPath.row].board, scoutName: self.scoutName, matchNumber: String(listOfMatches[indexPath.row].matchNumber), opposingTeamNumber: opposingTeamNumber, teamNumber: listOfSelectedTeams[indexPath.row], eventKey: self.selectedEvent?.key ?? "", atIndex : indexPath.row, isScouted: false, addedEntry : false, scoutedData : "")
            scoutingVC.matchEntry = self.selectedMatchEntry
            
            self.navigationController?.pushViewController(scoutingVC, animated: true)
            UserDefaults.standard.set(self.selectedBoard, forKey: self.idsAndKeys.selectedBoard)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = self.listOfMatches[indexPath.row].isScouted ? UIColor(red: 0.40, green: 1.00, blue: 0.53, alpha: 0.38): UIColor.white
    }
}
