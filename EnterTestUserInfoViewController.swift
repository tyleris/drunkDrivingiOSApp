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
    
    var pickerData = [["Female", "Male"], ["Under 25","25-29","30-34","35-39","40-50","50-60","60-70","70-80","80-90"], ["Exhausted", "A bit tired", "Well rested"]]

    var drinksPickerData = [[0.00,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10,0.11,0.12],[0,1,2,3,4,5,6,7,8,9,10]]
    
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
       
        let username = userNameTextField.text ?? ""
        GlobalData.Settings.username = username
        //toDo: time stamp
        GlobalData.Settings.gender = gender
        GlobalData.Settings.age = age
        GlobalData.Settings.drinks = drinks
        GlobalData.Settings.bac = bac
        
        print("user data saved:")
        print("username: \(GlobalData.Settings.username)")
        print("gender: \(GlobalData.Settings.gender)")
        print("age: \(GlobalData.Settings.age)")
        print("drinks: \(GlobalData.Settings.drinks)")
        print("bac: \(GlobalData.Settings.bac)")
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
