//
//  ViewController1.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit

private var selectedValue = 2
private var lastSelectedValue = 0
private var listOfCounters : [Int : Int] = [:]
private var listOfSwitchValues : [Int : Int] = [:]
private var listOfToggleFieldValues : [Int : Int] = [:]
private var listOfCheckBoxValues : [Int : Int] = [:]
private var undoValueTag = 0

private var listOfToggleFields : [[ToggleButton]] = []
private var listOfButtonFields : [ButtonField] = []
private var listOfItemsOnScreen : [UIView] = []
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
    var listOfDefaultChoices : [Int] = []
    
    var dataPoints = [DataPoint]()
    
    var itemIndex = 0
    var listOfIndices : [[Int]] = []
    var numberOfRows = 0
    var counterPointer = 0
    let backgroundColor = UIColor.init(red:0.24, green:0.36, blue:0.58, alpha:1.00)
    
    let scoutingViewHeight = Double(UIScreen.main.bounds.height) * 0.85
    let scoutingViewWidth = Double(UIScreen.main.bounds.width) * 0.96
    
    //Current multiplier is height multiplier + Y multiplier (0.25 + 0.6)
    var startingY = Double(UIScreen.main.bounds.height * 0.1) * 0.825
    
    //Indices
    
    //QRCode entries
    var QRCode = UIImageView()
    var colorChanged = false
    var counter : [Int]  = []
    var states : [Bool] = []
    var numberOfButtonsOnScreen = 0
    var listOfTypeIndices : [Int] = []
    var listOfValues : [Int] = []
    var listOfTimeStamps : [Float] = []
    
    
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
                let buttonField = ButtonField()
                button.tag = self.listOfIndices[index ?? 0][itemIndex]
                buttonField.tag = self.listOfIndices[index ?? 0][itemIndex]
                button.value = 1
                button.setTitle(formatTitleOfItem(string: titleOfItem[i]), for: .normal)
                button.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
                scoutingRow.addArrangedSubview(buttonField)
                buttonField.button = button
                
                //Find a way to dynamically get the number of buttons on the screen
                if(listOfCounters.count == 12){
                    buttonField.counter = listOfCounters[button.tag]!
                } else {
                    listOfCounters[button.tag] = 0
                    listOfButtonFields.append(buttonField)
                }
                buttonField.setUpButtonField()
            } else if (typeOfItem[i] == "Switch"){
                let switchField = SwitchField()
                let switchButton = Switch()
                switchField.tag = self.listOfIndices[index ?? 0][itemIndex]
                switchButton.tag = self.listOfIndices[index ?? 0][itemIndex]
                //Find a way to dynamically get the number of buttons on the screen
                if (listOfSwitchValues.count == 2){
                    switchButton.value = listOfSwitchValues[switchField.tag] ?? 0
                } else {
                    listOfSwitchValues[switchField.tag] = 0
                }
                switchButton.setTitle(formatTitleOfItem(string: titleOfItem[i]), for: .normal)
                switchButton.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
                switchField.switchButton = switchButton
                scoutingRow.addArrangedSubview(switchField)
                switchField.setUpSwitchField()
            } else if (typeOfItem[i] == "MultiToggle"){
                while(titleOfToggles[self.notEmptyIndex].isEmpty){
                    self.notEmptyIndex += 1
                }
                let multiToggleField = MultiToggleField()
                var listOfToggleButtons : [ToggleButton] = []
                multiToggleField.numberOfRows = self.numberOfRows
                multiToggleField.title = formatTitleOfItem(string: titleOfItem[i])
                multiToggleField.tag = self.listOfIndices[index ?? 0][itemIndex]
                for k in 0..<titleOfToggles[self.notEmptyIndex].count{
                    let toggleButton = ToggleButton()
                    toggleButton.setTitle(titleOfToggles[self.notEmptyIndex][k], for: .normal)
                    toggleButton.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
                    toggleButton.tag = self.listOfIndices[index ?? 0][itemIndex]
                    toggleButton.value = k
                    listOfToggleButtons.append(toggleButton)
                }
                
                if(listOfToggleFieldValues.count == 5){
                    multiToggleField.value = listOfToggleFieldValues[multiToggleField.tag] ?? 0
                } else {
                    listOfToggleFieldValues[multiToggleField.tag] = 2
                    listOfToggleFields.append(listOfToggleButtons)
                }
                
                multiToggleField.listOfToggles.append(contentsOf: listOfToggleButtons)
                multiToggleField.setUpToggleField()
                scoutingRow.addArrangedSubview(multiToggleField)
                self.notEmptyIndex += 1
                
            } else if (typeOfItem[i] == "Checkbox"){
                let checkBoxField = CheckBoxField()
                let checkBoxButton = CheckBoxButton()
                checkBoxField.title = formatTitleOfItem(string: titleOfItem[i])
                checkBoxButton.tag = self.listOfIndices[index ?? 0][itemIndex]
                checkBoxField.checkBox = checkBoxButton
                scoutingRow.addArrangedSubview(checkBoxField)
                checkBoxButton.addTarget(self, action: #selector(collectQRCodeData(sender:)), for: .touchUpInside)
                checkBoxField.setUpCheckBox()
                
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
    
    func undoCollecteData(dataPoint : DataPoint){
        undoValueTag = dataPoint.type_index
        
    }
    
    func collectData(typeIndex : Int, value : Int, timeStamp : Float){
        let sa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ScoutingActivity") as! ScoutingActivity
        self.dataPoints.append(DataPoint.init(type_index: typeIndex, value: value, time: timeStamp))
        sa.encodeData(dataPoints : self.dataPoints)
    }
    
    @objc func collectQRCodeData(sender : AnyObject){
        if let button = sender as? Button{
            collectData(typeIndex: button.tag, value: button.value, timeStamp: getTimeStamp())
            for i in 0..<listOfButtonFields.count{
                if(listOfButtonFields[i].tag == button.tag){
                    listOfCounters[button.tag]! += 1
                    listOfButtonFields[i].counter = listOfCounters[button.tag]!
                    listOfButtonFields[i].setUpButtonField()
                }
            }
        }
        if let switchField = sender as? Switch{
            if switchField.value == 0{
                switchField.backgroundColor = self.backgroundColor
                switchField.setTitleColor(UIColor.white, for: .normal)
                listOfSwitchValues[switchField.tag] = 1
                switchField.value = listOfSwitchValues[switchField.tag] ?? 0
                collectData(typeIndex: switchField.tag, value: switchField.value, timeStamp: getTimeStamp())
                
            } else {
                switchField.backgroundColor = UIColor.systemGray5
                switchField.setTitleColor(self.backgroundColor, for: .normal)
                listOfSwitchValues[switchField.tag] = 0
                switchField.value = listOfSwitchValues[switchField.tag] ?? 0
                collectData(typeIndex: switchField.tag, value: switchField.value, timeStamp: getTimeStamp())

            }
        }
        
        if let toggleField = sender as? ToggleButton{
            for i in 0..<listOfToggleFields.count{
                if toggleField.tag == listOfToggleFields[i][0].tag{
                    for k in 0..<listOfToggleFields[i].count{
                        if(toggleField.value == listOfToggleFields[i][k].value){
                            listOfToggleFields[i][k].backgroundColor = self.backgroundColor
                            listOfToggleFields[i][k].setTitleColor(UIColor.white, for: .normal)
                            listOfToggleFieldValues[toggleField.tag] = toggleField.value
                        } else {
                            listOfToggleFields[i][k].backgroundColor = UIColor.systemGray5
                            listOfToggleFields[i][k].setTitleColor(self.backgroundColor, for: .normal)
                        }
                    }
                }
            }

            if (toggleField.tag == 7 || toggleField.tag == 15){
                selectedValue = toggleField.value
            }
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
        //Find a way to not hard code this
        for i in 0..<listOfToggleFields.count{
            for k in 0..<listOfToggleFields[i].count{
                if (listOfToggleFields[i][k].tag == 7 || listOfToggleFields[i][k].tag == 15) {
                    if listOfToggleFields[i][k].value == selectedValue{
                        listOfToggleFields[i][k].backgroundColor = self.backgroundColor
                        listOfToggleFields[i][k].setTitleColor(UIColor.white, for: .normal)
                    } else {
                        listOfToggleFields[i][k].backgroundColor = UIColor.systemGray5
                        listOfToggleFields[i][k].setTitleColor(self.backgroundColor, for: .normal)
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.index ?? 0 <= 2 {
            createScoutingStackView()
        } else {
            createQRCode()
        }
    }
}
