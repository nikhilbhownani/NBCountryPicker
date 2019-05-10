//
//  CountryPickerTableViewCell.swift
//  CountryPickerView
//
//  Created by Nikhil Bhownani on 23/03/19.
//  Copyright © 2019 Nikhil Bhownani. All rights reserved.
//

import UIKit

class CountryPickerTableViewCell: UITableViewCell, CountryPickerCellProtocol {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(country:Country) {
        nameLabel.text = country.name
    }
}
