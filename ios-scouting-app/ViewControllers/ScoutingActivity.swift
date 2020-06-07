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
    
    var listOfLabels : [UILabel] = []
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
    var progressBarTimer : Timer!
    var totalProgress : Float = 0
    let progress = Progress(totalUnitCount: 15000)
    
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
        self.screenTitles = parser.getScreenTitles()
        self.screenTitles.append("QR Code")
        screenTitle.text = self.screenTitles[0]
        screenTitle.font = screenTitle.font.withSize(UIScreen.main.bounds.height * 0.035)
        
        //Configure Scouting view UI
        self.scoutingView.isPagingEnabled = true
        self.scoutingView.register(ScoutingScreenCell.self, forCellWithReuseIdentifier: self.idsAndKeys.scoutingCellsID)
        self.scoutingView.register(QRImageCell.self, forCellWithReuseIdentifier: self.idsAndKeys.QRCellID)
        self.scoutingView.dataSource = self
        self.scoutingView.delegate = self
    }
    
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
        self.progressBar.isEnabled = false
    }
    
    func createTextView(text : String) -> UILabel{
        let textView = UILabel()
        textView.textAlignment = .center
        textView.isUserInteractionEnabled = false
        textView.text = text
        textView.font = textView.font.withSize((UIScreen.main.bounds.height * 0.0175))
        switch (text.prefix(1)){
        case "B":
            textView.textColor = UIColor.blue
        case "R":
            textView.textColor = UIColor.red
        default :
            textView.textColor = UIColor.black
        }
        
        return textView
    }
    
    func createIcon(iconName : String) -> UIImageView{
        let icon = UIImageView()
        icon.image = UIImage(named : iconName)
        icon.contentMode = .scaleAspectFit
        return icon
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
        
        let listOfIconNames = ["layers2", "paste", "users", "timer"]
        
        for i in 0..<listOfTexts.count{
            let icon = self.createIcon(iconName : listOfIconNames[i])
            
            view.addArrangedSubview(icon)
            
            let textView = self.createTextView(text : listOfTexts[i])
            
            if (i == listOfTexts.count - 1){
                textView.textColor = UIColor(red:0.80, green:0.60, blue:0.00, alpha:1.00)
            }
            
            view.addArrangedSubview(textView)
            
            self.listOfLabels.append(textView)
            
            
        }
        
        return view
    }
    
    lazy var backButton : UIButton = {
        let button = UIButton(frame : CGRect(x : 0, y : 0, width : 5, height : 34))
        button.tag = 6
        button.setImage(UIImage(named : "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        return button
    }()
    
    private func setUpNavigationBar(){
        navigationItem.titleView = self.createNavBarView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView : self.backButton)
    }
    
    @objc func progressBarReleased(sender : UISlider){
        self.totalProgress = sender.value
    }
    
    @objc func updateTimerOnPBDrag(sender : UISlider){
        self.totalProgress = sender.value
        self.dataTimer.updateTimer(scoutingActivity: self)
    }
    
    @objc func pauseTimerOnPBSelection(sender : UISlider){
        self.progressBarTimer.invalidate()
    }
    
    @objc func clickHandler(sender : UIButton){
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
            vc.selectedMatchEntry = self.matchEntry
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
            self.scoutingView.reloadData()
        }
        screenTitle.text = screenTitles[visibleIndexPath?.item ?? 0]
        
    }
}
