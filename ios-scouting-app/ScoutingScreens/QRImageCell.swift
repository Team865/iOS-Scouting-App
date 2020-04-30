//
//  QRImage.swift
//  Scouting
//
//  Created by DUC LOC on 4/27/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class QRImageCell : UICollectionViewCell{
    var qrCodeGenerator = QRCodeGenerator()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setUpQRImage()
    }
    
    func setUpQRImage(){
        let image = UIImageView()
        let view = UILabel()
        view.frame = CGRect(x : 2.5, y : self.bounds.height / 1.5 + 10, width: self.bounds.width - 5, height :  self.bounds.height / 5)
        view.textAlignment = .center
        view.text = "Hi"
        let qrCode = self.qrCodeGenerator.generateQRCode(from: "Hi")
        
        image.image = qrCode
        image.frame = CGRect(x : 2.5, y : 0, width: self.bounds.width - 5, height: self.bounds.height / 1.5)
        
        addSubview(image)
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
