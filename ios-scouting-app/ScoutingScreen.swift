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
    
    //Need to fix this, view height is Screen size * 0.9, not 0.1 (It's gonna be annoying
    let navBarWidth = UIScreen.main.bounds.width
    let navBarHeight = Double(UIScreen.main.bounds.height * 0.1)
    
    let multiplier = 0.048
    let buttonsWidth = UIScreen.main.bounds.width * 0.15
    var comment = ""
    
    var matchNumber : String?
    var boardName : String?
    var teamNumber : String?
    
    var numberOfItemsInRow : Int?
    var numberOfRows = 0
    
    let scoutingViewHeight = Double(UIScreen.main.bounds.height) * 0.855
    let scoutingViewWidth = Double(UIScreen.main.bounds.width) * 0.96
    
    var startingY = Double(UIScreen.main.bounds.height * 0.1) * 0.45
    
    func createScoutingRows(y : Double, color : UIColor) -> UIView{
        let view = UIView(frame : CGRect(x : Double(self.navBarWidth) * 0.02, y : y , width: self.scoutingViewWidth, height : Double(UIScreen.main.bounds.height) * 0.82 / Double(self.numberOfRows)))
        view.backgroundColor = color
        return view
    }
    
    lazy var screenTitle : UILabel = {
        let label = UILabel(frame : CGRect(x : Double(self.navBarWidth) * 0.05 , y : Double(self.navBarHeight) * 0.02, width : Double(self.navBarWidth) * 0.4, height : Double(self.navBarHeight) * 0.35))
        label.font = label.font.withSize(CGFloat(self.navBarHeight * 0.30))
        label.textAlignment = .left
        return label
    }()
    
    lazy var StartTimerButton : UIButton = {
           let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.navBarWidth * 0.55), y : Double(self.navBarHeight) * self.multiplier, width : Double(self.buttonsWidth * 2), height : Double(self.navBarHeight * 0.35))
           button.tag = 1
           button.setTitle("Start Timer", for: .normal)
           button.setTitleColor(UIColor.white, for: .normal)
           button.backgroundColor = UIColor.systemBlue
           button.layer.cornerRadius = 5
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
          return button
       }()

       lazy var PauseButton : UIButton = {
           let button = UIButton(type : .system)
         button.frame = CGRect(x : Double(self.navBarWidth * 0.55), y : Double(navBarHeight) * self.multiplier, width : Double(self.buttonsWidth), height : Double(self.navBarHeight * 0.35))
           button.tag = 2
           button.setImage(UIImage(named : "pause"), for: .normal)
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        button.isHidden = true
           return button
       }()

       lazy var PlayButton : UIButton = {
           let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.navBarWidth * 0.55), y : Double(navBarHeight) * self.multiplier, width : Double(self.buttonsWidth), height : Double(self.navBarHeight * 0.35))
           button.tag = 3
           button.setImage(UIImage(named : "play"), for: .normal)
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
           button.isHidden = true
           return button
       }()

       lazy var undoButton : UIButton = {
           let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.navBarWidth * 0.7), y : Double(navBarHeight) * self.multiplier, width : Double(self.buttonsWidth), height : Double(self.navBarHeight * 0.35))
           button.tag = 4
           button.setImage(UIImage(named : "undo"), for: .normal)
           button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
           button.isHidden = true
           return button
       }()

       lazy var commentButton : UIButton = {
           let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.navBarWidth * 0.85), y : Double(navBarHeight) * self.multiplier, width : Double(self.buttonsWidth), height : Double(self.navBarHeight * 0.35))
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
            
            self.navigationController?.pushViewController(scoutingVC, animated: false)
            
        } else if (sender.tag == 2){
            scoutingVC.hidePlayButton = false
            scoutingVC.hidePauseButton = true
            scoutingVC.hideStartTimer = true
            scoutingVC.hideUndoButton = false
            scoutingVC.currentScreenIndex = self.index!
            
            scoutingVC.matchNumber = self.matchNumber!
            scoutingVC.boardName = self.boardName!
            scoutingVC.teamNumber = self.teamNumber!
            
            
            self.navigationController?.pushViewController(scoutingVC, animated: false)
        } else if (sender.tag == 3){
            scoutingVC.hidePlayButton = true
            scoutingVC.hidePauseButton = false
            scoutingVC.hideStartTimer = true
            scoutingVC.hideUndoButton = false
            scoutingVC.currentScreenIndex = self.index!
            
            scoutingVC.matchNumber = self.matchNumber!
            scoutingVC.boardName = self.boardName!
            scoutingVC.teamNumber = self.teamNumber!
            
            self.navigationController?.pushViewController(scoutingVC, animated: false)
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
        
        let colors : [UIColor] = [.blue, .red, .yellow, .green]
        
        for i in 0..<self.numberOfRows{
            view.addSubview(self.createScoutingRows(y: self.startingY, color: colors[i]))
            startingY += (self.scoutingViewHeight) / Double(self.numberOfRows)
        }
    }
}
