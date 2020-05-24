//
//  Parser.swift
//  Scouting
//
//  Created by DUC LOC on 5/23/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
class Parser {
    var screenLayout : ScoutingScreenLayout!
    var board = ""
    func getLayoutForScreenWithBoard(board : String){
        self.board = board
        do {
            let url = Bundle.main.url(forResource: "layout", withExtension: "json")
            let jsonData = try Data(contentsOf : url!)
            screenLayout = try JSONDecoder().decode(ScoutingScreenLayout.self, from : jsonData)
            convertLayoutToItems(layout: screenLayout)
        } catch let err{
            print(err)
        }
    }
    
    func convertLayoutToItems(layout : ScoutingScreenLayout){
        var screens = layout.robot_scout.screens
        
        if (board == "BX" || board == "RX"){
            screens = layout.super_scout.screens
        }
        
    }
}

    
