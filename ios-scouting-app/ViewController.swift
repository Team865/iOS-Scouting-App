//
//  ViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 2/21/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var matchTable: UITableView!
    var matches : [matchSchedule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        matches = createMatchSchedule()
        
        
    }

    private func setupNavigationBar(){
        let addIconButton = UIButton(type: .system)
        addIconButton.setImage(UIImage(named: "addIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addIconButton.frame = CGRect(x : 0, y : 0, width : 34, height : 34)
        
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(named : "settingsIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: settingButton), UIBarButtonItem(customView: addIconButton)]
        }
    
    func createMatchSchedule() -> [matchSchedule]{
        var tempMatch : [matchSchedule] = []
        
        for i in 0...10{
            let match = matchSchedule(icon : UIImage(named : "database")!, matchNumber: String(i), blueAlliance: "hi", redAlliance: "hello")
            tempMatch.append(match)
        }
        return tempMatch
    }
}
extension ViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let match = matches[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Alliances") as! matchScheduleCells
        cell.setMatch(match: match)
        
        return cell
    }
    
    
    
   
    
    
}
