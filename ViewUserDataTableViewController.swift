//
//  ViewUserDataTableViewController.swift
//  Dribe
//
//  Created by Tyler Ibbotson-Sindelar on 5/1/17.
//
//

import UIKit

class ViewUserDataTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return GlobalData.DataRaw.userData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "UserDataTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserDataTableViewCell else {fatalError("dequeued cell not instance of UserDataTableViewCell")}

        let i = indexPath.row
        let data = GlobalData.DataRaw.userData[i]
        
        //Create labels for cell
        cell.usernameLabel.text = unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.userName], errStr: "NA")
        
        cell.gamemodeLabel.text = unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.gamemode], errStr: "NA")
        
        cell.gameNameLabel.text = unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.gameName], errStr: "NA")
        
        cell.genderLabel.text = unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.gender], errStr: "NA")
        
        cell.ageLabel.text = unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.age], errStr: "NA")
        
        cell.tirednessLabel.text = unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.tiredness], errStr: "NA")
        
        cell.drinksLabel.text = unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.drinks], errStr: "NA")
        
        cell.bacLabel.text = unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.bac], errStr: "NA")
    
        cell.failsLabel.text = unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.failsCount], errStr: "NA")
        
        let rt = round(Double(unwrapDicToLabel(field: data[GlobalData.DataRaw.Key.reactionTime], errStr: "0"))! * 10) / 10
        cell.reactionTimeLabel.text = String(rt)
        
        return cell
    }

    func unwrapDicToLabel(field: (Any?)?, errStr: String) -> String {
        let a = field ?? errStr
        let b = String(describing: a ?? errStr)
        return b
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            GlobalData.DataRaw.userData.remove(at: indexPath.row)
            
            SavedData.saveUserData(userData: GlobalData.DataRaw.userData)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
