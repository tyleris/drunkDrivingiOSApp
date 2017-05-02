//
//  BaselineSetViewController.swift
//  Dribe
//
//  Created by Tyler Ibbotson-Sindelar on 5/1/17.
//
//

import UIKit

class BaselineSetViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
                
        guard let gameName = GlobalData.Settings.gameName else {fatalError("gameName should be set to have played game")}
        
        SavedData.saveUserNameTrial(userName: GlobalData.Settings.primaryUsername!, gameName: gameName, gamemode: GlobalData.Settings.gamemode, age: nil, gender: nil, tiredness: nil, bac: nil, drinks: nil, reactionTime: GlobalData.DataRaw.reactionTime, failsCount: GlobalData.DataRaw.failCount)
        
        SavedData.saveBaseline(gameName: gameName)
        
        performSegue(withIdentifier: "segueToWelcomeWithSave", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
