//
//  jsonEvents.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/15/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
struct jsonEvents : Decodable{
    var name : String?
    var start_date : String?
    var city : String?
    var country : String?
    var state_prov : String?
    var year : Int?
    var event_code : String?
}
