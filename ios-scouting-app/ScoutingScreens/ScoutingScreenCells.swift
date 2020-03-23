//
//  ScoutingScreenCells.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/20/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class ScoutingScreenCells : UICollectionViewCell{
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    let buttonsWidth =  UIScreen.main.bounds.width * 0.1

    //Colected data
    var comment = ""

    let multiplier = 0.0125;
    
    var screenNameLabel : UILabel!
    
    var startTimer = false
    
    func ScreenNameLabel(x : Double, y : Double, width: Double, height : Double) -> UILabel {
        let label = UILabel(frame : CGRect(x: x, y: y, width: width, height: height))
        label.textAlignment = .left
        label.font = label.font.withSize(self.screenHeight * 0.03)
        return label
    }
    
    lazy var StartTimerButton : UIButton = {
              let button = UIButton(type : .system)
           button.frame = CGRect(x : Double(self.screenWidth * 0.52), y : Double(screenHeight) * self.multiplier, width : Double(self.buttonsWidth * 3), height : Double(self.screenHeight * 0.038))
              button.tag = 1
              button.setTitle("Start Timer", for: .normal)
              button.setTitleColor(UIColor.white, for: .normal)
              button.backgroundColor = UIColor.systemBlue
              button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
        button.isHidden = self.startTimer
             return button
          }()
          
          lazy var PauseButton : UIButton = {
              let button = UIButton(type : .system)
           button.frame = CGRect(x : Double(self.screenWidth * 0.55), y : Double(screenHeight) * self.multiplier, width : Double(self.buttonsWidth), height : Double(self.screenHeight * 0.038))
              button.tag = 2
              button.setImage(UIImage(named : "pause"), for: .normal)
              button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
           button.isHidden = true
              return button
          }()
          
          lazy var PlayButton : UIButton = {
              let button = UIButton(type : .system)
           button.frame = CGRect(x : Double(self.screenWidth * 0.55), y : Double(screenHeight) * self.multiplier, width : Double(self.buttonsWidth), height : Double(self.screenHeight * 0.038))
              button.tag = 3
              button.setImage(UIImage(named : "play"), for: .normal)
              button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
           button.isHidden = true
              return button
          }()
          
          lazy var undoButton : UIButton = {
              let button = UIButton(type : .system)
           button.frame = CGRect(x : Double(self.screenWidth * 0.70), y : Double(screenHeight) * self.multiplier, width : Double(self.buttonsWidth), height : Double(self.screenHeight * 0.038))
              button.tag = 4
              button.setImage(UIImage(named : "undo"), for: .normal)
              button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
              button.isHidden = true
              return button
          }()
          
          lazy var commentButton : UIButton = {
              let button = UIButton(type : .system)
           button.frame = CGRect(x : Double(self.screenWidth * 0.85), y : Double(screenHeight) * self.multiplier, width : Double(self.buttonsWidth), height : Double(self.screenHeight * 0.038))
              button.tag = 5
              button.setImage(UIImage(named : "comments"), for: .normal)
              button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
              return button
          }()

    @objc func clickHandler(sender : UIButton){
        if(sender.tag == 1){
            StartTimerButton.isHidden = true
            self.startTimer = true
            
            PauseButton.isHidden = false
            undoButton.isHidden = false
            ScoutingViewController().reload()
        }
        
        if (sender.tag == 2){
            PauseButton.isHidden = true
            PlayButton.isHidden = false
        } else if (sender.tag == 3){
            PauseButton.isHidden = false
            PlayButton.isHidden = true
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
            
            self.window?.rootViewController?.present(alert, animated : true, completion : nil)
        }
    }
    
    func setScreen(screen : ScoutingScreen){
        screenNameLabel.text = screen.title
        
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.screenNameLabel = ScreenNameLabel(x: Double(self.screenWidth * 0.05), y: Double(self.screenHeight * 0.008), width: Double(self.screenWidth * 0.3), height: Double(self.screenHeight * 0.04))
        print(self.startTimer)
        
        addSubview(screenNameLabel)
        addSubview(StartTimerButton)
        addSubview(PauseButton)
        addSubview(PlayButton)
        addSubview(commentButton)
        addSubview(undoButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
