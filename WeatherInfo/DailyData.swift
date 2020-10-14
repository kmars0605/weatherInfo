//
//  DailyData.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/12.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DailyData: NSObject {
    
    let jsondt:Double
    let daydt:String
    let jsonweather:JSON
    let main:String
    let icon:String
    let jsontemp:JSON
    let maxtemp:Double
    let mintemp:Double
    let humidity:Int
    var outputFormatterDD = DateFormatter()
    
    init(jsonResponse: JSON) {
        self.jsondt = jsonResponse["dt"].doubleValue
        outputFormatterDD.locale = Locale(identifier: "ja_JP")
        outputFormatterDD.dateFormat = "d日(EEE)"
        self.daydt = (outputFormatterDD.string(from: Date(timeIntervalSince1970: jsondt)))
        self.jsonweather = jsonResponse["weather"].array![0]
        self.main = jsonweather["main"].stringValue
        self.icon = jsonweather["icon"].stringValue
        self.jsontemp = jsonResponse["temp"]
        self.maxtemp = jsontemp["max"].doubleValue
        self.mintemp = jsontemp["min"].doubleValue
        self.humidity = jsonResponse["humidity"].intValue
        
    }

}
