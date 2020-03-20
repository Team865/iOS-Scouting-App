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
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        collectionView?.register(ScoutingScreenCells.self, forCellWithReuseIdentifier: "scoutingScreen")
        collectionView?.isPagingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoutingScreen", for: indexPath) as! ScoutingScreenCells
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
