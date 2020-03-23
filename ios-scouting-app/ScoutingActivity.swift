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
    
    var matchNumberLabel : UILabel!
    var teamNumberLabel : UILabel!
    var selectedBoardLabel : UILabel!
    var timeLeft : UILabel!
    
    var matchNumber = ""
    var teamNumber = ""
    var boardName = ""
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    let images = ["timer", "team", "paste", "layers2"]
    
    let screenTitle = ["Auto", "Teleop", "Endgame", "QRCode"]
    
    var currentScreenIndex = 0
    
    //Button controllers
    var hideStartTimer = false
    var hidePlayButton = true
    var hidePauseButton = true
    var hideUndoButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        view.addSubview(scoutingView)
        configurePageViewController()
    }
    
    //UI Configurations
    
    lazy var scoutingView : UIView = {
        let view = UIView(frame : CGRect(x: 0, y: Double(self.screenHeight) * 0.1, width: Double(self.screenWidth), height: Double(self.screenHeight) * 0.9))
        
        return view
    }()
    
    func createLabel() -> UILabel{
        let label = UILabel(frame : CGRect(x : 0, y : 0, width : 30, height : 15))
        label.textAlignment = .center
        return label
    }
    
    func createIcon(imageName : String) -> UIImageView{
        let icon = UIImageView(frame: CGRect(x : 0, y : 0, width : 10, height : 15))
        icon.image = UIImage(named: imageName)
        return icon
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
        
        if index >= self.screenTitle.count || self.screenTitle.count == 0 {
            return nil
        }
        
        guard let scoutingScreen = UIStoryboard(name : "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing : ScoutingScreen.self)) as? ScoutingScreen else { return nil }
        
        scoutingScreen.index = index
        scoutingScreen.displayText = self.screenTitle[index]
        scoutingScreen.StartTimerButton.isHidden = self.hideStartTimer
        scoutingScreen.PlayButton.isHidden = self.hidePlayButton
        scoutingScreen.PauseButton.isHidden = self.hidePauseButton
        scoutingScreen.undoButton.isHidden = self.hideUndoButton
        
        scoutingScreen.matchNumber = self.matchNumber
        scoutingScreen.teamNumber = self.teamNumber
        scoutingScreen.boardName = self.boardName
        
        return scoutingScreen
    }
}

extension ScoutingActivity : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentScreenIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return screenTitle.count
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
        
        print(self.hideStartTimer)
        
        currentIndex -= 1
        
        
        return scoutingScreenAtIndex(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let scoutingScreen = viewController as? ScoutingScreen
        
        guard var currentIndex = scoutingScreen?.index else {
            return nil
        }
        
        if currentIndex == self.screenTitle.count{
            return nil
        }
        
        currentIndex += 1
        
        print(self.hideStartTimer)
        
        currentScreenIndex = currentIndex
        
        
        return scoutingScreenAtIndex(index: currentIndex)
    }
}
