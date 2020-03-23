//
//  ScoutingViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/20/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

//https://www.youtube.com/watch?v=a5yjOMLBfSc&t=759s

class ScoutingViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    var myCollectionView : UICollectionView!
    
    
    
    var scoutingScreens = ["Auto", "Teleop", "Endgame", "QRCode"]
    
    var listOfScoutingScreen : [ScoutingScreen] = []
    
    
    
    
    
    var screenNameLabel : UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.listOfScoutingScreen = self.createScoutingScreens()
        
        collectionView?.register(ScoutingScreenCells.self, forCellWithReuseIdentifier: "scoutingScreen")
        collectionView?.isPagingEnabled = true
    
        
//        view.addSubview(self.StartTimerButton)
//        view.addSubview(self.PauseButton)
//        view.addSubview(self.PlayButton)
//        view.addSubview(self.undoButton)
//        view.addSubview(self.commentButton)
    }
    
//UIConfigurations
    
    func reload(){
        print("reload")
        self.scoutingScreens.removeAll()
        DispatchQueue.main.async {
            self.listOfScoutingScreen = self.createScoutingScreens()
              self.myCollectionView?.reloadData()
                print("reloaded")
        }
    }
    
    
    
    func createScoutingScreens() -> [ScoutingScreen]{
        var tempScreen : [ScoutingScreen] = []
        for i in 0..<self.scoutingScreens.count{
            let screen = ScoutingScreen(title: self.scoutingScreens[i], matchNumber: "m1,", board: "b2")
            tempScreen.append(screen)
        }
        return tempScreen
    }
    
    private func createIcon(imageName : String) -> UIImageView{
        let image = UIImageView(frame : CGRect(x: 0, y: 0, width: 10, height: 15))
        image.image = UIImage(named: imageName)
        return image
    }
    
    private func createLabel() -> UILabel{
        let label = UILabel(frame : CGRect(x : 0, y : 0, width : 25, height : 15))
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfScoutingScreen.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let screen = self.listOfScoutingScreen[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoutingScreen", for: indexPath) as! ScoutingScreenCells
 
        cell.setScreen(screen: screen)
        print(indexPath.index(after: indexPath.row))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    //indexPath means how far the view is offset from the start
    
}
