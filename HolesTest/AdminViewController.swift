//
//  AdminViewController.swift
//  HolesTest
//
//  Created by Tyler Ibbotson-Sindelar on 4/26/17.
//
//

import UIKit

class AdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    
    
    @IBAction func realisticModeButton(_ sender: UIButton) {
        GlobalData.Settings.gametype = "realisticMode"
    }
    

    @IBAction func testmodeButton(_ sender: UIButton) {
        GlobalData.Settings.gametype = "testMode"
    }
    
    
    
    // MARK: - Navigation
    
    
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
