//
//  ViewController1.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit

class ScoutingScreen : UIViewController {

    var displayText : String?
    var index : Int?
    
    //Need to fix this, view height is Screen size * 0.9, not 0.1 (It's gonna be annoying)
    let navBarWidth = UIScreen.main.bounds.width
    let navBarHeight = Double(UIScreen.main.bounds.height * 0.1)
    
    let Ymultiplier = 0.5
    let heightMultiplier = 0.6
    let buttonsWidth = UIScreen.main.bounds.width * 0.15
    var comment = ""
    
    var matchNumber : String?
    var boardName : String?
    var teamNumber : String?
    
    //Get info of json layout
    var numberOfItemsInRow : [Int] = []
    var typeOfItemsInRow : [[String]] = []
    var nameOfItemsInRow : [[String]] = []
    var itemPositions : [[Int]] = []
    var numberOfRows = 0
    
    let scoutingViewHeight = Double(UIScreen.main.bounds.height) * 0.78
    let scoutingViewWidth = Double(UIScreen.main.bounds.width) * 0.96
    
    //Current multiplier is height multiplier + Y multiplier (0.6 + 0.5)
    var startingY = Double(UIScreen.main.bounds.height * 0.1) * 1.2
    
    
    //QRCode entries
    var colorChanged = false
    var counter : [[Int]]  = []
    //UIs
    
    //Another way to identify which button you are clicking is to disregard the rows and shit, just set the tags of the buttons from 0 to which ever number you can
 
    func createScoutingRows(y : Double, currentRow : Int) -> UIView{
        let rowHeight = Double(UIScreen.main.bounds.height) * 0.77 / Double(self.numberOfRows)
        let rowWidth = self.scoutingViewWidth
        
        let scoutingRowView = UIView(frame : CGRect(x : Double(self.navBarWidth) * 0.02, y : y , width: rowWidth, height : rowHeight))
        var startingX = 0.0
        
        let itemWidth = rowWidth / Double(self.numberOfItemsInRow[currentRow])
        
        let spacing = itemWidth * 0.01
        let itemHeight = rowHeight
        
        var itemPositions : [Int] = []
        var counter : [Int] = []
        
        for i in 0..<self.numberOfItemsInRow[currentRow]{
            
            if(self.typeOfItemsInRow[currentRow][i] == "Button"){
                scoutingRowView.addSubview(createScoutingButton(x: startingX, width: itemWidth * 0.99, height: itemHeight, currentRow: currentRow, position: i))
                itemPositions.append(i)
                counter.append(0)
            } else if (self.typeOfItemsInRow[currentRow][i] == "Switch"){
                scoutingRowView.addSubview(createScoutingSwitch(x: startingX, width: itemWidth * 0.99, height: itemHeight))
            }
            startingX += (itemWidth + spacing)
            }
        self.itemPositions.append(itemPositions)
        self.counter.append(counter)
        return scoutingRowView
    }
    
    func createScoutingButton(x : Double, width : Double, height : Double, currentRow : Int, position : Int) -> UIButton{
        let button = Button()
        
        button.frame = CGRect(x : x, y : 0, width : width, height : height)
        button.setTitle("Button", for: .normal)
        button.row = currentRow
        button.position = position
        button.backgroundColor = UIColor.systemGray5
        button.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
        return button
    }
    
    func createScoutingSwitch(x : Double, width : Double, height : Double) -> UIButton{
        let Switch = UIButton(frame : CGRect(x : x, y : 0, width : width, height : height))
        Switch.setTitle("Switch", for: .normal)
        Switch.tag = 2
        Switch.backgroundColor = UIColor.systemGray5
        Switch.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
        return Switch
    }
    
    @objc func collectQRCodeData(sender : AnyObject){
        let button = sender as! Button
        for i in 0..<self.itemPositions.count{
            for k in 0..<self.itemPositions[i].count{
                if(button.row == i && button.position == k){
                    self.counter[i][k] += 1
                }
            }
        }
        print(self.counter)
//        print(button.row!)
//        print(button.position!)
        
    }

//    else if (sender.tag == 2){
//    if !self.colorChanged{
//        sender.backgroundColor = UIColor.blue
//        self.colorChanged = true
//    } else {
//        sender.backgroundColor = UIColor.systemGray5
//        self.colorChanged = false
//    }
    
    lazy var screenSeparator : UIView = {
        let View = UIView(frame : CGRect(x : 0.0, y : Double(self.navBarHeight) * self.Ymultiplier * 0.95, width : Double(self.navBarWidth), height : 1.0))
        View.backgroundColor = UIColor.systemGray6
        return View
    }()
    
