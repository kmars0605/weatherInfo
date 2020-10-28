//
//  IconDescTableViewCell.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/27.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class IconDescTableViewCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
