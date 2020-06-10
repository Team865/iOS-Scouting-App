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
    func setTimeStamp(timeStamp : Float){
        self.timeStamp = timeStamp
    }
    
    func getTimeStamp() -> Float{
        return self.timeStamp
    }
    
    func startTimer(scoutingActivity : ScoutingActivity){
        scoutingActivity.StartTimerButton.isHidden = true
        scoutingActivity.PauseButton.isHidden = false
        scoutingActivity.PlayButton.isHidden = true
        scoutingActivity.UndoButton.isHidden = false
        
        scoutingActivity.PauseButton.tintColor = UIColor.black
        
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
            
        }
        
        scoutingActivity.isStarted = true
        
        for i in 0..<scoutingActivity.listOfInputControls.count{
            scoutingActivity.listOfInputControls[i].onTimerStarted()
        }
    }
    
    func pauseTimer(scoutingActivity : ScoutingActivity){
        scoutingActivity.progressBar.isEnabled = true
        
        scoutingActivity.PlayButton.isHidden = false
        scoutingActivity.PauseButton.isHidden = true
        
        scoutingActivity.PauseButton.tintColor = UIColor.black
        
        scoutingActivity.progressBarTimer.invalidate()
        scoutingActivity.totalProgress = scoutingActivity.progressBar.value
        scoutingActivity.progressBar.value = scoutingActivity.totalProgress
        
        self.setTimeStamp(timeStamp: scoutingActivity.totalProgress)
        
        updateTimer(scoutingActivity: scoutingActivity)
    }
    
    func resumeTimer(scoutingActivity : ScoutingActivity){
        scoutingActivity.PlayButton.isHidden = true
        scoutingActivity.PauseButton.isHidden = false
        
        scoutingActivity.progressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){
            (timer) in
            guard scoutingActivity.totalProgress <= 1 else {
                timer.invalidate()
                return
            }
            
            scoutingActivity.totalProgress = (scoutingActivity.totalProgress * 150 + 0.01) / 150
            
            scoutingActivity.progressBar.value = scoutingActivity.totalProgress
            scoutingActivity.progressBar.isEnabled = false
            self.updateTimer(scoutingActivity: scoutingActivity)
            
        }
    }
    
    func updateTimer(scoutingActivity : ScoutingActivity){
        var totalTime : Float = 0
        var numberOf0s = ""
        var color = UIColor()
        let currentTime = (150 * scoutingActivity.totalProgress).rounded()
        self.setTimeStamp(timeStamp: (150 * scoutingActivity.totalProgress))
        
        if(currentTime < 15.0){
            totalTime = 15
            color = UIColor(red:0.80, green:0.60, blue:0.00, alpha:1.00)
        } else if (currentTime >= 15 && currentTime < 120.0){
            totalTime = 150
            color = UIColor.systemGreen
        } else if (currentTime >= 120){
            totalTime = 150
            color = UIColor.systemRed
        }
        
        var timeLeft = String(totalTime - currentTime)
        
        for _ in 0..<(5 - timeLeft.count){
            numberOf0s += "0"
        }
        
        timeLeft = numberOf0s + String(timeLeft.prefix(timeLeft.count - 2))
        
        scoutingActivity.listOfLabels[3].text = timeLeft
        scoutingActivity.listOfLabels[3].textColor = color
        
        for i in 0..<scoutingActivity.listOfInputControls.count{
            scoutingActivity.listOfInputControls[i].updateControlState()
        }
    }
}
