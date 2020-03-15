//
//  SettingsViewController.swift
//  ios-scouting-app
//
//  Created by DUC LOC on 3/15/20.
//  Copyright © 2020 Warp7. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    var listOfEvents = [event]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJSONEvents {
            for i in 0..<self.listOfEvents.count{
                print(self.listOfEvents[i].key)
                print(self.listOfEvents[i].year)
            }
        }
    }
    
    private func getJSONEvents(completed : @escaping () -> ()){
        let url = URL(string: "https://www.thebluealliance.com/api/v3/team/frc865/events")!
        var request = URLRequest(url: url)
        //Remember to remove keys before committing
        request.setValue("NTFtIarABYtYkZ4u3VmlDsWUtv39Sp5kiowxP1CArw3fiHi3IQ0XcenrH5ONqGOx", forHTTPHeaderField: "X-TBA-Auth-Key")
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                self.listOfEvents = try decoder.decode([event].self, from: data)
                
                DispatchQueue.main.async {
                    completed()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
    }
}
