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
public var DataPoints = [DataPoint]()
var entry = Entry(match: "", team: 0, scout: "", board: "", timeStamp: Float(Date().timeIntervalSinceReferenceDate), data_point: [])
var screenLayout : ScoutingScreenLayout!

private var selectedTeam = 0
private var selectedBoard = ""
class ScoutingActivity : UIViewController{
    let navBarWidth = UIScreen.main.bounds.width
    let navBarHeight = Double(UIScreen.main.bounds.height * 0.1)
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    let Ymultiplier = 1.325
    let heightMultiplier = 0.6
    let buttonsWidth = UIScreen.main.bounds.width * 0.15
    var comment = ""
    
    var listOfLabels : [UILabel] = []
    var navBarView : UIView!
    var itemTags = 0
    var listOfTags : [[Int]] = []
    let images = ["timer", "team", "paste", "layers2"]
    var screenTitles : [String] = []
    var currentScreenIndex = 0
    var screenIndex = 0
    var tempScreenIndex = 0
    var movedForward = false
    var movedBackwards = false
    
    var matchNumber = ""
    var teamNumber = ""
    var boardName = ""
    var timeOnStart = "015"
    
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
    var listOfItemsType : [[[String]]] = []
    var listOfItemsName : [[[String]]] = []
    var listOfToggleTitles : [[[[String]]]] = []
    var QRImageCellID = "QRImageCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarView = self.createNavBarView()
        setUpNavigationBar()
        configureButtons()
        configureProgressBar()
        
        var itemIndex = 0
        
        getLayoutForScreen{
            for i in 0..<screenLayout.robot_scout.screens.count{
                var indices : [Int] = []
                var items : [[String]] = []
                var names : [[String]] = []
                var choices : [[[String]]] = []
                self.screenTitles.append(screenLayout.robot_scout.screens[i].title)
                for k in 0..<screenLayout.robot_scout.screens[i].layout.count{
                    var itemsInRow : [String] = []
                    var namesInRow : [String] = []
                    var choicesInRow : [[String]] = []
                    for j in 0..<screenLayout.robot_scout.screens[i].layout[k].count{
                        let type = screenLayout.robot_scout.screens[i].layout[k][j].type
                        let name = screenLayout.robot_scout.screens[i].layout[k][j].name
                        let choice = screenLayout.robot_scout.screens[i].layout[k][j].choices ?? []
                        itemsInRow.append(type)
                        namesInRow.append(name)
                        choicesInRow.append(choice)
                        indices.append(itemIndex)
                        itemIndex += 1
                    }
                    items.append(itemsInRow)
                    names.append(namesInRow)
                    choices.append(choicesInRow)
                }
                self.listOfTags.append(indices)
                self.listOfItemsType.append(items)
                self.listOfItemsName.append(names)
                self.listOfToggleTitles.append(choices)
            }
            print(self.listOfToggleTitles)
            self.screenTitles.append("QR Code")
            self.scoutingView.register(ScoutingScreenCell.self, forCellWithReuseIdentifier: "scoutingCell")
            self.scoutingView.register(QRImage.self, forCellWithReuseIdentifier: self.QRImageCellID)
            self.scoutingView.dataSource = self
            self.scoutingView.delegate = self
        }
        screenTitle.text = "Auto"
        scoutingView.isPagingEnabled = true
        self.progressBar.isEnabled = false
        selectedTeam = Int(self.teamNumber) ?? 0
        selectedBoard = self.boardName
        //Make sure the initial time stamp is 0 before taking any inputs
        UserDefaults.standard.set(0.0, forKey: "timeStamp")
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
    
    func encodeData(dataPoints : [DataPoint]){
        DataPoints.append(contentsOf: dataPoints)
        if let eventKey = UserDefaults.standard.object(forKey: "match") as? String, let scoutName = UserDefaults.standard.object(forKey: "scout") as? String {
            entry = Entry.init(match: eventKey , team: selectedTeam, scout: scoutName, board: selectedBoard, timeStamp: Float(Date().timeIntervalSince1970), data_point: DataPoints)
            
        }
    }
    
    @objc func progressBarReleased(sender : UISlider){
        self.totalProgress = sender.value
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
        let listOfTexts = [self.matchNumber, self.boardName, self.teamNumber, String(self.timeOnStart)]
        let listOfLabelWidth = [30.0, 30.0, 50.0, 35.0]
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
        UserDefaults.standard.set(165 * self.totalProgress, forKey: "timeStamp")
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
                
                self.progressBar.isEnabled = true
                
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
                
            } else if (sender.tag == 2){
                PlayButton.isHidden = false
                PauseButton.isHidden = true
                
                self.progressBarTimer.invalidate()
                self.totalProgress = self.progressBar.value
                self.progressBar.value = self.totalProgress
            } else if (sender.tag == 3){
                PlayButton.isHidden = true
                PauseButton.isHidden = false
                
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
               
            }
            else if (sender.tag == 5){
                let alert = UIAlertController(title: "Comment", message: "Add a comment", preferredStyle: .alert)

                alert.addTextField{
                    (UITextField) in UITextField.placeholder = "Enter comment"
                    UITextField.text = self.comment
                }

                let getComment = UIAlertAction(title: "OK", style: .default){
                    [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    self.comment = textField!.text!
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row != 3){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoutingCell", for: indexPath) as? ScoutingScreenCell
            cell?.listOfItemsType = self.listOfItemsType[indexPath.row]
            cell?.listOfItemsName = self.listOfItemsName[indexPath.row]
            cell?.listOfToggleTitles = self.listOfToggleTitles[indexPath.row]
            cell?.setUpScoutingScreen()
            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.QRImageCellID, for: indexPath) as? QRImage
            return cell!
        }
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: scoutingView.contentOffset, size: scoutingView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = scoutingView.indexPathForItem(at: visiblePoint)
        screenTitle.text = screenTitles[visibleIndexPath?.item ?? 0]
    }
}
