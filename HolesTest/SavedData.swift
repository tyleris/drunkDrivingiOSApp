//
//  SavedData.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/21/17.



import UIKit
import os.log

class SavedData: NSObject, NSCoding {

    //MARK: Properties
    
    //Vars for inputting user trials
    var reactionTimeBaseline: Double
    var failsBaseline: Int
    var baseline: Bool
    var userName: String
    var userData: Array<(reactionTimeBaseline: Double, failsBaseline: Int, baseline: Bool, userName: String)>
    //var dateTimeStamp: //What is date and timestamp type?
    
    //vars for calculating average baseline per userName
//    var avgFailsBaseline: Double
//    var avgReactionTimeBaseline: Double
//    var userNameAvg: String
    
    
    //MARK: Types
    
    //Why do we need to do this??
    struct DataKey {
        //Save each userName performance
        static let reactionTimeBaseline = "reactionTimeBaseline"
        static let failsBaseline = "failsBaseline"
        static let baseline = "baseline"
        static let dateTimeStamp = "dateTimeStamp"
        static let userName = "userName"
        
        //Save average baseline
//        static let avgFailsBaseline = "avgFailsBaseline"
//        static let avgReactionTimeBaseline = "avgReactionTimeBaseline"
    }
    
    //MARK: Archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("userData")

    //Mark: Initialization
    
    //Consider instead passing an array with all the data saved or loaded
    //Or do you just pass one line of the data every time. Would be nice if we were storing a datatable somewhere and just updating it
    init?(reactionTimeBaseline: Double, failsBaseline: Int, baseline: Bool, userName: String){

        //Should be gaurd ing against improper init vars types (or nil maybe?)

        //Set class level vars based on vars passed in init
        self.reactionTimeBaseline = reactionTimeBaseline
        self.failsBaseline = failsBaseline
        self.baseline = baseline
        self.userName = userName
        
        userData = [(reactionTimeBaseline: reactionTimeBaseline, failsBaseline: failsBaseline, baseline: baseline, userName: userName)]
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(reactionTimeBaseline, forKey: DataKey.reactionTimeBaseline)
        aCoder.encode(failsBaseline, forKey: DataKey.failsBaseline)
        aCoder.encode(baseline, forKey: DataKey.baseline)
        aCoder.encode(userName, forKey: DataKey.userName)
        
        //aCoder.encode(dateTimeStamp, forKey: DataKey.dateTimeStamp)
        
        //Also encode averages (update var names)
        //aCoder.encode(dateTimeStamp, forKey: DataKey.dateTimeStamp)
        //aCoder.encode(dateTimeStamp, forKey: DataKey.dateTimeStamp)
        //aCoder.encode(dateTimeStamp, forKey: DataKey.dateTimeStamp)
        
    }

    required convenience init?(coder aDecoder: NSCoder){
        
        guard let reactionTimeBaseline = aDecoder.decodeObject(forKey: DataKey.reactionTimeBaseline) as? Double else {os_log("unable to decode the reaction time for SaveData object", log: OSLog.default, type: .debug)
            return nil
        }
            
        guard let failsBaseline = aDecoder.decodeObject(forKey: DataKey.failsBaseline) as? Int else {os_log("unable to decode the failsBaseline for SaveData object", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let baseline = aDecoder.decodeObject(forKey: DataKey.baseline) as? Bool else {os_log("unable to decode the baseline for SaveData object", log: OSLog.default,     type: .debug)
            return nil
        }
        
        guard let userName = aDecoder.decodeObject(forKey: DataKey.userName) as? String else {os_log("unable to decode the userName name for SaveData object", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(reactionTimeBaseline: reactionTimeBaseline, failsBaseline: failsBaseline, baseline: baseline, userName: userName)
    }
    
    //Mark: private methods
    
    private func saveuserNameTrials() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userData, toFile: SavedData.ArchiveURL.path)
    
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loaduserNameTrials() -> [SavedData]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: SavedData.ArchiveURL.path) as? [SavedData]
    }
    
    //Create other save and load methods for the overall averages?
    
    
}
