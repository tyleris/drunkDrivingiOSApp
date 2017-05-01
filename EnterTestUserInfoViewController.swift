//
//  EnterTestUserInfoViewController.swift
//  Dribe
//
//  Created by Tyler Ibbotson-Sindelar on 4/27/17.
//
//

import UIKit

class EnterTestUserInfoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var userDataPicker: UIPickerView!
    @IBOutlet weak var drinksPicker: UIPickerView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var reactionTimeLabel: UILabel!
    @IBOutlet weak var failCountLabel: UILabel!
    
    var pickerData = [["Female", "Male"], ["Under 25","25-29","30-34","35-39","40-50","50-60","60-70","70-80","80-90"], ["Exhausted", "A bit tired", "Well rested"]]

    var drinksPickerData = [[0.00,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12],[0,1,2,3,4,5,6,7,8,9,10]]
    
    //Defaults based on picker defaults
    var gender: String = "Female"
    var age = "Under 25"
    var tiredness = "Exhausted"
    var bac = 0.0
    var drinks = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userDataPicker.dataSource = self
        self.userDataPicker.delegate = self
        
        self.drinksPicker.dataSource = self
        self.drinksPicker.delegate = self
        
        self.userNameTextField.delegate = self
        
        failCountLabel.text = String(GlobalData.DataRaw.failCount)
        reactionTimeLabel.text = String(GlobalData.DataRaw.reactionTime)
    }
    
    
    //MARK: PickerView delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var num = 1
        
        if pickerView.tag == 0 {
            num =  3
        } else if pickerView.tag == 1 {
            num =  2
        } else{ fatalError("pickview tags incorrect")}
        
        return num
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var num = 1
        
        if pickerView.tag == 0 {
            num = pickerData[component].count
        } else if pickerView.tag == 1 {
            num = drinksPickerData[component].count
        } else { fatalError("pickview tags incorrect") }
        
        return num
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var rowVal = ""
        
        if pickerView.tag == 0 {
            rowVal = String(pickerData[component][row])
        } else if pickerView.tag == 1 {
            rowVal = String(drinksPickerData[component][row])
        } else { fatalError("pickview tags incorrect")}
        return rowVal
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil){
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Montserrat", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        if pickerView.tag == 0 {
            pickerLabel?.text = pickerData[component][row]
        } else {
            pickerLabel?.text = String(drinksPickerData[component][row])
        }
        
            
        return pickerLabel!
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
 
    
    //MARK: Save data
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
       
        //Probably don't need to set these global data settings
        let username = userNameTextField.text ?? ""
        GlobalData.Settings.username = username
        //toDo: time stamp
        GlobalData.Settings.gender = gender
        GlobalData.Settings.age = age
        GlobalData.Settings.drinks = drinks
        GlobalData.Settings.bac = bac
        
        //Reaction time and fails already set when game ended
        let fails = GlobalData.DataRaw.failCount
        let rt = GlobalData.DataRaw.reactionTime
        
        print("user data saved:")
        print("username: \(GlobalData.Settings.username ?? "nil")")
        print("gender: \(GlobalData.Settings.gender ?? "nil")")
        print("age: \(GlobalData.Settings.age ?? "nil")")
        print("drinks: \(GlobalData.Settings.drinks)")
        print("bac: \(GlobalData.Settings.bac)")
        
        //Save data
        guard let name: String = GlobalData.Settings.gameName else {fatalError("gamename not set")}
        guard let type: String = GlobalData.Settings.gametype else {fatalError("gametype not set")}
        
        //Gamemode is an optional and does not need to be set
        let mode: String = GlobalData.Settings.gamemode ?? "na"
        
        //Can we call method from within SavedData?
        //SavedData.saveUserNameTrial(userName: username, gameName: name, gamemode: mode, gametype: type, age: age, gender: gender, tiredness: tiredness, reactionTime: rt, failsCount: fails)
        //        print("data saved")
        
        //This might be a syntax issue. (())?
        //ToDo: add dateTimeStamp
        //ToDo: Make this a var in GlobalData with lots of data in it. Pass whole thing back and forth (for now)
        
        var userData = [String : Any]()
        
        //ToDo: All Strings should really be propety keys!
        userData = ["userName": username, "gameName": name, "gamemode": mode ?? "na", "gametype": type, "age": age, "gender": gender, "tiredness": tiredness, "reactionTime": rt, "failsCount": fails]
        
        GlobalData.DataRaw.userData.append(userData)
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(GlobalData.DataRaw.userData, toFile: SavedData.ArchiveURL.path)
        
        if isSuccessfulSave {
            print("game data successfully saved.")
        } else {
            print("failed to save game data...")
        }
        
        performSegue(withIdentifier:"segueToWelcomePage", sender: self)

    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        GlobalData.DataRaw.reactionTime = 0
        GlobalData.DataRaw.failCount = 0
        
        performSegue(withIdentifier: "segueToWelcomePage", sender: self)
    }
    
    
    // I prob don't need this function. just read settings later
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
        
            if component == 0 {gender = pickerData[0][row]}
            if component == 1 {age = pickerData[1][row]}
            if component == 2 {tiredness = pickerData[2][row]}
        
        } else if pickerView.tag == 1 {
            
            if component == 0 {bac = drinksPickerData[0][row]}
            if component == 1 {drinks = Int(drinksPickerData[0][row])}
            //Safe to force unwrap because #s manually entered above
            
        } else {fatalError("picker tags messed up")}
   }

    //Todo: On save get text data
    //Todo: Set data after changes here
    // GlobalData userName = nameTextField.text
    
}
