//
//  ScoutingScreenViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit

class ScoutingScreenViewController: UIViewController {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var index : Int?
    var screenTitle : String?
    lazy var screenTitleLabel : UILabel = {
        let label = UILabel(frame : CGRect(x : Double(self.screenWidth * 0.05), y : Double(self.screenHeight * 0.5), width : Double(self.screenWidth * 0.2), height : Double(self.screenHeight * 0.15)))
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenTitleLabel.text = title
        view.addSubview(screenTitleLabel)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
