//
//  HourlyData.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/07.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HourlyData: NSObject {
    var outputFormatterHH = DateFormatter()
    let jsondt: Double
    let hourlydt:String
    let temp: Double
    let humidity: Int
    
    init(jsonResponse: JSON) {
        self.jsondt = jsonResponse["dt"].doubleValue
        outputFormatterHH.dateFormat = "HH時"
        self.hourlydt = (outputFormatterHH.string(from: Date(timeIntervalSince1970: jsondt)))
        self.temp = jsonResponse["temp"].doubleValue
        self.humidity = jsonResponse["humidity"].intValue
    }
}
