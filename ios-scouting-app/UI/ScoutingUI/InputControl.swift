//
//  FieldData.swift
//  Scouting
//
//  Created by DUC LOC on 5/19/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit
protocol InputControl : UIView{
    func onTimerStarted()
    func setUpView(data : FieldData)
    func updateControlState()
}
