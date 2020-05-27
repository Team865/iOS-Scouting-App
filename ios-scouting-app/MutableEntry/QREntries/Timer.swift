//
//  Timer.swift
//  Scouting
//
//  Created by DUC LOC on 5/19/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class DataTimer {
    var timeStamp : Float = 0
    var isStarted = false
    
    func setTimeStamp(timeStamp : Float){
        self.timeStamp = timeStamp
    }
    
    func getTimeStamp() -> Float{
        return self.timeStamp
    }
    
    func startTimer(scoutingActivity : ScoutingActivity){
        scoutingActivity.progressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){
            (timer) in
            guard scoutingActivity.progress.isFinished == false else {
                timer.invalidate()
                return
            }
            scoutingActivity.progress.completedUnitCount += 1
            scoutingActivity.totalProgress = Float(scoutingActivity.progress.fractionCompleted)
            scoutingActivity.progressBar.value = scoutingActivity.totalProgress
            
            self.updateTimer(scoutingActivity: scoutingActivity)
            
            self.isStarted = true
            
            for i in 0..<scoutingActivity.listOfInputControls.count{
                scoutingActivity.listOfInputControls[i].onTimerStarted()
            }
        }
    }
    
    func pauseTimer(scoutingActivity : ScoutingActivity){
        scoutingActivity.progressBar.isEnabled = true
        
        scoutingActivity.progressBarTimer.invalidate()
        scoutingActivity.totalProgress = scoutingActivity.progressBar.value
        scoutingActivity.progressBar.value = scoutingActivity.totalProgress
        
        self.setTimeStamp(timeStamp: scoutingActivity.totalProgress)
    }
    
    func resumeTimer(scoutingActivity : ScoutingActivity){
        scoutingActivity.progressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){
            (timer) in
            guard scoutingActivity.totalProgress <= 1 else {
                timer.invalidate()
                return
            }
            
            self.updateTimer(scoutingActivity: scoutingActivity)
            scoutingActivity.progressBar.value = scoutingActivity.totalProgress
            scoutingActivity.progressBar.isEnabled = false
        }
    }
    
    func updateTimer(scoutingActivity : ScoutingActivity){
        var totalTime : Float = 0
        var numberOf0s = ""
        var color = UIColor()
        if(165 * scoutingActivity.totalProgress < 15.0){
            totalTime = 15
            color = UIColor(red:0.80, green:0.60, blue:0.00, alpha:1.00)
        } else if (165 * scoutingActivity.totalProgress >= 15 && 165 * scoutingActivity.totalProgress < 135.0){
            totalTime = 135
            color = UIColor.green
        } else if (165 * scoutingActivity.totalProgress >= 135){
            totalTime = 165
            color = UIColor.red
        }
        
        var timeLeft = String(totalTime - round(165 * scoutingActivity.totalProgress))
        
        for _ in 0..<(5 - timeLeft.count){
            numberOf0s += "0"
        }
        
        timeLeft = numberOf0s + String(timeLeft.prefix(timeLeft.count - 2))
        
        scoutingActivity.listOfLabels[3].text = timeLeft
        scoutingActivity.listOfLabels[3].textColor = color
        
        self.setTimeStamp(timeStamp: scoutingActivity.totalProgress)
    }
}
