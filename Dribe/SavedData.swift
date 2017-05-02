//
//  SavedData.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/21/17.



import UIKit
import os.log

class SavedData: NSObject, NSCoding {

    //MARK: Properties
    
    
    //TodDo: Add var for dateTimeStamp
    //ToDo: Change to array to store more data
    var userData: [String : Any?]
    //["userName": String, "gameName": String, "gamemode": String?, "age": String?, "gender": String?, "tiredness": String?, "reactionTime": Double, "failsCount": Int]

    //MARK: Types
    
    //Why do we need to do this??
    struct DataKey {
        
        //Are these still useful?
        //Save each userName performance
//        static let userName = "userName"
//        static let gameName = "gameName"
//        static let gamemode = "gamemode"
//        static let age = "age"
//        static let gender = "gender"
//        static let tiredness = "tiredness"
//        static let dateTimeStamp = "dateTimeStamp"
//        static let reactionTime = "reactionTime"
//        static let failsCount = "failsCount"
//        
        static let userData = "userData"
//
        //Can I use this to ensure compliance?
        //static let userDataLabels = ["userName": String, "gameName": String, "gamemode": String?, "age": String?, "gender": String?, "tiredness": String?, "reactionTime": Double, "failsCount": Int]
        
    }
    
    //MARK: Archiving paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("userData")

    //Mark: Initialization
    
