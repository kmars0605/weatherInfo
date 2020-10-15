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

    var onecall: OneCallData?
    //時間を表示するラベル
    @IBOutlet weak var timeLabel: UILabel!
    //気温を表示するラベル
    @IBOutlet weak var tempLabel: UILabel!
    //湿度を表示するラベル
    @IBOutlet weak var humidLabel: UILabel!
    //天気画像を表示するビュー
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setHourlyData(_ hourlyData:HourlyData){
        //時間の表示
        self.timeLabel.text = "\(hourlyData.hourlydt)"
        //気温の表示
        self.tempLabel.text = "\(hourlyData.tempRound)℃"
        //湿度の表示
        self.humidLabel.text = "\(hourlyData.humidity)%"
        //画像を表示
        if let weatherIcon = URL(string: "https://openweathermap.org/img/wn/\(hourlyData.icon).png"),
           let data = try? Data(contentsOf: weatherIcon),
           let image = UIImage(data: data) {
           self.imageView.image = image
       }
        
    }




}

