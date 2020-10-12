//
//  HourlyCollectionViewCell.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/07.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HourlyCollectionViewCell: UICollectionViewCell {

    //時間を表示するラベル
    @IBOutlet weak var timeLabel: UILabel!
    //気温を表示するラベル
    @IBOutlet weak var tempLabel: UILabel!
    //湿度を表示するラベル
    @IBOutlet weak var humidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setHourlyData(_ onecall:OneCallData){
        //時間の表示
        self.timeLabel.text = "\(onecall.dt)"
        //気温の表示
        self.tempLabel.text = "\(onecall.temp)"
        //print(self.tempLabel.text)
        //湿度の表示
        //self.humidLabel.text = "\(hourlyData.humidity)"
        //print(self.humidLabel.text)
    }




}

