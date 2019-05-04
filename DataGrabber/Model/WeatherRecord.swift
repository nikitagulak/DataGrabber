//
//  Downloader.swift
//  WeatherData
//
//  Created by Nick on 03/05/2019.
//  Copyright © 2019 Nikita Gulak. All rights reserved.
//

import Foundation

struct WeatherRecord {
    var day: String = ""
    var temperature: String = ""
    
    init(day: String, temperature: String) {
        self.day = day
        self.temperature = temperature
    }
    
    init() {}
    
}
