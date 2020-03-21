//
//  ScoutingViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/20/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

//https://www.youtube.com/watch?v=a5yjOMLBfSc&t=759s

class ScoutingViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let buttonsWidth =  UIScreen.main.bounds.width * 0.1
    
    var myCollectionView : UICollectionView!
    
    let images = ["timer", "team", "paste", "layers2"]
    
    let scoutingScreens = ["Auto", "Teleop", "Endgame", "QRCode"]
    
    var listOfScoutingScreen : [ScoutingScreen] = []
    
    var selectedBoardLabel : UILabel!
    var matchNumberLabel : UILabel!
    var teamNumberLabel : UILabel!
    var timeLeft : UILabel!
    
    var boardName = ""
    var teamNumber = ""
    var matchNumber = ""
    
    var screenNameLabel : UILabel!
    
    //Colected data
    var comment = ""

    let multiplier = 0.11;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.listOfScoutingScreen = self.createScoutingScreens()
        
        collectionView?.register(ScoutingScreenCells.self, forCellWithReuseIdentifier: "scoutingScreen")
        collectionView?.isPagingEnabled = true
    
        
        view.addSubview(self.StartTimerButton)
        view.addSubview(self.PauseButton)
        view.addSubview(self.PlayButton)
        view.addSubview(self.undoButton)
        view.addSubview(self.commentButton)
    }
    
//UIConfigurations
       
       lazy var StartTimerButton : UIButton = {
           let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.screenWidth * 0.52), y : Double(screenHeight) * self.multiplier, width : Double(self.buttonsWidth * 3), height : Double(self.screenHeight * 0.038))
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
            
            PauseButton.isHidden = false
            undoButton.isHidden = false
            
        } else if (sender.tag == 2){
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
            
            self.present(alert, animated : true, completion : nil)
        }
    }
    
    func createScoutingScreens() -> [ScoutingScreen]{
        var tempScreen : [ScoutingScreen] = []
        for i in 0..<self.scoutingScreens.count{
            let screen = ScoutingScreen(title: self.scoutingScreens[i], matchNumber: "m1,", board: "b2")
            tempScreen.append(screen)
        }
        return tempScreen
    }
    
    private func createIcon(imageName : String) -> UIImageView{
        let image = UIImageView(frame : CGRect(x: 0, y: 0, width: 10, height: 15))
        image.image = UIImage(named: imageName)
        return image
    }
    
    private func createLabel() -> UILabel{
        let label = UILabel(frame : CGRect(x : 0, y : 0, width : 25, height : 15))
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    
    private func setUpNavigationBar(){
        
        self.matchNumberLabel = self.createLabel()
        self.teamNumberLabel = self.createLabel()
        self.selectedBoardLabel = self.createLabel()
        self.timeLeft = self.createLabel()
        
        matchNumberLabel.text = self.matchNumber
        teamNumberLabel.text = self.teamNumber
        selectedBoardLabel.text = self.boardName
        
        if(self.boardName.prefix(1) == "B"){
            selectedBoardLabel.textColor = UIColor.blue
        } else if (self.boardName.prefix(1) == "R"){
            selectedBoardLabel.textColor = UIColor.red
        }
        
        var navBarItems : [UIBarButtonItem] = []
        
        let navBarLabels : [UILabel] = [self.timeLeft, self.teamNumberLabel, self.selectedBoardLabel, self.matchNumberLabel]
        
        for i in 0..<self.images.count{
            navBarItems.append(UIBarButtonItem(customView: self.createIcon(imageName: self.images[i])))
            navBarItems.append(UIBarButtonItem(customView: navBarLabels[i]))
        }
        
        navigationItem.rightBarButtonItems = navBarItems
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfScoutingScreen.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let screen = self.listOfScoutingScreen[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoutingScreen", for: indexPath) as! ScoutingScreenCells
 
        cell.setScreen(screen: screen)
        print(indexPath.index(after: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    //indexPath means how far the view is offset from the start
    
}
