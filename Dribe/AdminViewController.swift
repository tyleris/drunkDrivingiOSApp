//
//  AdminViewController.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/26/17.
//
//

import UIKit

class AdminViewController: UIViewController {

    var openHourMin = 6
    var openHourMax = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Only call loadData is this is the first time the game is opened
        if GlobalData.Settings.firstLoad == true {
            SavedData.loadUserNameTrials()
            SavedData.loadBaseline()
        }
        
        GlobalData.Settings.firstLoad = false
        
        SavedData.loadBaseline()
    }

    //MARK: Actions
    
    @IBAction func realisticModeButton(_ sender: UIButton) {
        
        GlobalData.Settings.gamemode = GlobalData.Settings.gamemodeRealistic
        
        let timeComponents = GlobalData.getDateTimeStampCurrentComponents()
        print("time components: \(timeComponents)")
        guard let hour = timeComponents["hour"] else {fatalError("why isn't time working?")}
        print("hour: \(hour)")
        
        //if you haven't entered a user name, then go to enter user name, and set gamemode = setbaseline
        if GlobalData.Settings.primaryUsername == nil {
            
            GlobalData.Settings.gamemode = GlobalData.Settings.gamemodeRealisticSetBaseline
            performSegue(withIdentifier: "segueToEnterUserName", sender: self)
            
        } else if GlobalData.WhackamoleBaseline.playedBefore == false {
            
            GlobalData.Settings.gamemode = GlobalData.Settings.gamemodeRealisticSetBaseline
            performSegue(withIdentifier: "segueToWhackamoleOnboarding", sender: self)
            
        } else if (hour > openHourMin) && (hour < openHourMax) {
            
            //Go to chooseGamemode page if time is between 6am and 3pm
            GlobalData.Settings.gamemode = GlobalData.Settings.gamemodeRealistic //will need to update later
            performSegue(withIdentifier: "segueToChooseGamemode", sender: self)
        
        } else {
            
            GlobalData.Settings.gamemode = GlobalData.Settings.gamemodeRealisticTestDrunkness
            performSegue(withIdentifier: "segueToWhackamole", sender: self)
            
        }
    }
    
    @IBAction func testmodeButton(_ sender: UIButton) {
        GlobalData.Settings.gamemode = GlobalData.Settings.gamemodeDataCollection
        
        performSegue(withIdentifier: "segueToWhackamoleOnboarding", sender: self)
        
    }
    
    @IBAction func resetButton(_ sender: UIBarButtonItem) {
        
        GlobalData.Settings.primaryUsername = nil
        GlobalData.WhackamoleBaseline.rt = nil
        GlobalData.WhackamoleBaseline.failsCount = nil
        GlobalData.WhackamoleBaseline.playedBefore = false
        
        let defaults = UserDefaults.standard
        defaults.removePersistentDomain(forName:Bundle.main.bundleIdentifier!)
        defaults.synchronize()
        
        //Did this work??
        
        //ToDo: Need to clear all saved baselines!
        for i in 0..<GlobalData.DataRaw.userData.count {
            if String(describing: GlobalData.DataRaw.userData[i][GlobalData.DataRaw.Key.gamemode]!!) == GlobalData.Settings.gamemodeRealisticSetBaseline {
               GlobalData.DataRaw.userData.remove(at: i)
                print("removed baseline record #\(i) w data: \(GlobalData.DataRaw.userData[i])")
            }
        }
        
        //Then need to save the user data over again
        //SavedData.saveUserData(userData: GlobalData.DataRaw.userData)
        
    }
    
    
    

}
