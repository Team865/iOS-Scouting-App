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
    var tags : [String] = []
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
            self.tags = screenLayout.robot_scout.tags
            
            if (board == "BX" || board == "RX"){
                self.screens = screenLayout.super_scout.screens
                self.tags = screenLayout.super_scout.tags
            }
            convertLayoutToItems(layout: self.screens)
        } catch let err{
            print(err)
        }
    }
    
    func getCommentOptions(index : Int){
        self.index = index

        var tags = self.lookUpTag(screen: screens)
         if (self.board == "BX" || self.board == "RX"){
            for i in 0..<self.tags.count{
                let fieldData = FieldData()
                fieldData.setUpField(name: self.formatTeamTitles(string: self.tags[i], currentTeam: self.currentTeams, opposingTeam: self.opposingTeams), type: "Checkbox", choice: [], is_lite: false, tag: tags, default_choice: 0, scoutingActivity: self.scoutingActivity!)
                self.scoutingActivity?.commentOptions.append(fieldData)
                tags += 1
            }
        } else {
            for i in 0..<self.tags.count{
                let fieldData = FieldData()
                fieldData.setUpField(name: self.formatTitleOfItem(string: self.tags[i]), type: "Checkbox", choice: [], is_lite: false, tag: tags, default_choice: 0, scoutingActivity: self.scoutingActivity!)
                self.scoutingActivity?.commentOptions.append(fieldData)
                tags += 1
            }
        }
    }
    
    func formatTitleOfItem(string : String) -> String{
        let titleArr = string.components(separatedBy: "_")
        var title = ""
        
        for i in 0..<titleArr.count{
            title += titleArr[i].prefix(1).capitalized + titleArr[i].dropFirst()
            if (i != titleArr.count - 1){
                title += " "
            }
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
                    let teamIndex = Int(arr[i].suffix(1)) ?? 1
                    arr[i] = currentTeam[teamIndex - 1]
                } else if (arr[i].prefix(1) == "O" && (Int(arr[i].suffix(1)) != nil)){
                    let index = Int(arr[i].suffix(1)) ?? 1
                    arr[i] = opposingTeam[index - 1]
                }
                formatted += arr[i]
                
                if (i != arr.count - 1){
                    formatted += "_"
                }
            }
        }
        
        let newFormat = self.formatTitleOfItem(string: formatted)
        return newFormat
    }
    
    func formatTitleArrays(string : [String], currentTeam : [String], opposingTeam : [String]) -> [String]{
        var mutatedArr = string
        
        for i in 0..<string.count{
            if (string[i].prefix(1) == "A" && Int(string[i].suffix(1)) != nil){
                let index = Int(string[i].suffix(1)) ?? 0
                mutatedArr[i] = currentTeam[index - 1]
            } else {
                mutatedArr[i] = string[i]
                mutatedArr[i] = mutatedArr[i].prefix(1).capitalized + mutatedArr[i].dropFirst() + " "
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
                
                let choice = (self.board == "BX" || self.board == "RX") ? formatTitleArrays(string: currentItem.choices ?? [], currentTeam: self.currentTeams, opposingTeam: self.opposingTeams) : currentItem.choices ?? []
                
                let fieldItem = FieldData()
                fieldItem.setUpField(name: name, type: currentItem.type, choice: choice, is_lite: currentItem.is_lite ?? false, tag: tag, default_choice : currentItem.default_choice ?? 0, scoutingActivity: self.scoutingActivity!)
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


