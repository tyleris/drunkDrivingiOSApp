//
//  ResultsViewController.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/20/17.
//
//

import UIKit

class ResultsViewController: UIViewController, UINavigationControllerDelegate {

    //Change name to fail / pass (which is it?) view controler
    
    var segueData = Array<(reactionTimeAvg: Double, failCount: Int)>()
    var reactionTimeAvg: Double?
    var failCount: Int?
    var reactionTimesBase: Double?
    var failCountBase: Int?
    
    
    //ToDo: need to determine whether or not passed and then fill in text
    //Actually should determine whether or not passed on the whackamole game itself before choosing which screen to go to
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reactionTimeAvg = segueData[0].reactionTimeAvg
        //failCount = segueData[0].failCount
        
        //Update Label Names
        //segueData
//        rtAvgLabel.text = String(reactionTimeAvg ?? 0)
//        rtBaseLabel.text = String(reactionTimesBase ?? 0)
//        failsLabel.text = String(failCount ?? 0)
//        failsBase.text = String(failCountBase ?? 0)
        
    }

    //Create save method

    // MARK: - Navigation

//    @IBAction func saveButton(_ sender: UIButton) {
//      
        //NEED TO MAKE playedBefore = true !!!!!!!!!!!!!!!
    
//        let userData: Any = ["bob", "whackamole", true, reactionTimeAvg!, failCount!]
//        
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userData, toFile: SavedData.ArchiveURL.path)
//        
//        if isSuccessfulSave {
//            print("game data successfully saved.")
//        } else {
//            print("failsed to save game data...")
//        }
//
//        
//    
//    }
    
   }
