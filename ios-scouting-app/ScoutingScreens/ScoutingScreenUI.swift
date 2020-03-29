//
//  ViewController1.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit

class ScoutingScreen : UIViewController {

    var screenTitles : String?
    var index : Int?
    
    //Button controllers
    var hideStartTimer = false
    var hidePlayButton = true
    var hidePauseButton = true
    var hideUndoButton = true
    
    //Need to fix this, view height is Screen size * 0.9, not 0.1 (It's gonna be annoying)
    let navBarWidth = UIScreen.main.bounds.width
    let navBarHeight = Double(UIScreen.main.bounds.height * 0.1)
    
    let Ymultiplier = 0.25
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
    var nameOfMultiToggleItems : [[String]] = []
    var notEmptyIndex = 0
    
    var itemIndex = 0
    var listOfIndices : [Int] = []
    var numberOfRows = 0
    
    let backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
    
    let scoutingViewHeight = Double(UIScreen.main.bounds.height) * 0.85
    let scoutingViewWidth = Double(UIScreen.main.bounds.width) * 0.96
    
    //Current multiplier is height multiplier + Y multiplier (0.25 + 0.6)
    var startingY = Double(UIScreen.main.bounds.height * 0.1) * 0.825
    
    
    //QRCode entries
    var colorChanged = false
    var counter : [Int]  = []
    var states : [Bool] = []
    var timeStamp : Float = 0
    var listOfToggleButtons : [[ToggleButton]] = []
    
    //Timer elements
    var timer : Timer!
    let progress = Progress(totalUnitCount: 16500)
    let progressBar = UIProgressView()
    //UIs classes
    
    //Another way to identify which button you are clicking is to disregard the rows and shit, just set the tags of the buttons from 0 to which ever number you can
    
    //Configure UI for scouting activity
    func createScoutingRows(y : Double, currentRow : Int) -> UIView{
        let rowHeight = Double(UIScreen.main.bounds.height) * 0.835 / Double(self.numberOfRows)
        let rowWidth = self.scoutingViewWidth
        
        let scoutingRowView = UIView(frame : CGRect(x : Double(self.navBarWidth) * 0.02, y : y , width: rowWidth, height : rowHeight))
        var startingX = 0.0
        
        let itemWidth = rowWidth / Double(self.numberOfItemsInRow[currentRow])
        
        let spacing = itemWidth * 0.01
        
        //To compress the view but keep the ratio of views, simply reduce itemHeight, and reduce spacing between items (which is found in viewDidLoad()
        let itemHeight = rowHeight * 0.92        
        
        for i in 0..<self.numberOfItemsInRow[currentRow]{
            if(self.typeOfItemsInRow[currentRow][i] == "Button"){
                scoutingRowView.addSubview(createScoutingButton(x: startingX, width: itemWidth * 0.99, height: itemHeight, title : self.nameOfItemsInRow[currentRow][i], tag: self.listOfIndices[self.itemIndex]))
                self.itemIndex += 1
            } else if (self.typeOfItemsInRow[currentRow][i] == "Switch"){
                scoutingRowView.addSubview(createScoutingSwitch(x: startingX, width: itemWidth * 0.99, height: itemHeight, title: self.nameOfItemsInRow[currentRow][i], tag : self.listOfIndices[self.itemIndex]))
                self.itemIndex += 1
            } else if (self.typeOfItemsInRow[currentRow][i] == "MultiToggle"){
                if(self.notEmptyIndex < self.nameOfMultiToggleItems.count){
                while (self.nameOfMultiToggleItems[self.notEmptyIndex].count == 0){
                    self.notEmptyIndex += 1
                }
                    scoutingRowView.addSubview(createMultiToggleField(x: 0.0, width: rowWidth, height: itemHeight, numberOfToggleFields: self.nameOfMultiToggleItems[self.notEmptyIndex].count, toggleButtonTitle : self.nameOfMultiToggleItems[self.notEmptyIndex], toggleFieldTitle: self.nameOfItemsInRow[currentRow][i], index: self.listOfIndices[self.itemIndex]))
                    self.itemIndex += 1
                    self.notEmptyIndex += 1
                }

            }
            startingX += (itemWidth + spacing)
            }
        return scoutingRowView
    }
    
