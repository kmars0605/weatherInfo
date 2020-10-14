//
//  DailyTableViewCell.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/12.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    //日付を表示
    @IBOutlet weak var dayLabel: UILabel!
    //天気を表示
    @IBOutlet weak var weatherImage: UIImageView!
    //最高気温を表示
    @IBOutlet weak var maxtemp: UILabel!
    //最低気温を表示
    @IBOutlet weak var mintemp: UILabel!
    //湿度を表示
    @IBOutlet weak var humidity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //DailyDataをセルに表示
    func setDailyData(_ dailyData: DailyData){
        self.dayLabel.text = "\(dailyData.daydt)"
        self.maxtemp.text = "\(dailyData.maxtemp)℃"
        self.mintemp.text = "\(dailyData.mintemp)℃"
        self.humidity.text = "\(dailyData.humidity)%"
        if let weatherIcon = URL(string: "https://openweathermap.org/img/wn/\(dailyData.icon).png"),
            let data = try? Data(contentsOf: weatherIcon),
            let image = UIImage(data: data) {
            self.weatherImage.image = image
        }
        
    }
    
}
