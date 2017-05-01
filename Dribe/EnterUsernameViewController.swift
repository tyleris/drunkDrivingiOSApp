//
//  EnterUsernameViewController.swift
//  Dribe
//
//  Created by Tyler Ibbotson-Sindelar on 4/29/17.
//
//

import UIKit

class EnterUsernameViewController: UIViewController {

    
    @IBOutlet weak var usernameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        //ToDo: require user to enter text
        GlobalData.Settings.username = usernameLabel.text!
        
        performSegue(withIdentifier: "segueToWMOnboarding", sender: self)
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
