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
        downloadWeatherFile()
        downloadFootballFile()
    }
    
    @IBOutlet weak var weatherLabel: NSTextField!
    @IBOutlet weak var footballLabel: NSTextField!
    
    var minimum: WeatherRecord = WeatherRecord()
    var teamWithLowestDifference: TeamRecord = TeamRecord()
    
    //MARK: Dealing with weather.dat
    func downloadWeatherFile() {
        let url = URL(string: "http://codekata.com/data/04/weather.dat")!
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let table = try? String(contentsOf: localURL) {
                    
                    let dayColumn: [String] = self.extractFromTable(table: table, columnIndex: 0)
                    let minTempColumn: [String] = self.extractFromTable(table: table, columnIndex: 2)
                    
                    // Defining Minimmum
                    self.minimum = WeatherRecord(day: dayColumn[minTempColumn.firstIndex(of: minTempColumn.min()!)!], temperature: minTempColumn.min()!)
                    
                    // Setting label
                    self.setLabel(label: self.weatherLabel, text: "The smallest temperature \(self.minimum.temperature)°F was at day \(self.minimum.day)")
                    print("The smallest temperature \(self.minimum.temperature)°F was at day \(self.minimum.day)")
                }
            }
        }
        task.resume()
    }
    
    //MARK: Dealing with football.dat
    func downloadFootballFile() {
        let url = URL(string: "http://codekata.com/data/04/football.dat")!
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let table = try? String(contentsOf: localURL) {
                    
                    let teamColumn: [String] = self.extractFromTable(table: table, columnIndex: 1)
                    let forColumn: [String] = self.extractFromTable(table: table, columnIndex: 6)
                    let againstColumn: [String] = self.extractFromTable(table: table, columnIndex: 8)
                    let teams: [TeamRecord] = {() -> [TeamRecord] in
                        var teams: [TeamRecord] = []
                        for (index, team) in teamColumn.enumerated() {
                            teams.append(TeamRecord(name: team, forGoals: forColumn[index], againstGoals: againstColumn[index]))
                        }
                        return teams
                    }()
                    
                    // Defining a team with minimal difference
                    self.teamWithLowestDifference = teams.min(by: { (TeamRecord1, TeamRecord2) -> Bool in
                        TeamRecord1.difference < TeamRecord2.difference ? true : false
                    })!
                    
                    // Setting label
                    self.setLabel(label: self.footballLabel, text: "Team \(self.teamWithLowestDifference.name) got the lowest difference in \"for\" and \"against\" goals")
                    print("Team \(self.teamWithLowestDifference.name) got the lowest difference in \"for\" and \"against\" goals")
                }
            }
        }
        task.resume()
    }
    
    //MARK: Supporting functions
    func extractFromTable(table: String, columnIndex: Int) -> [String] {
        let lines = table.split(separator:"\n")
        var valuesInColumn: [String] = []
        for line in lines {
            if line == lines[0] || line.contains("----") {
                continue
            } else {
                var values = line.split(separator: " ")
                
                // Removing asterisk symbol (for weather data file)
                if let i = values[2].firstIndex(of: "*") {
                    values[2].remove(at: i)
                }
                
                valuesInColumn.append(String(values[columnIndex]))
            }
        }
        return valuesInColumn
    }
    
    func setLabel(label: NSTextField, text: String) {
        DispatchQueue.main.async {
            label.stringValue = text
        }
    }
    
}

