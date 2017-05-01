//
//  GlobalData.swift
//  Dribe
//
//  Created by Tyler Ibbotson-Sindelar on 4/21/17.
//
//

import Foundation

class GlobalData {
    
    struct Settings {
        
        static var gamemode: String?
        
        //Options: "testDrunkness", "setBaseline"
        static let gamemodeTestDrunkness = "testDrunkness"
        static let gamemodeSetBaseline = "setBaseline"
        
        //Gametype decides whether you are recording data or you are
        static var gametype: String?
        
        //Options: 'realistic", "dataCollection"
        static let gametypeRealistic = "realistic"
        static let gametypeDataCollection = "dataCollection"
        
        //For user flag whether they have played a given game or not
        static let playedBeforeWhackamole = false
        
        static var gameName: String?
        static let gameNameWhackamole = "Whackamole"
        
        static var firstLoad = true
        
        //Do I need this??
        static var username: String?
        static var gender: String?
        static var age: String?
        static var tiredness = "N/A"
        static var drinks = 0
        static var bac = 0.0
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
    
    
    struct DataBaseline {
        static let username: String = "NotSet"
        static let playedBeforeWhackamole = false
        static let reactionTimeWhackamoleBaseline = 0.0
        static let failsCountWhackamoleBaseline = 0
    }
    
    struct DataRaw {
     
        //ToDo: Change these all to optionals!
        static var username: String = "NotSet"
        static var gameName: String = "NotSet"
        static var gender = "male"
        static var tiredness = "N/A"
        static var age = "25-29"
        static var drinks = 0
        static var bac = 0.0
        static var reactionTime = 0.0
        static var failCount = 0
        
        static let userData = Array<(["userName": String, "gameName": String, "gamemode": String?, "gametype": String, "age": String?, "gender": String?, "tiredness": String?, "reactionTime": Double, "failsCount": Int])>
        
        //ToDo: Add dateTimeStamp
        
    }
    
    //Can I create a method to guard against prohibilited values?
    //I think I need a setGamemode method
    
}
