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
    let tempRound: Int
    let humidity: Int
    //let jsonweather:JSON
    let main:String
    var icon:String
    let windspd:Double
    let pop:Double
    
    init(jsonResponse: JSON) {
        self.jsondt = jsonResponse["dt"].doubleValue
        outputFormatterHH.dateFormat = "H時"
        self.hourlydt = (outputFormatterHH.string(from: Date(timeIntervalSince1970: jsondt)))
        self.temp = jsonResponse["temp"].doubleValue
        self.tempRound = Int(round(temp))
        self.humidity = jsonResponse["humidity"].intValue
        //self.jsonweather = jsonResponse["weather"].array![0]
        self.main = jsonResponse["weather"].array![0]["main"].stringValue
        self.icon = jsonResponse["weather"].array![0]["icon"].stringValue
        if self.icon == "02d" {
            self.icon = "03d"
        }else if self.icon == "02n"{
            self.icon = "03n"
        }
        self.windspd = jsonResponse["wind_speed"].doubleValue
        self.pop = jsonResponse["pop"].doubleValue * 100
        
        
    }
}
