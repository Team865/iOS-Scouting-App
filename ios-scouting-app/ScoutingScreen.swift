//
//  ViewController1.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit

class ScoutingScreen : UIViewController {

    var displayText : String?
    var index : Int?
    
    let viewWidth = UIScreen.main.bounds.width
    let viewHeight = Double(UIScreen.main.bounds.height * 0.1)
    
    lazy var label : UILabel = {
        let label = UILabel(frame : CGRect(x : Double(self.viewWidth) * 0.01, y : Double(self.viewHeight) * 0.02, width : Double(self.viewWidth) * 0.4, height : Double(self.viewHeight) * 0.35))
        label.font = label.font.withSize(CGFloat(self.viewHeight * 0.30))
        label.textAlignment = .left
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = self.displayText
        view.addSubview(label)
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
