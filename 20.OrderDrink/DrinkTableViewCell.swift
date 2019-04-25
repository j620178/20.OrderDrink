//
//  DrinkTableViewCell.swift
//  20.OrderDrink
//
//  Created by 張睿哲 on 2019/4/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
