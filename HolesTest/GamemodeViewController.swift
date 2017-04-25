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
        print("free at last")
        GlobalData.Settings.gamemode = "testDrunkness"
    }
    
    @IBAction func setBaseline(_ sender: UIButton) {
        print("I'm alive")
        GlobalData.Settings.gamemode = "setBaseline"
        
    }
}