    func createScoutingButton(x : Double, width : Double, height : Double, title : String, tag : Int) -> UIButton{
        let buttonField = Button()

        let titleArr = title.components(separatedBy: "_")
        var title = ""
        
        for i in 0..<titleArr.count{
            if(i == 0){
                title += titleArr[i].prefix(1).uppercased() + titleArr[i].lowercased().dropFirst() + " "
            } else {
                title += titleArr[i] + " "
            }
        }
        buttonField.frame = CGRect(x : x, y : 0, width : width, height : height)
        buttonField.setTitleColor(self.backgroundColor, for: .normal)
        buttonField.setTitle(title, for: .normal)
        buttonField.titleLabel?.numberOfLines = 0
        buttonField.contentHorizontalAlignment = .center
        buttonField.titleLabel?.textAlignment = .center
        buttonField.titleLabel?.lineBreakMode = .byWordWrapping
        buttonField.titleLabel?.font = buttonField.titleLabel?.font.withSize(CGFloat(height * 0.125))
        buttonField.backgroundColor = UIColor.systemGray5
        buttonField.index = tag
        buttonField.value = 1
        buttonField.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
        return buttonField
    }
    
    func createScoutingSwitch(x : Double, width : Double, height : Double, title : String, tag : Int) -> UIButton{
        let switchField = Switch()
        switchField.frame = CGRect(x : x, y : 0, width : width, height : height)
        switchField.setTitle("Switch", for: .normal)
        let titleArr = title.components(separatedBy: "_")
        var title = ""
        
        for i in 0..<titleArr.count{
            if(i == 0){
                title += titleArr[i].prefix(1).uppercased() + titleArr[i].lowercased().dropFirst() + " "
            } else {
                title += titleArr[i] + " "
            }
        }
        switchField.setTitleColor(UIColor.black, for: .normal)
        switchField.setTitle(title, for: .normal)
        switchField.titleLabel?.numberOfLines = 0
        switchField.contentHorizontalAlignment = .center
        switchField.titleLabel?.textAlignment = .center
        switchField.titleLabel?.lineBreakMode = .byWordWrapping
        switchField.titleLabel?.font = switchField.titleLabel?.font.withSize(CGFloat(height * 0.125))
        switchField.index = tag
        switchField.value = 0
        switchField.setTitleColor(self.backgroundColor, for: .normal)
        switchField.backgroundColor = UIColor.systemGray5
        switchField.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
        return switchField
    }
    
    func createCheckBox(x : Double, width : Double, height : Double, title : String, tag : Int) -> UIButton{
        let checkBox = UIButton(frame : CGRect(x : x, y : 0, width : width, height: height))
        return checkBox
    }
    
    func createMultiToggleField(x : Double, width : Double, height : Double, numberOfToggleFields : Int, toggleButtonTitle : [String], toggleFieldTitle : String, index : Int) -> UIView{
        let toggleHeight = height
        
        let multiToggle = UIView(frame : CGRect(x : x, y : 0, width : width * 0.975, height : toggleHeight * 0.75))
        
        multiToggle.backgroundColor = UIColor.systemGray5
        multiToggle.tag = index
        let toggleFieldWidth = width * 0.975 / Double(numberOfToggleFields) * 1.027
        var startingX = x
        
        let fieldTitle = UILabel(frame : CGRect(x : x, y : 0, width : width, height : toggleHeight * 0.15))
        
        let titleArr = toggleFieldTitle.components(separatedBy: "_")
        var toggleTitle = ""
        for u in 0..<titleArr.count{
           toggleTitle += titleArr[u].prefix(1).uppercased() + titleArr[u].lowercased().dropFirst() + " "
        }
        
        fieldTitle.text = toggleTitle
        fieldTitle.textColor = UIColor.black
        fieldTitle.textAlignment = .center
        fieldTitle.backgroundColor = UIColor.systemGray5
        multiToggle.addSubview(fieldTitle)
        
        var toggleList : [ToggleButton] = []
        
        for i in 0..<numberOfToggleFields{
            let toggleButton = ToggleButton()
            toggleButton.frame = CGRect(x : startingX, y : toggleHeight * 0.15, width : toggleFieldWidth, height : toggleHeight * 0.85)
            toggleButton.setTitle(toggleButtonTitle[i], for: .normal)
            toggleButton.setTitleColor(self.backgroundColor, for: .normal)
            toggleButton.titleLabel?.numberOfLines = 0
            toggleButton.contentHorizontalAlignment = .center
            toggleButton.titleLabel?.textAlignment = .center
            toggleButton.titleLabel?.lineBreakMode = .byWordWrapping
            toggleButton.backgroundColor = UIColor.systemGray5
            toggleButton.value = i
            toggleButton.index = index
            toggleButton.titleLabel?.font = toggleButton.titleLabel?.font.withSize(CGFloat(toggleHeight * 0.125))
            toggleButton.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
            multiToggle.addSubview(toggleButton)
            toggleList.append(toggleButton)
            startingX += toggleFieldWidth
        }
        self.listOfToggleButtons.append(toggleList)
        
        return multiToggle
    }
    
