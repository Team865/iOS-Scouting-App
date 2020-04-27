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
        backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
