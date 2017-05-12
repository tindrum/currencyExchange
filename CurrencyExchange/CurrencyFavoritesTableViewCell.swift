//
//  CurrencyFavoritesTableViewCell.swift
//  CurrencyExchange
//
//  Created by Daniel Henderson on 5/11/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import UIKit

class CurrencyFavoritesTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var faveStar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
