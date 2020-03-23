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
        setViewControllers([scoutingScreens[0]], direction: .forward, animated: true)
        
        self.delegate = self
        self.dataSource = self
        }
   
    required init?(coder: NSCoder) {
        super.init(transitionStyle : .scroll, navigationOrientation : .horizontal, options : nil)
    }
    
    lazy var scoutingScreens : [UIViewController] = {
        var screens : [UIViewController] = []
        
        for i in 0..<3 {
            let screen = UIStoryboard(name : "Main", bundle: nil).instantiateViewController(identifier: String(describing : ViewController1.self)) as? ViewController1
            
            screens.append(screen!)
        }
        
        return screens
    }()
    
    
    
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
