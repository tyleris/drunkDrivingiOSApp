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
        
        static var userName = "userName"
        static var gameName = "gameName"
        static var gamemode = "gamemode"
        static var age = "age"
        static var gender = "gender"
        static var tiredness = "tiredness"
        static var bac = "bac"
        static var drinks = "drinks"
        static var reactionTime = "reactionTime"
        static var failsCount = "failsCount"
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
        static var failsCount: Int?
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
        
        //Array<(["userName": String, "gameName": String, "gamemode": String?, "age": String?, "gender": String?, "tiredness": String?, "reactionTime": Double, "failsCount": Int])>
        
        //ToDo: Add dateTimeStamp
        
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
