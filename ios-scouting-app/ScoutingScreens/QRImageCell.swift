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
    let image = UIImageView()
    let view = UITextView()
    var qrCodeGenerator = QRCodeGenerator()
    var scoutingActivity = ScoutingActivity()
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    func setUpQRImage(){
        view.frame = CGRect(x : 2.5, y : self.bounds.height / 1.5, width: self.bounds.width - 5, height :  self.bounds.height / 5)
        view.textAlignment = .center
        view.text = self.scoutingActivity.qrEntry.getQRData()
        view.textColor = UIColor.black
        view.isUserInteractionEnabled = false
        view.font = view.font?.withSize(CGFloat(Double(UIScreen.main.bounds.height) * 0.025))
        view.contentSize = CGSize(width: self.view.contentSize.width, height: self.view.contentSize.height)
        
        let qrCode = self.qrCodeGenerator.generateQRCode(from: self.scoutingActivity.qrEntry.getQRData())
        
        image.image = qrCode
        image.frame = CGRect(x : 2.5, y : 0, width: self.bounds.width - 5, height: self.bounds.height / 1.5)
        
        addSubview(image)
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
