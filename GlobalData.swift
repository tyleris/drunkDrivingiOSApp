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
        
        static var playerName: String = "NotSet"
        //Value entered by user
        
        //For each user flag whether they have played a given game or not
    }
    
    
    
    //Can I create a method to guard against prohibilited values?
    //I think I need a setGamemode method
    
}
