//
//  ScoutingActivity.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/22/20.
//  Copyright © 2020 Warp7. All rights reserved.
//
import Foundation
import AudioToolbox
import AVFoundation
import UIKit

class ScoutingActivity : UIViewController {
    var listOfInputControls : [InputControl] = []
    var matchEntry = MatchEntry()
    var qrEntry = Entry()
    var parser = Parser()
    var listOfFieldData : [FieldData] = []
    let dataTimer = DataTimer()
    var coreData = CoreData()
    var comment = ""
    var commentOptions : [FieldData] = []
    var idsAndKeys = IDsAndKeys()
    
    var listOfNavBarElement : [UIButton] = []
    var screenTitles : [String] = []
    
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
    
    
    //ScoutingScreen variables
    var QRImageCellMade : [QRImageCell] = []
    var isStarted = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackgroundVisible(noti:)), name: UIApplication.didEnterBackgroundNotification  , object: nil)
        
        setUpNavigationBar()
        configureButtons()
        configureProgressBar()
        configureScoutingView()
        
        self.qrEntry.setUpEntry(selectedEntry: self.matchEntry)
        self.qrEntry.scoutingActivity = self
        self.matchEntry.scoutedData = self.qrEntry.getQRData()
        
    }
    
    func playSoundOnAction(){
        if (self.coreData.isPlayingSounds()){
            AudioServicesPlaySystemSound(SystemSoundID(1105))
        }
    }
    
    //Background tasks handler
    @objc func pauseWhenBackgroundVisible(noti : Notification){
        if(self.isStarted){
            self.dataTimer.pauseTimer(scoutingActivity: self)
        }
    }
    
    //UI Configurations
    func configureScoutingView(){
        
        //Set up team numbers and layouts
        self.parser.scoutingActivity = self
        let currentTeams = self.matchEntry.teamNumber.components(separatedBy: " ")
        let opposingTeams = self.matchEntry.opposingTeamNumber.components(separatedBy: " ")
        parser.getLayoutForScreenWithBoard(board: self.matchEntry.board, index: 0, currentTeams: currentTeams, opposingTeams: opposingTeams, scoutingActivity: self)
        
        //Get screen titles
        self.scoutingView.isPagingEnabled = true
        self.screenTitles = parser.getScreenTitles()
        self.screenTitles.append("QR Code")
        screenTitle.text = self.screenTitles[0]
        screenTitle.font = screenTitle.font.withSize(UIScreen.main.bounds.height * 0.035)
        
        //Configure Scouting view UI
        //self.scoutingView.isPagingEnabled = true
        self.scoutingView.register(ScoutingScreenCell.self, forCellWithReuseIdentifier: self.idsAndKeys.scoutingCellsID)
        self.scoutingView.register(QRImageCell.self, forCellWithReuseIdentifier: self.idsAndKeys.QRCellID)
        self.scoutingView.dataSource = self
        self.scoutingView.delegate = self
    }
    
    func configureButtons(){
        StartTimerButton.layer.cornerRadius = 5
        StartTimerButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        
        PauseButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        PauseButton.addTarget(self, action: #selector(onHold(sender:)), for: .touchDown)
        PauseButton.addTarget(self, action: #selector(onDrag(sender:)), for: .touchUpOutside)
        
        PlayButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        PlayButton.addTarget(self, action: #selector(onHold(sender:)), for: .touchDown)
        PlayButton.addTarget(self, action: #selector(onDrag(sender:)), for: .touchUpOutside)
        
        CommentButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        CommentButton.addTarget(self, action: #selector(onHold(sender:)), for: .touchDown)
        CommentButton.addTarget(self, action: #selector(onDrag(sender:)), for: .touchUpOutside)
        
        UndoButton.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        UndoButton.addTarget(self, action: #selector(onHold(sender:)), for: .touchDown)
        UndoButton.addTarget(self, action: #selector(onDrag(sender:)), for: .touchUpOutside)
        
    }
    
    func configureProgressBar(){
        self.progressBar.value = 0
        self.progressBar.tintColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
        self.progressBar.addTarget(self, action: #selector(pauseTimerOnPBSelection(sender:)), for: .touchDown)
        self.progressBar.addTarget(self, action: #selector(updateTimerOnPBDrag(sender:)), for: .touchDragInside)
        self.progressBar.isEnabled = false
    }
    
    func createButtons(iconName : String, title : String) -> UIButton{
        let button = UIButton(type : .custom)
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named : iconName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.isEnabled = true
        button.tintColor = UIColor.black
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return button
    }
    
    func createNavBarView() -> UIStackView{
        let view = UIStackView()
        
        self.view.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier : 0.1).isActive = true
        
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 0
        
        var listOfTexts = ["M" + (self.matchEntry.matchNumber), self.matchEntry.board, self.matchEntry.teamNumber, "015"]
        
        if (self.matchEntry.board.suffix(1) == "X"){
            listOfTexts[2] = "ALL"
        }
        
        let listOfIconNames = ["layers", "paste", "users", "timer"]
        
        for i in 0..<listOfTexts.count{
            let button = self.createButtons(iconName: listOfIconNames[i], title: listOfTexts[i])
            
            if (i == 1){
                let color = self.matchEntry.board.prefix(1) == "B" ? UIColor.blue : UIColor.red
                button.setTitleColor(color, for: .normal)
            }
            
            if (i == listOfTexts.count - 1){
                button.setTitleColor(UIColor(red:0.80, green:0.60, blue:0.00, alpha:1.00), for: .normal)
            }
            
            view.addArrangedSubview(button)
            self.listOfNavBarElement.append(button)
        }
        
        return view
    }
    
    lazy var backButton : UIButton = {
        let button = UIButton(frame : CGRect(x : 0, y : 0, width : 5, height : 34))
        button.tag = 6
        button.setImage(UIImage(named : "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(onHold(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(onDrag(sender:)), for: .touchUpOutside)
        return button
    }()
    
    private func setUpNavigationBar(){
        navigationItem.titleView = self.createNavBarView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView : self.backButton)
    }
    
    @objc func updateTimerOnPBDrag(sender : UISlider){
        self.dataTimer.totalProgress = sender.value * 150
        self.dataTimer.updateTimer()
    }
    
    @objc func pauseTimerOnPBSelection(sender : UISlider){
        self.dataTimer.progressBarTimer.invalidate()
    }
    
    @objc func onHold(sender : UIButton){
        sender.darkenBackground()
    }
    
    @objc func onDrag(sender : UIButton){
        sender.backgroundColor = UIColor.white
    }
    
    @objc func clickHandler(sender : UIButton){
        sender.backgroundColor = UIColor.white
        if(sender.tag == 1){
            playSoundOnAction()
            self.dataTimer.startTimer(scoutingActivity: self)
        } else if (sender.tag == 2){
            
            playSoundOnAction()
            self.dataTimer.pauseTimer(scoutingActivity: self)
        } else if (sender.tag == 3){
            playSoundOnAction()
            self.dataTimer.resumeTimer(scoutingActivity: self)
        } else if (sender.tag == 4){
            let dataPoint = self.qrEntry.undo()
            if (dataPoint != nil){
                playSoundOnAction()
            }
            
            updateActivityState()
            
        }
        else if (sender.tag == 5){
            playSoundOnAction()
            let myAlert = CustomAlertController()
            myAlert.scoutingActivity = self
            myAlert.commentOptions = parser.getCommentOptions()
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(myAlert, animated: true, completion: nil)
        } else if (sender.tag == 6){
            let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: self.idsAndKeys.mainController) as? ViewController)!
            self.matchEntry.scoutedData = self.qrEntry.getQRData()
            vc.selectedMatchEntry = self.matchEntry
            
            self.navigationController?.view.layer.add(CATransition().segueFromLeft(), forKey: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateActivityState(){
        let row =  (self.screenTitles.firstIndex(of: self.screenTitle.text ?? "")) ?? self.screenTitles.count - 1
        let indexPath = IndexPath(row: row, section: 0)
        self.scoutingView.reloadItems(at: [indexPath])
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
            let currentTeams = self.matchEntry.teamNumber.components(separatedBy: " ")
            let opposingTeams = self.matchEntry.opposingTeamNumber.components(separatedBy: " ")
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.idsAndKeys.scoutingCellsID, for: indexPath) as? ScoutingScreenCell
            parser.getLayoutForScreenWithBoard(board: self.matchEntry.board, index : indexPath.row, currentTeams: currentTeams, opposingTeams: opposingTeams, scoutingActivity : self)
            cell?.listOfFieldData = parser.listOfFieldData
            cell?.index = indexPath.row
            self.listOfInputControls.append(contentsOf : cell?.listOfInputControl ?? [])
            
            return cell!
        } else {
            let QRcell = collectionView.dequeueReusableCell(withReuseIdentifier: self.idsAndKeys.QRCellID, for: indexPath) as? QRImageCell
            QRcell?.scoutingActivity = self
            QRcell?.setUpQRImage()
            self.QRImageCellMade.append(QRcell!)
            
            return QRcell!
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: scoutingView.contentOffset, size: scoutingView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = scoutingView.indexPathForItem(at: visiblePoint)
        
        if (visibleIndexPath?[1] ?? 0 == (self.screenTitles.count - 1)){
            let row =  (self.screenTitles.count - 1)
            let indexPath = IndexPath(row: row, section: 0)
            self.scoutingView.reloadItems(at: [indexPath])
            self.listOfInputControls.removeAll()
        }
        
        screenTitle.text = screenTitles[visibleIndexPath?.item ?? 0]
        
    }
}
