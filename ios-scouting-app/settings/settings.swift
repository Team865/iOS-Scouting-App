//
//  settings.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/15/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
class Settings {
    var image : UIImage?
    var title : String?
    var description : String?
    var hideSwitch : Bool?
    init(image : UIImage, title : String, description : String, hideSwitch : Bool) {
        self.image = image
        self.title = title
        self.description = description
        self.hideSwitch = hideSwitch
    }
}
