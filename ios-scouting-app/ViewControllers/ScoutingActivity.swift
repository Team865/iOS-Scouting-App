//
//  ScoutingActivity.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/22/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

//Remove or keep, you decide
public var encodedData = ""
public var encodedDataPoints = ""
public var DataPoints = [DataPoint]()
public var listOfButtonsOnScreen : [ButtonField] = []
public var listOfSwitchesOnScreen : [SwitchField] = []
public var listOfCheckBoxesOnScreen : [CheckBoxField] = []
public var listOfMultiToggleFieldScreen : [MultiToggleField] = []
var entry = Entry(match: "", team: 0, scout: "", board: "", timeStamp: Float(Date().timeIntervalSinceReferenceDate), data_point: [])
var screenLayout : ScoutingScreenLayout!
public var timeStamp : Float = 0
public var prevToggleValue = 0
var matchNumber = ""
var opposingTeamNumber = ""
var teamNumber = ""
var boardName = ""
var timeOnStart = "015"
var separatedMatchNumber = ""
private var selectedTeam = 0
private var selectedBoard = ""
private var selectedKey = ""
private var selectedScout = ""
private var comment = ""
class ScoutingActivity : UIViewController{
    let navBarWidth = UIScreen.main.bounds.width
    let navBarHeight = Double(UIScreen.main.bounds.height * 0.1)
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    let Ymultiplier = 1.325
    let heightMultiplier = 0.6
    let buttonsWidth = UIScreen.main.bounds.width * 0.15
    
    var listOfLabels : [UILabel] = []
    var navBarView : UIView!
    var itemTags = 0
    let images = ["timer", "team", "paste", "layers2"]
    var screenTitles : [String] = []
    
    var isCreated : [Bool] = []
    
    //UIs
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var StartTimerButton: UIButton!
    @IBOutlet weak var CommentButton: UIButton!
    @IBOutlet weak var UndoButton: UIButton!
    @IBOutlet weak var scoutingView: UICollectionView!
    
    //Button controllers
    var hideStartTimer = false
    var hidePlayButton = true
    var hidePauseButton = true
    var hideUndoButton = true
    
    //Progress bar
    @IBOutlet weak var progressBar: UISlider!
    var progressBarTimer : Timer!
    var totalProgress : Float = 0
    let progress = Progress(totalUnitCount: 16500)
    
    var names : [String] = []
    var types : [String] = []
    
    //ScoutingScreen variables
    var listOfTags : [[[Int]]] = []
    var listOfItemsType : [[[String]]] = []
    var listOfItemsName : [[[String]]] = []
    var listOfToggleTitles : [[[[String]]]] = []
    var QRImageCellID = "QRImageCell"
    var QRImageCellMade : [QRImageCell] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarView = self.createNavBarView()
        setUpNavigationBar()
        configureButtons()
        configureProgressBar()
        
        var itemIndex = 0
        comment = ""

