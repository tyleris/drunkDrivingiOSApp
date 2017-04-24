//
//  ResultsViewController.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/20/17.
//
//

import UIKit

class ResultsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var rtAvgLabel: UILabel!
    @IBOutlet weak var failsLabel: UILabel!
    @IBOutlet weak var rtBaseLabel: UILabel!
    @IBOutlet weak var failsBase: UILabel!

    var segueData = Array<(reactionTimeAvg: Double, failCount: Int)>()
    var reactionTimeAvg: Double?
    var failCount: Int?
    var reactionTimesBase: Double?
    var failCountBase: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactionTimeAvg = segueData[0].reactionTimeAvg
        failCount = segueData[0].failCount
        
        //Update Label Names
        //segueData
        rtAvgLabel.text = String(reactionTimeAvg ?? 0)
        rtBaseLabel.text = String(reactionTimesBase ?? 0)
        failsLabel.text = String(failCount ?? 0)
        failsBase.text = String(failCountBase ?? 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Create save method
    //Must write in a name - popup box (should allow to select from list (do autfil search))
    
    // MARK: - Navigation

    @IBAction func saveButton(_ sender: UIButton) {
        
        
        print("mode: \(GlobalData.Settings.gamemode)")
    }
    
   }
