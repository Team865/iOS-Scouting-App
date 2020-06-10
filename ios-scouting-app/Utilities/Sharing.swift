//
//  Sharing.swift
//  Scouting
//
//  Created by DUC LOC on 6/7/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class Sharing {
    func startSharingQRCode(image : UIImage, viewController : ViewController){
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    func startSharingQRData(data : String, viewController : ViewController){
        
    }
}