        //This is disgusting
        getLayoutForScreen{
            if (boardName == "BX" || boardName == "RX"){
               let scoutingType = screenLayout.super_scout
                
                let currentTeam = teamNumber.components(separatedBy: " ")
                let opposingTeam = opposingTeamNumber.components(separatedBy: " ")
                
                for i in 0..<scoutingType.screens.count{
                        var indices : [[Int]] = []
                        var items : [[String]] = []
                        var names : [[String]] = []
                        var choices : [[[String]]] = []
                        self.screenTitles.append(scoutingType.screens[i].title)
                        self.isCreated.append(false)
                    for k in 0..<scoutingType.screens[i].layout.count{
                            var tagsInRow : [Int] = []
                            var itemsInRow : [String] = []
                            var namesInRow : [String] = []
                            var choicesInRow : [[String]] = []
                            for j in 0..<scoutingType.screens[i].layout[k].count{
                                let type = scoutingType.screens[i].layout[k][j].type
                                let name = self.formatTitle(string: scoutingType.screens[i].layout[k][j].name, currentTeam: currentTeam, opposingTeam: opposingTeam)
                                let choice = self.formatChoices(string: scoutingType.screens[i].layout[k][j].choices ?? [], currentTeam: currentTeam, opposingTeam: opposingTeam)
                                itemsInRow.append(type)
                                namesInRow.append(name)
                                choicesInRow.append(choice)
                                tagsInRow.append(itemIndex)
                                itemIndex += 1
                            }
                            items.append(itemsInRow)
                            names.append(namesInRow)
                            choices.append(choicesInRow)
                            indices.append(tagsInRow)
                        }
                        self.listOfTags.append(indices)
                        self.listOfItemsType.append(items)
                        self.listOfItemsName.append(names)
                        self.listOfToggleTitles.append(choices)
                    }
            } else {
                let scoutingType = screenLayout.robot_scout
                for i in 0..<scoutingType.screens.count{
                    var indices : [[Int]] = []
                    var items : [[String]] = []
                    var names : [[String]] = []
                    var choices : [[[String]]] = []
                    self.screenTitles.append(scoutingType.screens[i].title)
                    self.isCreated.append(false)
                    for k in 0..<scoutingType.screens[i].layout.count{
                        var tagsInRow : [Int] = []
                        var itemsInRow : [String] = []
                        var namesInRow : [String] = []
                        var choicesInRow : [[String]] = []
                        for j in 0..<scoutingType.screens[i].layout[k].count{
                            let type = scoutingType.screens[i].layout[k][j].type
                            let name = scoutingType.screens[i].layout[k][j].name
                            let choice = scoutingType.screens[i].layout[k][j].choices ?? []
                            itemsInRow.append(type)
                            namesInRow.append(name)
                            choicesInRow.append(choice)
                            tagsInRow.append(itemIndex)
                            itemIndex += 1
                        }
                        items.append(itemsInRow)
                        names.append(namesInRow)
                        choices.append(choicesInRow)
                        indices.append(tagsInRow)
                    }
                    self.listOfTags.append(indices)
                    self.listOfItemsType.append(items)
                    self.listOfItemsName.append(names)
                    self.listOfToggleTitles.append(choices)
                }
            }
            self.screenTitles.append("QR Code")
            self.screenTitle.text = self.screenTitles[0]
            self.scoutingView.register(ScoutingScreenCell.self, forCellWithReuseIdentifier: "scoutingCell")
            self.scoutingView.register(QRImageCell.self, forCellWithReuseIdentifier: self.QRImageCellID)
            self.scoutingView.dataSource = self
            self.scoutingView.delegate = self
            }
            
        
            
        scoutingView.isPagingEnabled = true
        self.progressBar.isEnabled = false
        selectedTeam = Int(teamNumber) ?? 0
        selectedBoard = boardName
        
        if let eventKey = UserDefaults.standard.object(forKey: "eventKey") as? String{
           if let scoutName = UserDefaults.standard.object(forKey: "scout") as? String {
                selectedKey = eventKey
                selectedScout = scoutName
                encodedData = updateEncodedData()
            } 
        }
        
