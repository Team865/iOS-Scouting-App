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
    var progressBarTimer : Timer!
    var totalProgress : Float = 0.0
    let progress : Float = 15000
    var scoutingActivity : ScoutingActivity?
    
    var running = false
    
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
        
        self.scoutingActivity = scoutingActivity
        
        self.running = true
        
        self.progressBarTimer = Timer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.progressBarTimer, forMode: RunLoop.Mode.common)

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
        
        self.scoutingActivity?.progressBar.value = Float(self.totalProgress / progress * 100)
        
        self.progressBarTimer.invalidate()
    }
    
    func resumeTimer(scoutingActivity : ScoutingActivity){
        scoutingActivity.PlayButton.isHidden = true
        scoutingActivity.PauseButton.isHidden = false
        
        self.running = true
        
        self.scoutingActivity?.progressBar.isEnabled = false
        
        self.progressBarTimer = Timer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.progressBarTimer, forMode: RunLoop.Mode.common)
    }
    
    @objc func updateTimer(){
        var totalTime = 0
        var numberOf0s = ""
        var color = UIColor()
        
        if (running){
            self.totalProgress += 0.1
            self.scoutingActivity?.progressBar.value = self.totalProgress / progress * 100
        }
        
        if (self.scoutingActivity?.progressBar.value == 1.0){
            self.progressBarTimer.invalidate()
        }
        
        let currentTime = Int((self.totalProgress).rounded())
        self.setTimeStamp(timeStamp: (Float(self.totalProgress)))
        
        
        if(currentTime < 15){
            color = UIColor(red:0.80, green:0.60, blue:0.00, alpha:1.00)
            totalTime = 15
        } else if (currentTime >= 15 && currentTime < 120){
            totalTime = 150
            color = UIColor.systemGreen
        } else if (currentTime >= 120){
            totalTime = 150
            color = UIColor.systemRed
        }
        
        let timeLeft = String(totalTime - currentTime)
        
        for _ in 0..<(3 - timeLeft.count){
            numberOf0s += "0"
        }
        
        self.scoutingActivity?.listOfNavBarElement[3].setTitle(numberOf0s + timeLeft, for: .normal)
       
        self.scoutingActivity?.listOfNavBarElement[3].setTitleColor(color, for: .normal)
        
        let count = self.scoutingActivity?.listOfInputControls.count ?? 0
        
        for i in 0..<count{
            scoutingActivity?.listOfInputControls[i].updateControlState()
        }
    }
}
