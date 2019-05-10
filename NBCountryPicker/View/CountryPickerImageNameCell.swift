//
//  CountryPickerImageNameCell.swift
//  CountryPickerView
//
//  Created by Nikhil Bhownani on 23/03/19.
//  Copyright © 2019 Nikhil Bhownani. All rights reserved.
//

import UIKit

class CountryPickerImageNameCell: UITableViewCell, CountryPickerCellProtocol {
    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setup(country: Country) {
        flagImageView.image = UIImage(named: country.flagName)
        nameLabel.text = country.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
