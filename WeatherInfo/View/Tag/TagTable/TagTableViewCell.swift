//
//  TagTableViewCell.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/19.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    @IBOutlet weak var JISLabel: UILabel!
    @IBOutlet weak var newJISLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
