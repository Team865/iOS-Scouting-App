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
    
    @IBOutlet weak var layoutView: UIView!
    var stackView = UIStackView()
    
    //Button controllers
    var hideStartTimer = false
    var hidePlayButton = true
    var hidePauseButton = true
    var hideUndoButton = true
    
    //Need to fix this, view height is Screen size * 0.9, not 0.1 (It's gonna be annoying)
    let navBarWidth = UIScreen.main.bounds.width
    let navBarHeight = Double(UIScreen.main.bounds.height * 0.1)
    
    let Ymultiplier = 0.4
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
    func createScoutingStackView(){
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2.5
        configureStackViewConstraints()
        
        for i in 0..<self.numberOfRows{
            stackView.addArrangedSubview(createScoutingRow(numberOfItems: self.numberOfItemsInRow[i], typeOfItem: self.typeOfItemsInRow[i], titleOfItem: self.nameOfItemsInRow[i], titleOfToggles: self.nameOfMultiToggleItems))
        }
    }
    
    func configureStackViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
               stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
               stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func createScoutingRow(numberOfItems : Int, typeOfItem : [String], titleOfItem : [String], titleOfToggles : [[String]]) -> UIStackView{
        let scoutingRow = UIStackView()
        
        scoutingRow.axis = .horizontal
        scoutingRow.distribution = .fillEqually
        scoutingRow.spacing = 2.5
        
        for i in 0..<numberOfItems{
            if(typeOfItem[i] == "Button"){
                scoutingRow.addArrangedSubview(createScoutingButton(title: titleOfItem[i]))
            } else if (typeOfItem[i] == "Switch"){
                scoutingRow.addArrangedSubview(createScoutingSwitch(title: titleOfItem[i]))
            } else if (typeOfItem[i] == "MultiToggle"){
                while(titleOfToggles[self.notEmptyIndex].isEmpty){
                    self.notEmptyIndex += 1
                }
                scoutingRow.addArrangedSubview(createMultiToggleField(toggleFieldTitle: titleOfItem[i], nameOfToggleFields: titleOfToggles[self.notEmptyIndex]))
                self.notEmptyIndex += 1
            } else if (typeOfItem[i] == "Checkbox"){
                scoutingRow.addArrangedSubview(createCheckBox())
            }
        }
        
        return scoutingRow
    }
    
    func createScoutingButton(title : String) -> UIButton{
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
        buttonField.setTitleColor(self.backgroundColor, for: .normal)
        buttonField.setTitle(title, for: .normal)
        buttonField.titleLabel?.numberOfLines = 0
        buttonField.contentHorizontalAlignment = .center
        buttonField.titleLabel?.textAlignment = .center
        buttonField.titleLabel?.lineBreakMode = .byWordWrapping
        buttonField.backgroundColor = UIColor.systemGray5
//        buttonField.index = tag
//        buttonField.value = 1
        buttonField.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
        return buttonField
    }
    
    func createScoutingSwitch(title : String) -> UIButton{
        let switchField = Switch()
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
//        switchField.index = tag
//        switchField.value = 0
        switchField.setTitleColor(self.backgroundColor, for: .normal)
        switchField.backgroundColor = UIColor.systemGray5
        switchField.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
        return switchField
    }
    
    func createCheckBox() -> UIView{
        let checkBoxField = UIView()
        checkBoxField.backgroundColor = UIColor.systemGray5
        
        return checkBoxField
    }
    
    func createMultiToggleField(toggleFieldTitle : String, nameOfToggleFields : [String]) -> UIView{
        let multiToggleField = UIView()

        let viewHeight = Double(UIScreen.main.bounds.height) * 0.85
        
        multiToggleField.backgroundColor = UIColor.systemGray5
        
        let titleArr = toggleFieldTitle.components(separatedBy: "_")
        var title = ""
        
        for i in 0..<titleArr.count{
              title += titleArr[i].prefix(1).uppercased() + titleArr[i].lowercased().dropFirst() + " "
           }
        let label = UILabel()

        label.frame = CGRect(x : 0.0, y : viewHeight / Double(self.numberOfRows) * 0.01, width: Double(UIScreen.main.bounds.width), height: viewHeight / Double(self.numberOfRows) * 0.22)
        label.text = title
        label.textAlignment = .center
        multiToggleField.addSubview(label)
        
        let toggleView = UIStackView()
        toggleView.frame = CGRect(x : 0, y : viewHeight / Double(self.numberOfRows) * 0.25, width : Double(UIScreen.main.bounds.width) - 14, height : viewHeight / Double(self.numberOfRows) * 0.56)
        
        toggleView.axis = .horizontal
        toggleView.spacing = 0
        toggleView.distribution = .fillEqually
        var listOfToggles : [ToggleButton] = []
        
        for i in 0..<nameOfToggleFields.count{
            let button = ToggleButton()
            button.setTitle(nameOfToggleFields[i], for: .normal)
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(backgroundColor, for: .normal)
            button.backgroundColor = UIColor.systemGray5
            button.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
            listOfToggles.append(button)
            toggleView.addArrangedSubview(button)
        }
        
        self.listOfToggleButtons.append(listOfToggles)
        
        multiToggleField.addSubview(toggleView)
        
       return multiToggleField
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
            
//            let indices = [7,15]
//            //Find a way to not hard code this
//            UserDefaults.standard.set(indices, forKey: "selectedIndex")
//            UserDefaults.standard.set(toggleField.value, forKey: "selectedValue")
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        for i in 0..<self.listOfToggleButtons.count{
//            for k in 0..<self.listOfToggleButtons[i].count{
//                listOfToggleButtons[i][k].backgroundColor = UIColor.systemGray5
//                listOfToggleButtons[i][k].setTitleColor(self.backgroundColor, for: .normal)
//            }
//        }
//
//        if let selectedIndex = UserDefaults.standard.object(forKey: "selectedIndex") as? [Int]{
//            if let selectedValue = UserDefaults.standard.object(forKey: "selectedValue") as? Int{
//                for i in 0..<self.listOfToggleButtons.count{
//                    for k in 0..<self.listOfToggleButtons[i].count{
//                        if (self.listOfToggleButtons[i][k].index == selectedIndex[0] || self.listOfToggleButtons[i][k].index == selectedIndex[1]) && self.listOfToggleButtons[i][k].value == selectedValue{
//                            self.listOfToggleButtons[i][k].backgroundColor = self.backgroundColor
//                            self.listOfToggleButtons[i][k].setTitleColor(UIColor.white, for: .normal)
//
//                        }
//                    }
//                }
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createScoutingStackView()
       
    }
}