        //Make sure the initial time stamp is 0 before taking any inputs
        timeStamp = 0
    }
    
    func formatTitle(string : String, currentTeam : [String], opposingTeam : [String]) -> String{
        var arr = string.components(separatedBy: "_")
        
        var formated = ""
        
        for i in 0..<arr.count{
            if (arr[i].prefix(1) == "A" && (Int(arr[i].suffix(1)) != nil)){
                let index = Int(arr[i].suffix(1)) ?? 0
                arr[i] = currentTeam[index - 1]
            } else if (arr[i].prefix(1) == "O" && (Int(arr[i].suffix(1)) != nil)){
                let index = Int(arr[i].suffix(1)) ?? 0
                arr[i] = opposingTeam[index - 1]
            }
            formated += (arr[i] + " ")
        }
        
        
        return formated
    }
    
    func formatChoices(string : [String], currentTeam : [String], opposingTeam : [String]) -> [String]{
        var mutatedArr = string
        
        for i in 0..<string.count{
            if (string[i].prefix(1) == "A" && Int(string[i].suffix(1)) != nil){
                let index = Int(string[i].suffix(1)) ?? 0
                mutatedArr[i] = currentTeam[index - 1]
            } else {
                mutatedArr[i] = string[i]
            }
            
        }
        
        return mutatedArr
    }
    
    func updateEncodedData() -> String{
          let data = (selectedKey + "_" + separatedMatchNumber + ":" + teamNumber + ":" + selectedScout + ":" + boardName + ":" + String(format:"%02X", Int(NSDate().timeIntervalSince1970)) + ":" + encodedDataPoints +  ":" + comment)
          return data
      }
      
      func encodeData(dataPoint : DataPoint){
          DataPoints.append(dataPoint)
          let encoder = Encoder()
          encoder.dataPointToString(dp: dataPoint)
          encodedData = updateEncodedData()
    }
    
    func getLayoutForScreen(completed : @escaping () -> ()){
        do {
            let url = Bundle.main.url(forResource: "layout", withExtension: "json")
            let jsonData = try Data(contentsOf : url!)
            screenLayout = try JSONDecoder().decode(ScoutingScreenLayout.self, from : jsonData)
            
            DispatchQueue.main.async{
                completed()
            }
            
        } catch let err{
            print(err)
        }
    }
    
    //UI Configurations
    func configureButtons(){
        StartTimerButton.layer.cornerRadius = 5
        
        StartTimerButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        PauseButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        PlayButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        CommentButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        UndoButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        
    }
    
    func configureProgressBar(){
        self.progressBar.value = 0
        self.progressBar.tintColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
        self.progressBar.addTarget(self, action: #selector(pauseTimerOnPBSelection(sender:)), for: .touchDown)
        self.progressBar.addTarget(self, action: #selector(updateTimerOnPBDrag(sender:)), for: .touchDragInside)
        self.progressBar.addTarget(self, action: #selector(progressBarReleased(sender:)), for: .touchUpInside)
    }
    
    @objc func progressBarReleased(sender : UISlider){
        self.totalProgress = sender.value
    }
    
    @objc func updateTimerOnPBDrag(sender : UISlider){
        self.totalProgress = sender.value
        updateTimer()
    }
    
    @objc func pauseTimerOnPBSelection(sender : UISlider){
        self.progressBarTimer.invalidate()
    }
    
    func createLabels(x : Double, y : Double, width : Double, height : Double, fontSize : CGFloat, text : String) -> UILabel{
        let label = UILabel(frame : CGRect(x : x, y : y, width : width, height : height))
        label.font = label.font.withSize(fontSize)
        label.textAlignment = .left
        
        switch (text.prefix(1)){
        case "B":
            label.textColor = UIColor.blue
        case "R":
        label.textColor = UIColor.red
        default :
            label.textColor = UIColor.black
        }
        
        return label
    }
    
    func createIcon(x : Double, y : Double, width : Double, height : Double, iconName : String) -> UIImageView{
        let icon = UIImageView(frame : CGRect(x : x, y : y, width : width, height : height))
        icon.image = UIImage(named : iconName)
        icon.contentMode = .scaleAspectFit
        return icon
    }
    
    func createNavBarView() -> UIView{
        let view = UIView(frame : CGRect(x : 0.0, y : 0.0, width: 341, height : 34))
        let iconsWidth = 34.0
        let spacing = 2.5
        var startingX = 0.0
        let listOfTexts = [matchNumber, boardName, teamNumber, String(timeOnStart)]
        let listOfLabelWidth = [50, 30.0, 50.0, 35.0]
        let listOfIconNames = ["layers2", "paste", "users", "timer"]
        for i in 0..<listOfTexts.count{
            let label = self.createLabels(x: startingX + iconsWidth + spacing, y: 0.0, width: listOfLabelWidth[i], height: 34, fontSize: 18, text : listOfTexts[i])
            label.text = listOfTexts[i]
            view.addSubview(self.createIcon(x: startingX, y: 3.5, width: iconsWidth, height: 28, iconName: listOfIconNames[i]))
            
            if(i == 3){
                label.textColor = UIColor(red:0.80, green:0.60, blue:0.00, alpha:1.00)
            }
            
            view.addSubview(label)
            startingX += iconsWidth + listOfLabelWidth[i] + spacing * 3.0
            self.listOfLabels.append(label)
        }
        return view
    }
    
    private func setUpNavigationBar(){
    navigationItem.titleView = self.navBarView
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView : self.backButton)
    }
    
    lazy var backButton : UIButton = {
           let button = UIButton(frame : CGRect(x : 0, y : 0, width : 5, height : 34))
           button.tag = 6
           button.setImage(UIImage(named : "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
           return button
       }()
    
    func updateTimer(){
        timeStamp = 165 * self.totalProgress
        if(165 * self.totalProgress < 15.0){
            let time = 15 - round(165 * self.totalProgress)
            var timeLeft = String(time)
            
            switch timeLeft.count{
            case 5:
                timeLeft = String(timeLeft.prefix(3))
            case 4:
                timeLeft = "0" + String(timeLeft.prefix(2))
            case 3:
                timeLeft = "00" + String(timeLeft.prefix(1))
            default :
                break
            }
            
            self.listOfLabels[3].text = timeLeft
            self.listOfLabels[3].textColor = UIColor(red:0.80, green:0.60, blue:0.00, alpha:1.00)
            
        } else if (165 * self.totalProgress >= 15 && 165 * self.totalProgress < 135.0){
            let time = 135 - round(165 * self.totalProgress)
            var timeLeft = String(time)
            
            switch timeLeft.count{
            case 5:
                timeLeft = String(timeLeft.prefix(3))
            case 4:
                timeLeft = "0" + String(timeLeft.prefix(2))
            case 3:
                timeLeft = "00" + String(timeLeft.prefix(1))
            default :
                break
            }
            self.listOfLabels[3].text = timeLeft
            self.listOfLabels[3].textColor = UIColor.systemGreen
        } else if (165 * self.totalProgress >= 135){
            let time = 165 - round(165 * self.totalProgress)
            var timeLeft = String(time)
            
            switch timeLeft.count{
            case 5:
                timeLeft = String(timeLeft.prefix(3))
            case 4:
                timeLeft = "0" + String(timeLeft.prefix(2))
            case 3:
                timeLeft = "00" + String(timeLeft.prefix(1))
            default :
                break
            }
            
            self.listOfLabels[3].text = timeLeft
            self.listOfLabels[3].textColor = UIColor.red
        }
    }
    
        @objc func clickHandler(sender : UIButton){
            if(sender.tag == 1){
                StartTimerButton.isHidden = true
                PauseButton.isHidden = false
                PlayButton.isHidden = true
                UndoButton.isHidden = false
                
                self.progressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){
                (timer) in
                guard self.progress.isFinished == false else {
                    timer.invalidate()
                    return
                }
                    self.progress.completedUnitCount += 1
                    self.totalProgress = Float(self.progress.fractionCompleted)
                    self.updateTimer()
                    self.progressBar.value = self.totalProgress
                }
                
                for i in 0..<listOfButtonsOnScreen.count{
                    listOfButtonsOnScreen[i].button.isEnabled = true
                    listOfButtonsOnScreen[i].button.setTitleColor(UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00), for: .normal)
                }
                
                for i in 0..<listOfSwitchesOnScreen.count{
                    listOfSwitchesOnScreen[i].switchButton.isEnabled = true
                    listOfSwitchesOnScreen[i].switchButton.setTitleColor(UIColor(red: 0.35, green: 0.76, blue: 0.00, alpha: 1.00), for: .normal)
                }
                
                for i in 0..<listOfCheckBoxesOnScreen.count{
                    listOfCheckBoxesOnScreen[i].label.textColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                }
                
                isTimerEnabled = true
                
            } else if (sender.tag == 2){
                PlayButton.isHidden = false
                PauseButton.isHidden = true
                
                self.progressBar.isEnabled = true
                
                self.progressBarTimer.invalidate()
                self.totalProgress = self.progressBar.value
                self.progressBar.value = self.totalProgress
            } else if (sender.tag == 3){
                PlayButton.isHidden = true
                PauseButton.isHidden = false
                
                self.progressBar.isEnabled = false
                
                self.progressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){
                    (timer) in
                    guard self.totalProgress <= 1 else {
                        timer.invalidate()
                        return
                    }
                    self.totalProgress = (self.totalProgress * 16500 + 1) / 16500
                    self.updateTimer()
                    self.progressBar.value = self.totalProgress
                    }
                
                
            } else if (sender.tag == 4){
               //Undo button
                if (DataPoints.count >= 1){
                let removeItemTag = DataPoints[DataPoints.count - 1].type_index
                let removeItemValue = DataPoints[DataPoints.count - 1].value
                var foundItem = false
                DataPoints.remove(at: DataPoints.count - 1)
                encodedDataPoints.removeLast(4)
                encodedData = updateEncodedData()
                for i in 0..<listOfButtonsOnScreen.count{
                    if (removeItemTag == listOfButtonsOnScreen[i].tag){
                        listOfButtonsOnScreen[i].counter -= 1
                        listOfButtonsOnScreen[i].counterField.text = String(listOfButtonsOnScreen[i].counter)
                        foundItem = true
                        break
                    }
                }
                for i in 0..<listOfSwitchesOnScreen.count{
                    if (foundItem){
                        break
                    }
                    if (removeItemTag == listOfSwitchesOnScreen[i].tag){
                        if (removeItemValue == 0){
                            listOfSwitchesOnScreen[i].value = 1
                            listOfSwitchesOnScreen[i].switchButton.backgroundColor = UIColor.red
                            listOfSwitchesOnScreen[i].switchButton.setTitleColor(UIColor.white, for: .normal)
                            
                        } else if (removeItemValue == 1){
                            listOfSwitchesOnScreen[i].value = 0
                            listOfSwitchesOnScreen[i].switchButton.backgroundColor = UIColor.systemGray5
                            listOfSwitchesOnScreen[i].switchButton.setTitleColor(UIColor.green, for: .normal)
                        }
                    }
                }
                
                
                for i in 0..<listOfMultiToggleFieldScreen.count{
                    if (foundItem){
                        break
                    }
                    if (removeItemTag == listOfMultiToggleFieldScreen[i].tag){
                        listOfMultiToggleFieldScreen[i].value = prevToggleValue
                        listOfMultiToggleFieldScreen[i].setUpToggleField()
                    }
                    if (removeItemTag == 15){
                        identicalToggles[0].value = prevToggleValue
                        identicalToggles[0].setUpToggleField()
                    } else if (removeItemTag == 7){
                        identicalToggles[1].value = prevToggleValue
                        identicalToggles[1].setUpToggleField()
                    }
                }
                    
                    for i in 0..<listOfCheckBoxesOnScreen.count{
                        if (removeItemTag == listOfCheckBoxesOnScreen[i].tag){
                            if (removeItemValue == 1){
                                listOfCheckBoxesOnScreen[i].checkBox.backgroundColor = UIColor.systemGray5
                                listOfCheckBoxesOnScreen[i].value = 0
                            } else if (removeItemValue == 0){
                                listOfCheckBoxesOnScreen[i].checkBox.backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
                                listOfCheckBoxesOnScreen[i].value = 1
                            }
                        }
                    }
                }
            }
            else if (sender.tag == 5){
                let alert = UIAlertController(title: "Comment", message: "Add a comment", preferredStyle: .alert)

                alert.addTextField{
                    (UITextField) in UITextField.placeholder = "Enter comment"
                    UITextField.text = comment
                }

                let getComment = UIAlertAction(title: "OK", style: .default){
                    [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    comment = textField!.text ?? ""
                    encodedData = self.updateEncodedData()
                }

                let cancel = UIAlertAction(title : "Cancel", style : .cancel, handler: nil)

                alert.addAction(getComment)
                alert.addAction(cancel)

                self.present(alert, animated : true, completion : nil)
            } else if (sender.tag == 6){
                let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainController") as? ViewController)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
}

extension ScoutingActivity : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width : collectionView.bounds.width, height : collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.screenTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row < self.screenTitles.count - 1){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoutingCell", for: indexPath) as? ScoutingScreenCell
            cell?.listOfItemsType = self.listOfItemsType[indexPath.row]
            cell?.listOfItemsName = self.listOfItemsName[indexPath.row]
            cell?.listOfToggleTitles = self.listOfToggleTitles[indexPath.row]
            cell?.listOfItemsTag = self.listOfTags[indexPath.row]
            cell?.index = indexPath.row
            return cell!
        } else {
            let QRcell = collectionView.dequeueReusableCell(withReuseIdentifier: self.QRImageCellID, for: indexPath) as? QRImageCell
            QRcell?.setUpQRImage()
            if (QRImageCellMade.count < 1){
                QRImageCellMade.append(QRcell!)
            }
            
            
            return QRcell!
        }
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: scoutingView.contentOffset, size: scoutingView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = scoutingView.indexPathForItem(at: visiblePoint)
        if (visibleIndexPath?[1] ?? 0 == 3){
            if (QRImageCellMade.count == 1){
                QRImageCellMade[0].setUpQRImage()
            }
        }
        screenTitle.text = screenTitles[visibleIndexPath?.item ?? 0]
    }
}
