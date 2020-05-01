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
    let view = UIButton()
    var qrCodeGenerator = QRCodeGenerator()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    func setUpQRImage(){
        view.frame = CGRect(x : 2.5, y : self.bounds.height / 1.5, width: self.bounds.width - 5, height :  self.bounds.height / 5)
        view.titleLabel?.textAlignment = .center
        view.setTitle(encodedData, for: .normal)
        view.addTarget(self, action: #selector(displayEncodedData(sender:)), for: .touchUpInside)
        view.setTitleColor(UIColor.black, for: .normal)
        let qrCode = self.qrCodeGenerator.generateQRCode(from: encodedData)
        
        image.image = qrCode
        image.frame = CGRect(x : 2.5, y : 0, width: self.bounds.width - 5, height: self.bounds.height / 1.5)
        
        addSubview(image)
        addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func displayEncodedData(sender : UIButton){
          let alert = UIAlertController(title: "", message: encodedData, preferredStyle: .alert)
    
        let getData = UIAlertAction(title: "OK", style: .default){
                alert in
            
            }
        alert.addAction(getData)
        self.window?.rootViewController?.present(alert, animated: true)
    }
}
