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
        
        static var gamemode: String = "NotSet"
        
        //Options: "testDrunkness", "setBaseline"
        static let gamemodeTestDrunkness = "testDrunkness"
        static let gamemodeSetBaseline = "setBaseline"
        
        //Gametype decides whether you are recording data or you are
        static var gametype: String = "NotSet"
        
        //Options: 'realistic", "dataCollection"
        static let gametypeRealistic = "realistic"
        static let gametypeDataCollection = "dataCollection"
        
        //For user flag whether they have played a given game or not
        static let playedBeforeWhackamole = false
        
        static var username: String = "NotSet"
        static var gameName: String = "NotSet"
        static var gender = "male"
        static var age = "25-29"
        static var tiredness = "N/A"
        static var drinks = 0
        static var bac = 0.0
        
    }
    
    struct DataBaseline {
        static let username: String = "NotSet"
        static let playedBeforeWhackamole = false
        static let reactionTimeWhackamoleBaseline = 0.0
        static let failsCountWhackamoleBaseline = 0
    }
    
    struct DataRaw {
     
        static var username: String = "NotSet"
        static var gameName: String = "NotSet"
        static var gender = "male"
        static var tiredness = "N/A"
        static var age = "25-29"
        static var drinks = 0
        static var bac = 0.0
        
        //static let userData = Array<(userName: String, gameName: String, drunkTest: Bool, reactionTime: Double, failsCount: Int)>
        //Todo: add gender, age, drinks, bac
        //Todo: add game version
    }
    
    //Can I create a method to guard against prohibilited values?
    //I think I need a setGamemode method
    
}