    init?(userData: [String: Any?]){
        self.userData = userData
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userData, forKey: DataKey.userData)
    }

    required convenience init?(coder aDecoder: NSCoder){
        
        //Should this be as? Am I actually guarding here given that I am forcing?
        guard let data = aDecoder.decodeObject(forKey: DataKey.userData) else {fatalError("wrong data type saved. Can't load")}
        
        let d = data as! [String: Any?]
        
        // Must call designated initializer.
        self.init(userData: d)
        
    }
    
    //Mark: load save
    
    static func saveUserNameTrial(userName: String, gameName: String, gamemode: String?, age: String?, gender: String?, tiredness: String?, bac:Double?, drinks:Int?, reactionTime: Double, failsCount: Int) {

        //ToDo: add dateTimeStamp
        
        guard let gm = gamemode else {fatalError("gamemode must be specified in order to save trial")}
        
        //ToDo: add error catching. use keys instead of strings
        let data: [String : Any?] = ["userName": userName, "gameName": gameName, "gamemode": gm, "age": age, "gender": gender, "tiredness": tiredness, "bac": bac, "drinks": drinks, "reactionTime": reactionTime, "failsCount": failsCount]
        
        GlobalData.DataRaw.userData.append(data)
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(GlobalData.DataRaw.userData, toFile: SavedData.ArchiveURL.path)
    
        if isSuccessfulSave {
            print("game data successfully saved.")
        } else {
            print("failed to save game data...")
        }
    }
    
    static func saveUserData(userData: [[String:Any?]]){

        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userData, toFile: SavedData.ArchiveURL.path)
        
        if isSuccessfulSave {
            print("game data successfully saved.")
        } else {
            print("failed to save game data...")
        }

    }
    
    static func loadUserNameTrials(){
        
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: SavedData.ArchiveURL.path) as? [[String : Any?]]? else {fatalError("saved data in wrong format. Can't load")}
        
        if data != nil {
            GlobalData.DataRaw.userData = data!
            print("Loaded data...")
            print(GlobalData.DataRaw.userData)
        } else {
            print("no data to load")
        }
        
        
    }
    
    
    //ToDo: This might be better in the BaselineSet Class because that is the only class that can actually save a baseline!
    static func saveBaseline(gameName: String){
        
        let defaults = UserDefaults.standard
        
        switch gameName {
        case GlobalData.Settings.gameNameWhackamole:
            
            //Need to calculate new baseline
            GlobalData.WhackamoleBaseline.failsCount = calcBaseline(gameName: gameName, dataRawKey: GlobalData.DataRaw.Key.failsCount)
            GlobalData.WhackamoleBaseline.rt = calcBaseline(gameName: gameName, dataRawKey: GlobalData.DataRaw.Key.reactionTime)
            
            
            //Save the baseline data to UserDefaults
            //toDo: Should set these as optionals and optionally unwrap them!
            defaults.set(GlobalData.WhackamoleBaseline.failsCount, forKey: GlobalData.WhackamoleBaseline.Key.failsCount)
            defaults.set(GlobalData.WhackamoleBaseline.rt, forKey: GlobalData.WhackamoleBaseline.Key.rt)
            defaults.set(true, forKey: GlobalData.WhackamoleBaseline.Key.playedBefore)
            
            print("baseline saved: rt: \(String(describing: GlobalData.WhackamoleBaseline.rt!)), fails: \(String(describing: GlobalData.WhackamoleBaseline.failsCount!))")
            
        default: fatalError("game name does not exist: \(gameName)")
        }
    }
    
    //ToDo: It would probably be better to pass something other than a key...
    
    private static func calcBaseline(gameName: String, dataRawKey: String) -> Double {
        
        //Create vars to get avg (okay to define outside, cause only select 1 case)
        var sumVal = 0.0
        var count = 0
        var avgVal = 0.0
        
        //Ensure matched value passed
        var match = false
        for key in GlobalData.DataRaw.Key.validText { if dataRawKey == key {match = true}}
        if match == false {fatalError("didn't pass correct key")}
        
        switch gameName {
        case GlobalData.Settings.gameNameWhackamole:
            
            //iterate over all rows in userData
            let d = GlobalData.DataRaw.userData
            for i in 0..<d.count {
                
                //Only include rows of correct gamename and with the primary user
                
                guard let gn = d[i][GlobalData.DataRaw.Key.gameName]!! as? String else {fatalError("gamename wasn't saved, or not as a string: \(String(describing: d[i][GlobalData.DataRaw.Key.gameName]))")}
                
                guard let gm = d[i][GlobalData.DataRaw.Key.gamemode]!! as? String else  {fatalError("gamename wasn't saved, or not as a string: \(String(describing: d[i][GlobalData.DataRaw.Key.gameName]))")}
                
                guard let un = d[i][GlobalData.DataRaw.Key.userName]!! as? String else {fatalError("username wasn't saved, or not as a string: \(String(describing: d[i][GlobalData.DataRaw.Key.userName]))")}
                
                //ToDo: Only count when gametype is baseline!!
                //ToDo: How do we handle if no values here yet? Are we sure there will be values?
                if (gn == gameName) && (un == GlobalData.Settings.primaryUsername) && (gm == GlobalData.Settings.gamemode) {
         
                    //guard let value = d[i][dataRawKey]!! as? Double else {fatalError("Key: \(dataRawKey) doesn't match any key in GlobalData.userData or is not Double")}
                    let value = d[i][dataRawKey]!! as Any // else {fatalError("Key: \(dataRawKey) doesn't match any key in GlobalData.userData or is not Double")}
                    print(value)
                    var v = 0.0
                    v = Double(String(describing: value))!
                    
                    sumVal += v
                    count += 1
                }
            }
            
        default: fatalError("game name does not exist: \(gameName)")
        
        }
        
        //ToDo, exclude top and bottom if more than 4. Will mean saving to array instead.
        //find avg
        avgVal = sumVal / Double(count)
        return avgVal
    }
    
    static func loadBaseline(){
        
        let defaults = UserDefaults.standard
        
        guard let rt = defaults.object(forKey: GlobalData.WhackamoleBaseline.Key.rt) as? Double? else {fatalError("UserDefault reaction time should be Double")}
        
        if rt != nil {
            GlobalData.WhackamoleBaseline.rt = rt
            print("reaction time baseline data loaded")
        } else {
            print("no reaction time baseline data to load")
        }
        
        let pb = defaults.object(forKey: GlobalData.WhackamoleBaseline.Key.playedBefore) as? Bool ?? false
        
        if pb == true {
            GlobalData.WhackamoleBaseline.playedBefore = true
            print("played before == true")
        } else {
            print("played before == false")
        }
        
        //**Must change to Double later
        guard let fc = defaults.object(forKey: GlobalData.WhackamoleBaseline.Key.failsCount) as? Double? else {fatalError("UserDefault fail count should be Double")}

        if fc != nil {
            GlobalData.WhackamoleBaseline.failsCount = fc
            print("fail count baseline data loaded")
        } else {
            print("no fail count baseline data to load")
        }
        
    }
    
}
