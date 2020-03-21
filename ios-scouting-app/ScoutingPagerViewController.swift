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

    let scoutingScreensTitle = ["Auto", "Teleop", "Endgame", "QRCode"]
    
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
    }
    
    lazy var scoutingScreens : [UIViewController] = {
        var listOfVC : [UIViewController] = []
        for i in 0..<self.scoutingScreensTitle.count{
//            listOfVC.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: self.scoutingScreensTitle[i]))
        }
        
        return listOfVC
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var view = UIViewController()
        return view
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var view = UIViewController()
        return view
    }
}
