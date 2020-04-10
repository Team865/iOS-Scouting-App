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
    var selectedScreen = 0
    
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
    var listOfIndices : [[Int]] = []
    var numberOfRows = 0
    
    let backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
    
    let scoutingViewHeight = Double(UIScreen.main.bounds.height) * 0.85
    let scoutingViewWidth = Double(UIScreen.main.bounds.width) * 0.96
    
    //Current multiplier is height multiplier + Y multiplier (0.25 + 0.6)
    var startingY = Double(UIScreen.main.bounds.height * 0.1) * 0.825
    
    //Indices
    var test = [[9,1,1,1], [10,2,2,2], [11,3,3,3]]
    
    //QRCode entries
    var QRCode = UIImageView()
    var colorChanged = false
    var counter : [Int]  = []
    var states : [Bool] = []
    var listOfToggleButtons : [[ToggleButton]] = []
    
    let sa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ScoutingActivity") as! ScoutingActivity
    
    var listOfTypeIndices : [Int] = []
    var listOfValues : [Int] = []
    var listOfTimeStamps : [Float] = []
    
    var dataPoints = [DataPoint]()
    
    //Timer elements
    var timer : Timer!
    let progress = Progress(totalUnitCount: 16500)
    let progressBar = UIProgressView()
    //UIs classes
    //Configure QR Code
    func createQRCode(){
        view.addSubview(QRCode)
        QRCode.image = UIImage(named: "jerry")
        
        QRCode.translatesAutoresizingMaskIntoConstraints = false
        QRCode.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        QRCode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        QRCode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        QRCode.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250).isActive = true
        
    }
    
    //Configure UI for scouting activity
    func createScoutingStackView(){
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2.5
        configureStackViewConstraints()
        
        for i in 0..<self.numberOfRows{
            stackView.addArrangedSubview(createScoutingRow(numberOfItems: self.numberOfItemsInRow[i], typeOfItem: self.typeOfItemsInRow[i], titleOfItem: self.nameOfItemsInRow[i], titleOfToggles: self.nameOfMultiToggleItems, currentRow: i))
        }
    }
    
    func configureStackViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func createScoutingRow(numberOfItems : Int, typeOfItem : [String], titleOfItem : [String], titleOfToggles : [[String]], currentRow : Int) -> UIStackView{
        let scoutingRow = UIStackView()
        
        scoutingRow.axis = .horizontal
        scoutingRow.distribution = .fillEqually
        scoutingRow.spacing = 2.5
        for i in 0..<numberOfItems{
            if(typeOfItem[i] == "Button"){
                let button = Button()
                button.tag = self.listOfIndices[index ?? 0][itemIndex]
                button.value = 1
                button.setTitle(formatTitleOfItem(string: titleOfItem[i]), for: .normal)
                button.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
                scoutingRow.addArrangedSubview(button)
            } else if (typeOfItem[i] == "Switch"){
                let switchField = Switch()
                switchField.tag = self.test[index ?? 0][0]
                switchField.value = 0
                switchField.setTitle(formatTitleOfItem(string: titleOfItem[i]), for: .normal)
                switchField.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
                scoutingRow.addArrangedSubview(switchField)
            } else if (typeOfItem[i] == "MultiToggle"){
                while(titleOfToggles[self.notEmptyIndex].isEmpty){
                    self.notEmptyIndex += 1
                }
                let multiToggleField = MultiToggleField()
                var listOfToggleButtons : [ToggleButton] = []
                multiToggleField.numberOfRows = self.numberOfRows
                multiToggleField.title = formatTitleOfItem(string: titleOfItem[i])
                for k in 0..<titleOfToggles[self.notEmptyIndex].count{
                    let toggleButton = ToggleButton()
                    toggleButton.setTitle(titleOfToggles[self.notEmptyIndex][k], for: .normal)
                    toggleButton.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
                
                    if(k == 2){
                        toggleButton.backgroundColor = self.backgroundColor
                        toggleButton.setTitleColor(UIColor.white, for: .normal)
                    }
                    
                    toggleButton.value = k
                    toggleButton.tag = self.listOfIndices[index ?? 0][itemIndex]
                    listOfToggleButtons.append(toggleButton)
                
                }
                
                multiToggleField.listOfToggles.append(contentsOf: listOfToggleButtons)
                self.listOfToggleButtons.append(listOfToggleButtons)
                multiToggleField.setUpToggleField()
                scoutingRow.addArrangedSubview(multiToggleField)
                
                self.notEmptyIndex += 1
            } else if (typeOfItem[i] == "Checkbox"){
                let checkBoxField = CheckBox()
                let checkBoxButton = CheckBoxButton()
                checkBoxField.title = formatTitleOfItem(string: titleOfItem[i])
                checkBoxButton.tag = self.listOfIndices[index ?? 0][itemIndex]
                checkBoxField.checkBox = checkBoxButton
                checkBoxButton.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
                checkBoxField.setUpCheckBox()
                scoutingRow.addArrangedSubview(checkBoxField)
            }
            
            itemIndex += 1
        }
        
        return scoutingRow
    }
    
    func formatTitleOfItem(string : String) -> String{
        let titleArr = string.components(separatedBy: "_")
        var title = ""
        
        for i in 0..<titleArr.count{
            title += titleArr[i].prefix(1).uppercased() + titleArr[i].lowercased().dropFirst() + " "
        }
        return title
    }
    
    func getTimeStamp() -> Float {
        var itemStamp : Float = 0
        if let timeStamp = UserDefaults.standard.object(forKey: "timeStamp") as? Float{
           itemStamp = timeStamp
        }
        return itemStamp
    }
    
    
    func collectData(typeIndex : Int, value : Int, timeStamp : Float){
        self.dataPoints.append(DataPoint.init(type_index: typeIndex, value: value, time: timeStamp))
        sa.encodeData(dataPoints : self.dataPoints)
    }
    
    @objc func collectQRCodeData(sender : AnyObject){
        if let button = sender as? Button{
            collectData(typeIndex: button.tag, value: button.value, timeStamp: getTimeStamp())
        }
        if let switchField = sender as? Switch{
            if switchField.value == 0{
                switchField.backgroundColor = self.backgroundColor
                switchField.setTitleColor(UIColor.white, for: .normal)
                switchField.value = 1
                collectData(typeIndex: switchField.tag, value: switchField.value, timeStamp: getTimeStamp())
                
            } else {
                switchField.backgroundColor = UIColor.systemGray5
                switchField.setTitleColor(self.backgroundColor, for: .normal)
                switchField.value = 0
                collectData(typeIndex: switchField.tag, value: switchField.value, timeStamp: getTimeStamp())

            }
        }
        
        if let toggleField = sender as? ToggleButton{
            for i in 0..<self.listOfToggleButtons.count{
                if toggleField.tag == self.listOfToggleButtons[i][0].tag{
                    for k in 0..<self.listOfToggleButtons[i].count{
                        if(toggleField.value == self.listOfToggleButtons[i][k].value){
                            self.listOfToggleButtons[i][k].backgroundColor = self.backgroundColor
                            self.listOfToggleButtons[i][k].setTitleColor(UIColor.white, for: .normal)
                        } else {
                            self.listOfToggleButtons[i][k].backgroundColor = UIColor.systemGray5
                            self.listOfToggleButtons[i][k].setTitleColor(self.backgroundColor, for: .normal)
                        }
                    }
                }
            }
            UserDefaults.standard.set(toggleField.value, forKey: "selectedToggleFieldValue")
            collectData(typeIndex: toggleField.tag, value: toggleField.value, timeStamp: getTimeStamp())
            
        }
   
        if let checkbox = sender as? CheckBoxButton {
            if checkbox.value == 0 {
                checkbox.backgroundColor = self.backgroundColor
                checkbox.value = 1
                collectData(typeIndex: checkbox.tag, value: checkbox.value, timeStamp: getTimeStamp())
            } else {
                checkbox.backgroundColor = UIColor.systemGray5
                checkbox.value = 0
                collectData(typeIndex: checkbox.tag, value: checkbox.value, timeStamp: getTimeStamp())
            }
            
          
        }
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
            //find a way to not hard code this
            if let selectedValue = UserDefaults.standard.object(forKey: "selectedToggleFieldValue") as? Int{
                for i in 0..<self.listOfToggleButtons.count{
                    for k in 0..<self.listOfToggleButtons[i].count{
                        if (self.listOfToggleButtons[i][k].tag == 7 || self.listOfToggleButtons[i][k].tag == 15) {
                            if self.listOfToggleButtons[i][k].value == selectedValue{
                            self.listOfToggleButtons[i][k].backgroundColor = self.backgroundColor
                            self.listOfToggleButtons[i][k].setTitleColor(UIColor.white, for: .normal)
                            } else {
                                self.listOfToggleButtons[i][k].backgroundColor = UIColor.systemGray5
                                self.listOfToggleButtons[i][k].setTitleColor(self.backgroundColor, for: .normal)
                            }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.index ?? 0 <= 2 {
            createScoutingStackView()
            if let listOfIndices = UserDefaults.standard.object(forKey: "indices") as? [Int]{
                if let listOfValues = UserDefaults.standard.object(forKey: "values") as? [Int] {
                    if let listOfTimeStamps = UserDefaults.standard.object(forKey: "timeStamps") as? [Float]{
                        self.listOfTypeIndices = listOfIndices
                        self.listOfValues = listOfValues
                        self.listOfTimeStamps = listOfTimeStamps
                    }
                }
            }
        } else {
            createQRCode()
        }
    }
}