    func getTimeStamp() -> Float {
        var itemStamp : Float = 0
        if let timeStamp = UserDefaults.standard.object(forKey: "timeStamp") as? Float{
           itemStamp = timeStamp
        }
        return itemStamp
    }
    
    @objc func collectQRCodeData(sender : AnyObject){
        if let button = sender as? Button{
        print(button.value)
        print(button.index!)
        print(getTimeStamp())
        }
        if let switchField = sender as? Switch{
            if switchField.value == 0{
                switchField.backgroundColor = self.backgroundColor
                switchField.setTitleColor(UIColor.white, for: .normal)
                switchField.value = 1
                print(getTimeStamp())
            } else {
                switchField.backgroundColor = UIColor.systemGray5
                switchField.setTitleColor(self.backgroundColor, for: .normal)
                switchField.value = 0
                print(getTimeStamp())
            }
        }
        
        if let toggleField = sender as? ToggleButton{
            for i in 0..<self.listOfToggleButtons.count{
                for k in 0..<self.listOfToggleButtons[i].count{
                    listOfToggleButtons[i][k].backgroundColor = UIColor.systemGray5
                    listOfToggleButtons[i][k].setTitleColor(self.backgroundColor, for: .normal)
                }
            }
            
            toggleField.backgroundColor = self.backgroundColor
            toggleField.setTitleColor(UIColor.white, for: .normal)
            
            print(toggleField.index ?? 0)
            print(toggleField.value ?? 0)
            
            let indices = [7,15]
            //Find a way to not hard code this
            UserDefaults.standard.set(indices, forKey: "selectedIndex")
            UserDefaults.standard.set(toggleField.value, forKey: "selectedValue")
            
        }
    }


    
    lazy var screenTitle : UILabel = {
        let label = UILabel(frame : CGRect(x : Double(self.navBarWidth) * 0.025 , y : Double(self.navBarHeight) * self.Ymultiplier, width : Double(self.navBarWidth) * 0.5, height : Double(self.navBarHeight) * self.heightMultiplier))
        label.font = label.font.withSize(CGFloat(self.navBarHeight * self.heightMultiplier * 0.75))
        label.textAlignment = .left
        return label
    }()
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        for i in 0..<self.listOfToggleButtons.count{
            for k in 0..<self.listOfToggleButtons[i].count{
                listOfToggleButtons[i][k].backgroundColor = UIColor.systemGray5
                listOfToggleButtons[i][k].setTitleColor(self.backgroundColor, for: .normal)
            }
        }
        
        if let selectedIndex = UserDefaults.standard.object(forKey: "selectedIndex") as? [Int]{
            if let selectedValue = UserDefaults.standard.object(forKey: "selectedValue") as? Int{
                for i in 0..<self.listOfToggleButtons.count{
                    for k in 0..<self.listOfToggleButtons[i].count{
                        if (self.listOfToggleButtons[i][k].index == selectedIndex[0] || self.listOfToggleButtons[i][k].index == selectedIndex[1]) && self.listOfToggleButtons[i][k].value == selectedValue{
                            self.listOfToggleButtons[i][k].backgroundColor = self.backgroundColor
                            self.listOfToggleButtons[i][k].setTitleColor(UIColor.white, for: .normal)
                            
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenTitle.text = self.screenTitles
        view.addSubview(screenTitle)
        
        for i in 0..<self.numberOfRows{
            view.addSubview(self.createScoutingRows(y: self.startingY, currentRow: i))
            startingY += ((self.scoutingViewHeight) / Double(self.numberOfRows)) * 0.92
        }
      
    }
}
