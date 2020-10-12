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
    let dt: Double
    let temp: Double
    let humidity: Int
    
    init(jsonResponse: JSON) {
        self.dt = jsonResponse["dt"].doubleValue
        self.temp = jsonResponse["temp"].doubleValue
        self.humidity = jsonResponse["humidity"].intValue
    }
}
