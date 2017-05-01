//
//  UserDataTableViewCell.swift
//  Dribe
//
//  Created by Tyler Ibbotson-Sindelar on 4/30/17.
//
//

import UIKit

class UserDataTableViewCell: UITableViewCell {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var tirednessLabel: UILabel!
    @IBOutlet weak var bacLabel: UILabel!
    @IBOutlet weak var drinksLabel: UILabel!
    @IBOutlet weak var failsLabel: UILabel!
    @IBOutlet weak var reactionTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
