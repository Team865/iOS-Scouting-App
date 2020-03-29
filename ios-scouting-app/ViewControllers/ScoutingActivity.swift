//
//  ScoutingActivity.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/22/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class ScoutingActivity : UIViewController{
    //var scoutingScreens = [UIPageViewController]()
    let navBarWidth = UIScreen.main.bounds.width
    let navBarHeight = Double(UIScreen.main.bounds.height * 0.1)
    
    let Ymultiplier = 1.325
    let heightMultiplier = 0.6
    let buttonsWidth = UIScreen.main.bounds.width * 0.15
    var comment = ""
    
    var listOfLabels : [UILabel] = []
    var navBarView : UIView!
    
    var matchNumber = ""
    var teamNumber = ""
    var boardName = ""
    var timeOnStart = "015"
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    let images = ["timer", "team", "paste", "layers2"]
    
    var screenTitles : [String] = []
    
    var currentScreenIndex = 0
    
    var screenLayout : ScoutingScreenLayout!
    
    //Button controllers
    var hideStartTimer = false
    var hidePlayButton = true
    var hidePauseButton = true
    var hideUndoButton = true
    
    //Progress bar
    var progressBarTimer : Timer!
    var totalProgress : Float = 0
    let progress = Progress(totalUnitCount: 16500)
    
    var names : [String] = []
    var types : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scoutingView)
        view.addSubview(StartTimerButton)
        view.addSubview(PauseButton)
        view.addSubview(PlayButton)
        view.addSubview(commentButton)
        view.addSubview(undoButton)
        view.addSubview(progressBar)
        
        self.navBarView = self.createNavBarView()
        setUpNavigationBar()
        getLayoutForScreen{
            for i in 0..<self.screenLayout.robot_scout.screens.count{
                self.screenTitles.append(self.screenLayout.robot_scout.screens[i].title)
            }
            self.configurePageViewController()
        }
    }
    
    func getLayoutForScreen(completed : @escaping () -> ()){
        do {
            let url = Bundle.main.url(forResource: "layout", withExtension: "json")
            let jsonData = try Data(contentsOf : url!)
            self.screenLayout = try JSONDecoder().decode(ScoutingScreenLayout.self, from : jsonData)
            
            DispatchQueue.main.async{
                completed()
            }
            
        } catch let err{
            print(err)
        }
    }
    
    //UI Configurations
    lazy var scoutingView : UIView = {
        let view = UIView(frame : CGRect(x: 0, y: Double(self.screenHeight) * 0.1, width: Double(self.screenWidth), height: Double(self.screenHeight) * 0.9))
        
        return view
    }()
    
    func createLabels(x : Double, y : Double, width : Double, height : Double, fontSize : CGFloat, text : String) -> UILabel{
        let label = UILabel(frame : CGRect(x : x, y : y, width : width, height : height))
        label.font = label.font.withSize(fontSize)
        label.textAlignment = .center
        
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
        let view = UIView(frame : CGRect(x : 0.0, y : 0.0, width: Double(UIScreen.main.bounds.width), height : Double(UIScreen.main.bounds.height * 0.1)))
        
        let navBarElementsHeight = Double(UIScreen.main.bounds.height * 0.08)
        let navBarElementY = Double(UIScreen.main.bounds.height * -0.02)
        let fontSize = CGFloat(navBarElementsHeight * 0.225)
        let navBarWidth = Double(UIScreen.main.bounds.width)
        let iconsWidth = Double(UIScreen.main.bounds.width * 0.1)
        
        let spacing = iconsWidth * 0.05
        var startingX = 0.0
        
        let listOfTexts = [self.matchNumber, self.boardName, self.teamNumber, String(self.timeOnStart)]
        let listOfIconNames = ["layers2", "paste", "users", "timer"]
        let listOfSpacing = [spacing, spacing, 0.0, spacing * 2]
        let listOfLabelWidth = [navBarWidth * 0.1, navBarWidth * 0.08, navBarWidth * 0.1, navBarWidth * 0.1]
        for i in 0..<listOfTexts.count{
            let label = self.createLabels(x: startingX + iconsWidth + listOfSpacing[i], y: navBarElementY, width: listOfLabelWidth[i], height: navBarElementsHeight, fontSize: fontSize, text : listOfTexts[i])
            label.text = listOfTexts[i]
            view.addSubview(self.createIcon(x: startingX, y: navBarElementY, width: iconsWidth, height: navBarElementsHeight, iconName: listOfIconNames[i]))
            
            if(i == 3){
                label.textColor = UIColor.systemYellow
            }
            
            view.addSubview(label)
            startingX += iconsWidth + listOfLabelWidth[i] + listOfSpacing[i]
            self.listOfLabels.append(label)
        }

        
        return view
    }
    
    private func setUpNavigationBar(){
    navigationItem.titleView = self.navBarView
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView : self.backButton)
    }
    
    lazy var backButton : UIButton = {
        let button = UIButton(frame : CGRect(x : 0, y : 0, width : 5, height : 15))
        button.setImage(UIImage(named : "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(self.clickHandler(srcObj:)), for: .touchUpInside)
        return button
    }()
    
    @objc func clickHandler(srcObj : UIButton){
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil)
        let main = mainVC.instantiateViewController(identifier: "MainController") as ViewController
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    lazy var progressBar : UIProgressView = {
        let progressBar = UIProgressView(frame : CGRect(x : Double(self.navBarWidth) * 0.02, y : Double(self.navBarHeight) * self.Ymultiplier * 0.875, width : Double(self.navBarWidth) * 0.96, height : Double(self.navBarHeight) * 0.25))
           progressBar.progress = 0
           return progressBar
       }()
    
    lazy var StartTimerButton : UIButton = {
               let button = UIButton(type : .system)
        button.frame = CGRect(x : Double(self.navBarWidth * 0.55), y : Double(self.navBarHeight) * self.Ymultiplier, width : Double(self.buttonsWidth * 2), height : Double(self.navBarHeight) * self.heightMultiplier * 0.75)
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
            button.frame = CGRect(x : Double(self.navBarWidth * 0.55), y : Double(navBarHeight) * self.Ymultiplier * 0.95, width : Double(self.buttonsWidth), height : Double(self.navBarHeight) * self.heightMultiplier)
               button.tag = 2
               button.setImage(UIImage(named : "pause"), for: .normal)
               button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
            button.isHidden = true
               return button
           }()

           lazy var PlayButton : UIButton = {
               let button = UIButton(type : .system)
            button.frame = CGRect(x : Double(self.navBarWidth * 0.55), y : Double(navBarHeight) * self.Ymultiplier * 0.95, width : Double(self.buttonsWidth), height : Double(self.navBarHeight) * self.heightMultiplier)
               button.tag = 3
               button.setImage(UIImage(named : "play"), for: .normal)
               button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
               button.isHidden = true
               return button
           }()

           lazy var undoButton : UIButton = {
               let button = UIButton(type : .system)
            button.frame = CGRect(x : Double(self.navBarWidth * 0.7), y : Double(navBarHeight) * self.Ymultiplier * 0.95 , width : Double(self.buttonsWidth), height : Double(self.navBarHeight) * self.heightMultiplier)
               button.tag = 4
               button.setImage(UIImage(named : "undo"), for: .normal)
               button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
               button.isHidden = true
               return button
           }()

           lazy var commentButton : UIButton = {
               let button = UIButton(type : .system)
            button.frame = CGRect(x : Double(self.navBarWidth * 0.85), y : Double(navBarHeight) * self.Ymultiplier * 0.95, width : Double(self.buttonsWidth), height : Double(self.navBarHeight) * self.heightMultiplier)
               button.tag = 5
               button.setImage(UIImage(named : "comments"), for: .normal)
               button.addTarget(self, action: #selector(clickHandler(sender:)), for: .touchUpInside)
               return button
           }()
        
    func updateTimer(){
        UserDefaults.standard.set(165 * self.totalProgress, forKey: "timeStamp")
        if(165 * self.totalProgress < 15.0){
            let time = 15 - round(165 * self.totalProgress)
            var timeLeft = String(time)
            
            switch timeLeft.count{
            case 5:
                timeLeft = String(timeLeft.prefix(3))
            case 4:
                timeLeft = "0" + String(timeLeft.prefix(2))
            case 3:
                timeLeft = "00" + String(timeLeft.prefix(1))
            default :
                break
            }
            
            self.listOfLabels[3].text = timeLeft
            self.listOfLabels[3].textColor = UIColor.systemYellow
            
        } else if (165 * self.totalProgress >= 15 && 165 * self.totalProgress < 135.0){
            let time = 135 - round(165 * self.totalProgress)
            var timeLeft = String(time)
            
            switch timeLeft.count{
            case 5:
                timeLeft = String(timeLeft.prefix(3))
            case 4:
                timeLeft = "0" + String(timeLeft.prefix(2))
            case 3:
                timeLeft = "00" + String(timeLeft.prefix(1))
            default :
                break
            }
            self.listOfLabels[3].text = timeLeft
            self.listOfLabels[3].textColor = UIColor.systemGreen
        } else if (165 * self.totalProgress >= 135){
            let time = 165 - round(165 * self.totalProgress)
            var timeLeft = String(time)
            
            switch timeLeft.count{
            case 5:
                timeLeft = String(timeLeft.prefix(3))
            case 4:
                timeLeft = "0" + String(timeLeft.prefix(2))
            case 3:
                timeLeft = "00" + String(timeLeft.prefix(1))
            default :
                break
            }
            
            self.listOfLabels[3].text = timeLeft
            self.listOfLabels[3].textColor = UIColor.red
        }
    }
    
        @objc func clickHandler(sender : UIButton){
            if(sender.tag == 1){
                StartTimerButton.isHidden = true
                PauseButton.isHidden = false
                PlayButton.isHidden = true
                undoButton.isHidden = false
                
                self.progressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){
                (timer) in
                guard self.progress.isFinished == false else {
                    timer.invalidate()
                    return
                }
                    self.progress.completedUnitCount += 1
                    self.totalProgress = Float(self.progress.fractionCompleted)
                    
                    self.updateTimer()
                    
                    self.progressBar.setProgress(self.totalProgress, animated: true)
                }
                
            } else if (sender.tag == 2){
                PlayButton.isHidden = false
                PauseButton.isHidden = true
                
                //self.progressBarTimer.invalidate()
                self.totalProgress = self.progressBar.progress
                print(self.totalProgress * 165)
                self.progressBar.setProgress(self.progressBar.progress, animated: true)

            } else if (sender.tag == 3){
                PlayButton.isHidden = true
                PauseButton.isHidden = false
                
                self.progressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){
                    (timer) in
                    guard self.progress.isFinished == false else {
                        timer.invalidate()
                        return
                    }
                    self.progress.completedUnitCount += 1
                    self.totalProgress = Float(self.progress.fractionCompleted)
                    self.updateTimer()
                    self.progressBar.setProgress(self.totalProgress, animated: true)
                    }
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
    
    func configurePageViewController(){
        guard let pageViewController = UIStoryboard(name : "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing : ScoutingScreenContainer.self)) as? ScoutingScreenContainer else { return }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        self.scoutingView.addSubview(pageViewController.view)

        guard let startingScoutingScreen = scoutingScreenAtIndex(index : currentScreenIndex) else { return }
        
        pageViewController.setViewControllers([startingScoutingScreen], direction: .forward, animated: true)
    }
    
    func scoutingScreenAtIndex(index : Int) -> ScoutingScreen?{
        
        if index >= self.screenTitles.count || self.screenTitles.count == 0 {
            return nil
        }
        
        guard let scoutingScreen = UIStoryboard(name : "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing : ScoutingScreen.self)) as? ScoutingScreen else { return nil }
        
        scoutingScreen.index = index
        scoutingScreen.screenTitles = self.screenTitles[index]
        scoutingScreen.numberOfRows = self.screenLayout.robot_scout.screens[index].layout.count

        for i in 0..<self.screenLayout.robot_scout.screens[index].layout.count{
           scoutingScreen.numberOfItemsInRow.append(self.screenLayout.robot_scout.screens[index].layout[i].count)
            var typesInRow : [String] = []
            var namesInRow : [String] = []
                for k in 0..<self.screenLayout.robot_scout.screens[index].layout[i].count{
                    typesInRow.append(self.screenLayout.robot_scout.screens[index].layout[i][k].type)
                    namesInRow.append(self.screenLayout.robot_scout.screens[index].layout[i][k].name)
                    scoutingScreen.nameOfMultiToggleItems.append(self.screenLayout.robot_scout.screens[index].layout[i][k].choices ?? [])
                   
                }
            scoutingScreen.typeOfItemsInRow.append(typesInRow)
            scoutingScreen.nameOfItemsInRow.append(namesInRow)

        }
        
        
        
        return scoutingScreen
    }
}

extension ScoutingActivity : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentScreenIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return screenTitles.count
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let scoutingScreen = viewController as? ScoutingScreen
        
        guard var currentIndex = scoutingScreen?.index else {
            return nil
        }
        
        currentScreenIndex = currentIndex
        if (currentIndex == 0){
            return nil
        }
        
        currentIndex -= 1
        
        
        return scoutingScreenAtIndex(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let scoutingScreen = viewController as? ScoutingScreen
        
        guard var currentIndex = scoutingScreen?.index else {
            return nil
        }
        
        if currentIndex == self.screenTitles.count{
            return nil
        }
        
        currentIndex += 1
        
        currentScreenIndex = currentIndex
        
        return scoutingScreenAtIndex(index: currentIndex)
    }
}
