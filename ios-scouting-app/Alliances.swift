//
//  Alliances.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/6/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import UIKit

struct MatchSchedule : Decodable {
    struct Alliances : Decodable {
        struct blue : Decodable {
            let teamKeys : [String]
        }
        struct red : Decodable {
            let teamKeys : [String]
        }
    }
    let alliances : Alliances
    let matches : [MatchSchedule]
}
