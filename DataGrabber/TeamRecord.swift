//
//  TeamRecord.swift
//  WeatherData
//
//  Created by Nick on 03/05/2019.
//  Copyright © 2019 Nikita Gulak. All rights reserved.
//

import Foundation

struct TeamRecord {
    var name: String = ""
    var forGoals: String = ""
    var againstGoals: String = ""
    var difference: Int = 0
    
    
    init(name: String, forGoals: String, againstGoals: String) {
        self.name = name
        self.forGoals = forGoals
        self.againstGoals = againstGoals
        difference = abs(Int(forGoals)! - Int(againstGoals)!)
    }
    
    init() {}
    
}