    lazy var screenTitle : UILabel = {
        let label = UILabel(frame : CGRect(x : Double(self.navBarWidth) * 0.025 , y : Double(self.navBarHeight) * self.Ymultiplier, width : Double(self.navBarWidth) * 0.5, height : Double(self.navBarHeight) * self.heightMultiplier))
        label.font = label.font.withSize(CGFloat(self.navBarHeight * self.heightMultiplier * 0.75))
        label.textAlignment = .left
        return label
    }()
    
    lazy var StartTimerButton : UIButton = {
           let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.navBarWidth * 0.55), y : Double(self.navBarHeight) * self.Ymultiplier * 1.1, width : Double(self.buttonsWidth * 2), height : Double(self.navBarHeight) * self.heightMultiplier * 0.9)
           button.tag = 1
           button.setTitle("Start Timer", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(20)
           button.setTitleColor(UIColor.white, for: .normal)
           button.backgroundColor = UIColor.systemBlue
           button.layer.cornerRadius = 5
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
          return button
       }()

       lazy var PauseButton : UIButton = {
           let button = UIButton(type : .system)
         button.frame = CGRect(x : Double(self.navBarWidth * 0.55), y : Double(navBarHeight) * self.Ymultiplier, width : Double(self.buttonsWidth), height : Double(self.navBarHeight) * self.heightMultiplier)
           button.tag = 2
           button.setImage(UIImage(named : "pause"), for: .normal)
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        button.isHidden = true
           return button
       }()

       lazy var PlayButton : UIButton = {
           let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.navBarWidth * 0.55), y : Double(navBarHeight) * self.Ymultiplier, width : Double(self.buttonsWidth), height : Double(self.navBarHeight) * self.heightMultiplier)
           button.tag = 3
           button.setImage(UIImage(named : "play"), for: .normal)
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
           button.isHidden = true
           return button
       }()

       lazy var undoButton : UIButton = {
           let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.navBarWidth * 0.7), y : Double(navBarHeight) * self.Ymultiplier, width : Double(self.buttonsWidth), height : Double(self.navBarHeight) * self.heightMultiplier)
           button.tag = 4
           button.setImage(UIImage(named : "undo"), for: .normal)
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
           button.isHidden = true
           return button
       }()

       lazy var commentButton : UIButton = {
           let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.navBarWidth * 0.85), y : Double(navBarHeight) * self.Ymultiplier, width : Double(self.buttonsWidth), height : Double(self.navBarHeight) * self.heightMultiplier)
           button.tag = 5
           button.setImage(UIImage(named : "comments"), for: .normal)
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
           return button
       }()

    @objc func clickHandler(sender : UIButton){
        let scoutingActivity = UIStoryboard(name : "Main", bundle: nil)
        let scoutingVC = scoutingActivity.instantiateViewController(withIdentifier: "ScoutingActivity") as! ScoutingActivity
        if(sender.tag == 1){
            StartTimerButton.isHidden = true
            scoutingVC.hideStartTimer = true
            scoutingVC.hidePauseButton = false
            scoutingVC.hideUndoButton = false
            scoutingVC.currentScreenIndex = self.index!
            
            scoutingVC.matchNumber = self.matchNumber!
            scoutingVC.boardName = self.boardName!
            scoutingVC.teamNumber = self.teamNumber!
            
            self.navigationController?.setViewControllers([scoutingVC], animated: false)
            
        } else if (sender.tag == 2){
            scoutingVC.hidePlayButton = false
            scoutingVC.hidePauseButton = true
            scoutingVC.hideStartTimer = true
            scoutingVC.hideUndoButton = false
            scoutingVC.currentScreenIndex = self.index!
            
            scoutingVC.matchNumber = self.matchNumber!
            scoutingVC.boardName = self.boardName!
            scoutingVC.teamNumber = self.teamNumber!
            
            
            self.navigationController?.setViewControllers([scoutingVC], animated: false)
        } else if (sender.tag == 3){
            scoutingVC.hidePlayButton = true
            scoutingVC.hidePauseButton = false
            scoutingVC.hideStartTimer = true
            scoutingVC.hideUndoButton = false
            scoutingVC.currentScreenIndex = self.index!
            
            scoutingVC.matchNumber = self.matchNumber!
            scoutingVC.boardName = self.boardName!
            scoutingVC.teamNumber = self.teamNumber!
            
            self.navigationController?.setViewControllers([scoutingVC], animated: false)
        } else if (sender.tag == 5){
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
        }
    }
    
    //Configure UI for scouting activity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenTitle.text = self.displayText
        view.addSubview(screenTitle)
        view.addSubview(StartTimerButton)
        view.addSubview(PauseButton)
        view.addSubview(PlayButton)
        view.addSubview(commentButton)
        view.addSubview(undoButton)
        view.addSubview(screenSeparator)
        
        for i in 0..<self.numberOfRows{
            view.addSubview(self.createScoutingRows(y: self.startingY, currentRow: i))
            startingY += (self.scoutingViewHeight) / Double(self.numberOfRows)
        }
        
        print(self.counter)
    }
}
