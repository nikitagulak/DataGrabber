//
//  ViewController.swift
//  WeatherData
//
//  Created by Nick on 03/05/2019.
//  Copyright © 2019 Nikita Gulak. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadWeatcherFile()
        downloadFootballFile()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBOutlet weak var weatherLabel: NSTextField!
    @IBOutlet weak var footballLabel: NSTextField!
    
    var minimum: Record = Record()
    var teamWithLowestDifference: TeamRecord = TeamRecord()
    
    func downloadWeatcherFile() {
        let url = URL(string: "http://codekata.com/data/04/weather.dat")!
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let table = try? String(contentsOf: localURL) {
                    
                    let lines = table.split(separator:"\n")
                    
                    var dayColumn: [String] = []
                    var minTempColumn: [String] = []
                    
                    // Extracting Days column
                    for line in lines {
                        if line == lines[0] {
                            continue
                        } else {
                            let values = line.split(separator: " ")
                            dayColumn.append(String(values[0]))
                        }
                    }
                    
                    
                    // Extracting Minimum Temperature column
                    for line in lines {
                        if line == lines[0] {
                            continue
                        } else {
                            var values = line.split(separator: " ")
                            
                            // Removing asterisk symbol
                            if let i = values[2].firstIndex(of: "*") {
                                values[2].remove(at: i)
                            }
                            
                            minTempColumn.append(String(values[2]))
                        }
                    }
                    
                    
                    // Defining Minimmum
                    self.minimum = Record()
                    self.minimum.temperature = minTempColumn.min()!
                    self.minimum.day = dayColumn[minTempColumn.firstIndex(of: minTempColumn.min()!)!]
                    
                    // Setting label
                    DispatchQueue.main.async {
                        self.weatherLabel.stringValue = "The smallest temperature \(self.minimum.temperature)°F was at day \(self.minimum.day)"
                    }
                    
                    print("The smallest temperature \(self.minimum.temperature)°F was at day \(self.minimum.day)\n")
                }
            }
        }
        
        task.resume()
    }
    
    
    func downloadFootballFile() {
        let url = URL(string: "http://codekata.com/data/04/football.dat")!
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let table = try? String(contentsOf: localURL) {
                    
                    let lines = table.split(separator:"\n")
                    
                    var teamColumn: [String] = []
                    var forColumn: [String] = []
                    var againstColumn: [String] = []
                    var teams: [TeamRecord] = []
                    
                    // Extracting Team column
                    for line in lines {
                        if line == lines[0] || line.contains("----") {
                            continue
                        } else {
//                            print(line)
                            let values = line.split(separator: " ")
                            teamColumn.append(String(values[1]))
                        }
                    }
                    
                    
                    // Extracting "For" column
                    for line in lines {
                        if line == lines[0] || line.contains("----") {
                            continue
                        } else {
                            var values = line.split(separator: " ")
                            forColumn.append(String(values[6]))
                        }
                    }

                    // Extracting "Against" column
                    for line in lines {
                        if line == lines[0] || line.contains("----") {
                            continue
                        } else {
                            var values = line.split(separator: " ")
                            againstColumn.append(String(values[8]))
                        }
                    }
                    
                    for (index, team) in teamColumn.enumerated() {
                        teams.append(TeamRecord(name: team, forGoals: forColumn[index], againstGoals: againstColumn[index]))
                    }
                    
                    self.teamWithLowestDifference = teams.min(by: { (TeamRecord1, TeamRecord2) -> Bool in
                        TeamRecord1.difference < TeamRecord2.difference ? true : false
                    })!
                    
                    // Setting label
                    DispatchQueue.main.async {
                        self.footballLabel.stringValue = "Team \(self.teamWithLowestDifference.name) got the lowest difference in \"for\" and \"against\" goals"
                    }
                    print("Team \(self.teamWithLowestDifference.name) got the lowest difference in \"for\" and \"against\" goals")
                }
            }
        }
        
        task.resume()
    }
    
}

