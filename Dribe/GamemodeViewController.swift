//
//  GamemodeViewController.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/21/17.
//
//

import UIKit

class GamemodeViewController: UIViewController, UINavigationControllerDelegate {

    //MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    @IBAction func testDrunknessButton(_ sender: UIButton) {
        GlobalData.Settings.gamemode = GlobalData.Settings.gamemodeRealisticTestDrunkness
        performSegue(withIdentifier: "segueToWM", sender: self)
    }
    
    @IBAction func setBaseline(_ sender: UIButton) {
        GlobalData.Settings.gamemode = GlobalData.Settings.gamemodeRealisticSetBaseline
        performSegue(withIdentifier: "segueToWM", sender: self)

    }
    
    @IBAction func unlockButton(_ sender: UIButton) {
        print("Connecting to bluetooth... NOT!!")
        print("Unlocking your car... NOT!!!")
        performSegue(withIdentifier: "segueToAdmin", sender: self)
    }
    
}
