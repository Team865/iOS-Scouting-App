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
    var scoutingActivity : ScoutingActivity?
    var listOfFieldData = [[FieldData]]()
    var board = ""
    var index = 0
    var currentTeams : [String] = []
    var opposingTeams : [String] = []
    var screens : [screens] = []
    func getLayoutForScreenWithBoard(board : String, index : Int, currentTeams : [String], opposingTeams : [String], scoutingActivity : ScoutingActivity){
        self.scoutingActivity = scoutingActivity
        self.board = board
        self.index = index
        self.currentTeams = currentTeams
        self.opposingTeams = opposingTeams
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
    func formatTeamTitles(string : String, currentTeam : [String], opposingTeam : [String]) -> String{
        var arr = string.components(separatedBy: "_")
        
        var formatted = ""
        
        if (currentTeam.count != 0 && opposingTeam.count != 0){
            for i in 0..<arr.count{
                if (arr[i].prefix(1) == "A" && (Int(arr[i].suffix(1)) != nil)){
                    let teamIndex = Int(arr[i].suffix(1)) ?? 0
                    arr[i] = currentTeam[teamIndex - 1]
                } else if (arr[i].prefix(1) == "O" && (Int(arr[i].suffix(1)) != nil)){
                    let index = Int(arr[i].suffix(1)) ?? 0
                    arr[i] = opposingTeam[index - 1]
                }
                formatted += (arr[i] + "_")
            }
        }
        
        
        formatted = self.formatTitleOfItem(string: formatted)
        
        return formatted
    }
    
    func formatTeamChoices(string : [String], currentTeam : [String], opposingTeam : [String]) -> [String]{
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
        
        for k in 0..<layout[self.index].layout.count{
            var itemsInRow : [FieldData] = []
            for j in 0..<layout[self.index].layout[k].count{
                let currentItem = layout[self.index].layout[k][j]
                
                let name = (self.board == "BX" || self.board == "RX") ? formatTeamTitles(string: currentItem.name, currentTeam: self.currentTeams, opposingTeam: self.opposingTeams) : formatTitleOfItem(string: currentItem.name)
                
                let choice = (self.board == "BX" || self.board == "RX") ? formatTeamChoices(string: currentItem.choices ?? [], currentTeam: self.currentTeams, opposingTeam: self.opposingTeams) : currentItem.choices ?? []
                
                var value = currentItem.default_choice
                if (currentItem.is_lite ?? false){
                    value = 1
                }
                
                let fieldItem = FieldData(name: name, type: currentItem.type, choice: choice, is_lite: currentItem.is_lite ?? false, tag: tag, default_choice : currentItem.default_choice, value: value ?? 0, scoutingActivity: self.scoutingActivity!)
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


