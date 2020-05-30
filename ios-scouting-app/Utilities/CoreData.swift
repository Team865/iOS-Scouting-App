//
//  CoreData.swift
//  Scouting
//
//  Created by DUC LOC on 5/25/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreData{
    /*
     Process of saving data to core and using it:
     Move -> Save -> Fetch -> Load
     */
    
    var matchSchedules : [NSManagedObject] = []
    var listOfEvents : [NSManagedObject] = []
    var idsAndKeys = IDsAndKeys()
    
    func moveListOfEventsToCore(listOfEvents : [Events]){
        self.listOfEvents.removeAll()
        for i in 0..<listOfEvents.count{
            saveListOfEventsToCore(name: listOfEvents[i].name, info: listOfEvents[i].info, key: listOfEvents[i].key)
        }
    }
    
    
    func moveMatchScheduleToCore(matchSchedule : [MatchSchedule]){
        for i in 0..<matchSchedule.count{
            let redAlliance = matchSchedule[i].redAlliance[0] + " " + matchSchedule[i].redAlliance[1] + " " + matchSchedule[i].redAlliance[2]
            let blueAlliance = matchSchedule[i].blueAlliance[0] + " " + matchSchedule[i].blueAlliance[1] + " " + matchSchedule[i].blueAlliance[2]
            
            self.saveMatchScheduleToCore(redAlliance: redAlliance, blueAlliance: blueAlliance, matchNumber: matchSchedule[i].matchNumber, imageName: matchSchedule[i].imageName, board: matchSchedule[i].board, isScouted: matchSchedule[i].isScouted, scoutedData: matchSchedule[i].scoutedData)
        }
    }
    
    func saveListOfEventsToCore(name : String, info : String, key : String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: self.idsAndKeys.eventsCoreID,
                                       in: managedContext)!
        
        let currentEvent = NSManagedObject(entity: entity,
                                            insertInto: managedContext)
        
        // 3
        currentEvent.setValue(name, forKey: self.idsAndKeys.eventNames)
        currentEvent.setValue(info, forKeyPath: self.idsAndKeys.eventInfos)
        currentEvent.setValue(key, forKey: self.idsAndKeys.eventKeys)
        
        //4
        do {
            try managedContext.save()
            listOfEvents.append(currentEvent)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveMatchScheduleToCore(redAlliance : String, blueAlliance : String, matchNumber : Int, imageName : String, board : String, isScouted : Bool, scoutedData : String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: self.idsAndKeys.matchScheduleCoreID,
                                       in: managedContext)!
        
        let matchSchedule = NSManagedObject(entity: entity,
                                            insertInto: managedContext)
        
        // 3
        matchSchedule.setValue(redAlliance, forKey: self.idsAndKeys.redAlliance)
        matchSchedule.setValue(blueAlliance, forKey: self.idsAndKeys.blueAlliance)
        matchSchedule.setValue(Int16(matchNumber), forKey: self.idsAndKeys.matchNumber)
        matchSchedule.setValue(board, forKey: self.idsAndKeys.boards)
        matchSchedule.setValue(imageName, forKey: self.idsAndKeys.imageName)
        matchSchedule.setValue(scoutedData, forKey: self.idsAndKeys.scoutedData)
        matchSchedule.setValue(isScouted, forKey: self.idsAndKeys.isScouted)
        
        // 4
        do {
            try managedContext.save()
            matchSchedules.append(matchSchedule)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func clearCoreData(entity : String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let managedContext = appDelegate.persistentContainer.viewContext
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
        
       
    }
    
    func loadMatchScheduleFromCore() -> [MatchSchedule]{
        var tempArr : [MatchSchedule] = []
        
        for i in 0..<self.matchSchedules.count{
            let rA = matchSchedules[i].value(forKey: self.idsAndKeys.redAlliance) as! String
            let redAlliance = rA.components(separatedBy: " ")
            
            let bA = matchSchedules[i].value(forKey: self.idsAndKeys.blueAlliance) as! String
            let blueAlliance = bA.components(separatedBy: " ")
            
            let matchSchedule = MatchSchedule()
            matchSchedule.setUpMatchSchedule(imageName: matchSchedules[i].value(forKey: self.idsAndKeys.imageName) as! String, matchNumber: matchSchedules[i].value(forKey: self.idsAndKeys.matchNumber) as! Int, redAlliance: redAlliance, blueAlliance: blueAlliance, board: matchSchedules[i].value(forKey: self.idsAndKeys.boards) as! String, isScouted: matchSchedules[i].value(forKey: self.idsAndKeys.isScouted) as! Bool, scoutedData: matchSchedules[i].value(forKey: self.idsAndKeys.scoutedData) as! String)
            
            tempArr.append(matchSchedule)
        }
        
        return tempArr
    }
    
    func loadListOfEventsFromCore() -> [Events] {
        var tempArr : [Events] = []
        
        for i in 0..<self.listOfEvents.count{
            let event = Events(name: self.listOfEvents[i].value(forKey: self.idsAndKeys.eventNames) as! String, info: self.listOfEvents[i].value(forKey: self.idsAndKeys.eventInfos) as! String, key: self.listOfEvents[i].value(forKey: self.idsAndKeys.eventKeys) as! String)
            tempArr.append(event)
        }
        
        return tempArr
    }
    
    func fetchDataFromCore(){
        //1
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "MatchScheduleCore")
        let fetchRequest2 =
        NSFetchRequest<NSManagedObject>(entityName: "EventsCore")
        //3
        do {
            self.listOfEvents = try managedContext.fetch(fetchRequest2)
            self.matchSchedules = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveUIElementsContent(viewController : ViewController){
        UserDefaults.standard.set(viewController.selectedBoard, forKey: self.idsAndKeys.selectedBoard)
        UserDefaults.standard.set(viewController.scoutName, forKey: self.idsAndKeys.scoutName)
    }
    
    //This includes currentEventLabel.text, selectedBoard, and scoutName
    func loadUIElementsContent(viewController : ViewController){
        if let selectedBoard = UserDefaults.standard.object(forKey: self.idsAndKeys.selectedBoard) as? String {
            viewController.selectedBoard = selectedBoard
        }
        
        if let scoutName = UserDefaults.standard.object(forKey: self.idsAndKeys.scoutName) as? String {
            viewController.scoutName = scoutName
        }
    }
    
    func saveSelectedEventEntry(viewController : ViewController){
        UserDefaults.standard.set(viewController.selectedEvent?.info, forKey: self.idsAndKeys.currentEventInfo)
        UserDefaults.standard.set(viewController.selectedEvent?.name, forKey: self.idsAndKeys.currentEventName)
        UserDefaults.standard.set(viewController.selectedEvent?.key, forKey: self.idsAndKeys.currentEventKey)
    }
    
    func loadSelectedEventEntry() -> Events{
        var event = Events(name: "Current Event : None", info: "", key: "")
        if let info = UserDefaults.standard.object(forKey: self.idsAndKeys.currentEventInfo) as? String,
            let name = UserDefaults.standard.object(forKey: self.idsAndKeys.currentEventName) as? String,
            let key = UserDefaults.standard.object(forKey: self.idsAndKeys.currentEventKey) as? String {
            event = Events(name: name, info: info, key: key)
        }
        return event
    }
    
    
}
