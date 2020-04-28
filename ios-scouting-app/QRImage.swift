//
//  QRImage.swift
//  Scouting
//
//  Created by DUC LOC on 4/27/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class QRImage : UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setUpQRImage()
    }
    
    func setUpQRImage(){
        let image = UIImageView()
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.frame = CGRect(x : 2.5, y : self.bounds.height / 1.5 + 10, width: self.bounds.width - 5, height :  self.bounds.height / 4)
        
        image.image = UIImage(named: "jerry")
        image.frame = CGRect(x : 2.5, y : 0, width: self.bounds.width - 5, height: self.bounds.height / 1.5)
        
        addSubview(image)
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
