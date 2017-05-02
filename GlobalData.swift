//
//  GlobalData.swift
//  Dribe
//
//  Created by Tyler Ibbotson-Sindelar on 4/21/17.
//
//

import Foundation

class GlobalData {
    
    struct Key {
        //ToDo: Add dateTime
        
    }
    
    struct Settings {
        
        static var gamemode: String?
        
        //Options: "testDrunkness", "setBaseline"
        static let gamemodeDataCollection = "dataCollection"
        static let gamemodeRealistic = "realistic" //only gets set temporarily
        static let gamemodeRealisticTestDrunkness = "realisticTestDrunkness"
        static let gamemodeRealisticSetBaseline = "realisticSetBaseline"
        
        static var gameName: String?
        static let gameNameWhackamole = "Whackamole"
        
        static var firstLoad = true
        
        //static var username: String? //ToDo: Do I need this anymore?
        
        static var primaryUsername: String?
        
        //Do I need this??
//
//        static var gender: String?
//        static var age: String?
//        static var tiredness = "N/A"
//        static var drinks = 0
//        static var bac = 0.0
    }
    
    struct WhackamoleBaseline {
        static var playedBefore = false
        static var rt: Double?
        static var failsCount: Double?
        static let rtMargin = 1.1
        static let failsMargin = 1
        
        struct Key {
            static let playedBefore = "playedBefore"
            static let rt = "rt"
            static let failsCount = "failsCount"
        }
    }
    
    struct DataRaw {
        
        //ToDo: Change these all to optionals! No kill them all!
//        static var username: String = "NotSet"
//        static var gameName: String = "NotSet"
//        static var gender = "male"
//        static var tiredness = "N/A"
//        static var age = "25-29"
//        static var drinks = 0
//        static var bac = 0.0
        static var reactionTime = 0.0
        static var failCount = 0
        
        static var userData = [[String:Any?]]()
        //ToDo: Add dateTimeStamp
        
        struct Key {
            static let userName = "userName"
            static let gameName = "gameName"
            static let gamemode = "gamemode"
            static let age = "age"
            static let gender = "gender"
            static let tiredness = "tiredness"
            static let bac = "bac"
            static let drinks = "drinks"
            static let reactionTime = "reactionTime"
            static let failsCount = "failsCount"
            static let validText = ["userName", "gameName", "gamemode", "age", "gender", "tiredness", "bac", "drinks", "reactionTime", "failsCount"]
        }
    }
    
    static func getDateTimeStampCurrent() -> String {
        let date = NSDate()
        let calendar = NSCalendar.current
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        let hour = calendar.component(.hour, from: date as Date)
        let minute = calendar.component(.minute, from: date as Date)
        return String(" \(month)/\(day) \(hour):\(minute)")
    }

    static func getDateTimeStampCurrentComponents() -> Dictionary<String, Int> {
        let date = NSDate()
        let calendar = NSCalendar.current
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        let hour = calendar.component(.hour, from: date as Date)
        let minute = calendar.component(.minute, from: date as Date)
        return ["month": month, "day": day, "hour": hour, "minute": minute]
    }
}
