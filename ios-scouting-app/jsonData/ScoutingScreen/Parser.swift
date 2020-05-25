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
    var listOfFieldData = [[fieldData]]()
    var board = ""
    var index = 0
    var screens : [screens] = []
    func getLayoutForScreenWithBoard(board : String, index : Int){
        self.board = board
        self.index = index
        self.listOfFieldData.removeAll()
        do {
            let url = Bundle.main.url(forResource: "layout", withExtension: "json")
            let jsonData = try Data(contentsOf : url!)
            screenLayout = try JSONDecoder().decode(ScoutingScreenLayout.self, from : jsonData)
            
            self.screens = screenLayout.robot_scout.screens
            
            if (board == "BX" || board == "RX"){
                self.screens = screenLayout.super_scout.screens
            }
            
            convertLayoutToItems(layout: self.screens)
        } catch let err{
            print(err)
        }
    }
    
    func formatTitleOfItem(string : String) -> String{
        let titleArr = string.components(separatedBy: "_")
        var title = ""
        
        for i in 0..<titleArr.count{
            title += titleArr[i].prefix(1).capitalized + titleArr[i].dropFirst() + " "
        }
        
        return title
    }
    
    //Format title for super scouting
    func formatTitle(string : String, currentTeam : [String], opposingTeam : [String]) -> String{
        var arr = string.components(separatedBy: "_")
        
        var formatted = ""
        
        for i in 0..<arr.count{
            if (arr[i].prefix(1) == "A" && (Int(arr[i].suffix(1)) != nil)){
                let index = Int(arr[i].suffix(1)) ?? 0
                arr[i] = currentTeam[index - 1]
            } else if (arr[i].prefix(1) == "O" && (Int(arr[i].suffix(1)) != nil)){
                let index = Int(arr[i].suffix(1)) ?? 0
                arr[i] = opposingTeam[index - 1]
            }
            formatted += (arr[i] + "_")
        }
        
        
        
        return formatted
    }
    
    func formatChoices(string : [String], currentTeam : [String], opposingTeam : [String]) -> [String]{
        var mutatedArr = string
        
        for i in 0..<string.count{
            if (string[i].prefix(1) == "A" && Int(string[i].suffix(1)) != nil){
                let index = Int(string[i].suffix(1)) ?? 0
                mutatedArr[i] = currentTeam[index - 1]
            } else {
                mutatedArr[i] = string[i]
            }
            
        }
        
        return mutatedArr
    }
    
    func getScreenTitles() -> [String]{
        var arr : [String] = []
        for i in 0..<screens.count{
            arr.append(screens[i].title)
            
        }
        
        return arr
    }
    
    func convertLayoutToItems(layout : [screens]){
        var tag = lookUpTag(screen : screens)
        
        for k in 0..<screens[self.index].layout.count{
            var itemsInRow : [fieldData] = []
            for j in 0..<screens[self.index].layout[k].count{
                let currentItem = screens[self.index].layout[k][j]
                let fieldItem = fieldData(name: formatTitleOfItem(string: currentItem.name), type: currentItem.type, choice: currentItem.choices ?? [], is_lite: currentItem.is_lite ?? false, tag: tag, default_choice : currentItem.default_choice)
                tag += 1
                itemsInRow.append(fieldItem)
            }
            self.listOfFieldData.append(itemsInRow)
        }
        
        
    }
    
    func lookUpTag(screen : [screens]) -> Int {
        var prevTag = 0
        
        for i in 0..<self.index{
            for k in 0..<screen[i].layout.count{
                for _ in 0..<screen[i].layout[k].count{
                    prevTag += 1
                }
            }
        }
        
        return prevTag
    }
}


