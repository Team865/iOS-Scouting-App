//
//  ScoutingPageViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class ScoutingPagerViewController : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    let images = ["timer", "team", "paste", "layers2"]

    let scoutingScreensTitle = ["Auto", "Teleop", "Endgame"]
    
    var selectedBoardLabel : UILabel!
        var matchNumberLabel : UILabel!
        var teamNumberLabel : UILabel!
        var timeLeft : UILabel!

        var boardName = ""
        var teamNumber = ""
        var matchNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setViewControllers([scoutingScreens[0]], direction: .forward, animated: true)
        
        self.delegate = self
        self.dataSource = self
        }
   
    required init?(coder: NSCoder) {
        super.init(transitionStyle : .scroll, navigationOrientation : .horizontal, options : nil)
    }
    
    lazy var scoutingScreens : [UIViewController] = {
            return [
                UIStoryboard(name : "Main", bundle: nil).instantiateViewController(identifier: "Auto"),
                UIStoryboard(name : "Main", bundle: nil).instantiateViewController(identifier: "Teleop"),
                UIStoryboard(name : "Main", bundle: nil).instantiateViewController(identifier: "Endgame")
        ]
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.scoutingScreens.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex : Int = scoutingScreens.firstIndex(of: viewController) ?? 0
        
        if (currentIndex <= 0){
            return nil
        }
        
        return scoutingScreens[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex : Int = scoutingScreens.firstIndex(of: viewController) ?? 0
        
        if (currentIndex >= scoutingScreens.count - 1)
        {
         return nil
        }
        return scoutingScreens[currentIndex + 1]
    }
}
