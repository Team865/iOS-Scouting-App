//
//  ScoutingActivity.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/22/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class ScoutingActivity : UIViewController {
    var listOfInputControls : [InputControl] = []
    var matchEntry = MatchEntry()
    var qrEntry = Entry()
    var parser = Parser()
    var listOfFieldData : [FieldData] = []
    let dataTimer = DataTimer()
    var comment = ""
    
    var idsAndKeys = IDsAndKeys()
    
    let navBarWidth = UIScreen.main.bounds.width
    let navBarHeight = Double(UIScreen.main.bounds.height * 0.1)
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    let Ymultiplier = 1.325
    let heightMultiplier = 0.6
    let buttonsWidth = UIScreen.main.bounds.width * 0.15
    
    var listOfLabels : [UILabel] = []
    var itemTags = 0
    let images = ["timer", "team", "paste", "layers2"]
    
    var screenTitles : [String] = []
    var isCreated = false
    var numberOfScreens = 4
    
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
    
    //ScoutingScreen variables
    var QRImageCellMade : [QRImageCell] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        configureButtons()
        configureProgressBar()
        configureScoutingView()
        
        self.qrEntry.setUpEntry(selectedEntry: self.matchEntry)
        
        self.matchEntry.scoutedData = self.qrEntry.getQRData()   
    }
    
    //UI Configurations
    func configureScoutingView(){
        if (self.matchEntry.board.suffix(1) == "X"){
            self.numberOfScreens = 5
        }
        self.parser.scoutingActivity = self
        parser.getLayoutForScreenWithBoard(board: self.matchEntry.board, index: 0, currentTeams: [], opposingTeams: [], scoutingActivity: self)
        self.screenTitles = parser.getScreenTitles()
        self.screenTitles.append("QR Code")
        screenTitle.text = self.screenTitles[0]
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
        let timeOnStart = "015"
        let listOfTexts = ["M" + (self.matchEntry.matchNumber), self.matchEntry.board, self.matchEntry.teamNumber, timeOnStart]
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
            StartTimerButton.isHidden = true
            PauseButton.isHidden = false
            PlayButton.isHidden = true
            UndoButton.isHidden = false
            
            self.dataTimer.startTimer(scoutingActivity: self)
            
            self.matchEntry.isScouted = true
            
            
        } else if (sender.tag == 2){
            PlayButton.isHidden = false
            PauseButton.isHidden = true
            
            self.dataTimer.pauseTimer(scoutingActivity: self)
        } else if (sender.tag == 3){
            PlayButton.isHidden = true
            PauseButton.isHidden = false
            
            self.dataTimer.resumeTimer(scoutingActivity: self)
            
        } else if (sender.tag == 4){
            //Undo button
        }
        else if (sender.tag == 5){
            let alert = UIAlertController(title: "Comment", message: "Add a comment", preferredStyle: .alert)
            
            alert.addTextField{
                (UITextField) in UITextField.placeholder = "Enter comment"
                UITextField.text = self.comment
                self.qrEntry.comment = self.comment
                self.matchEntry.scoutedData = self.qrEntry.getQRData()
            }
            
            let getComment = UIAlertAction(title: "OK", style: .default){
                [weak alert] (_) in
                let textField = alert?.textFields![0]
                self.comment = textField!.text ?? ""
                if (self.QRImageCellMade.count == 1){
                    self.QRImageCellMade[0].setUpQRImage()
                }
            }
            
            let cancel = UIAlertAction(title : "Cancel", style : .cancel, handler: nil)
            
            alert.addAction(getComment)
            alert.addAction(cancel)
            
            self.present(alert, animated : true, completion : nil)
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
        return self.numberOfScreens
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row < self.numberOfScreens - 1){
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
