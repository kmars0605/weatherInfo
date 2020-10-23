//
//  OneCallData.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/07.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OneCallData: NSObject {
    
    let lat: Float
    let lon: Float
    let jsoncurrent: JSON
    let jsondt: Double
    let hourdt:String
    let daydt:String
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let tempRound:Int
    let feellike: Double
    let pressure: Int
    let humidity: Int
    let uv: Double
    let clouds: Int
    let windSpeed: Double
    let windDeg: Int
    let jsonweather: JSON
    let main: String
    let dscrption: String
    let icon:String
    
    let hourly: [HourlyData]
    var outputFormatterHH = DateFormatter()
    var outputFormatterDD = DateFormatter()
    
    let daily: [DailyData]
  
    init(jsonResponse:JSON) {
        self.lat = jsonResponse["lat"].floatValue
        self.lon = jsonResponse["lon"].floatValue
        
        self.jsoncurrent = jsonResponse["current"]
        self.jsondt = jsonResponse["current"]["dt"].doubleValue
        outputFormatterHH.dateFormat = "HH時"
        self.hourdt = (outputFormatterHH.string(from: Date(timeIntervalSince1970: jsondt)))
        outputFormatterDD.locale = Locale(identifier: "ja_JP")
        outputFormatterDD.dateFormat = "d日(EEE)"
        self.daydt = (outputFormatterDD.string(from: Date(timeIntervalSince1970: jsondt)))
        self.sunrise = jsoncurrent["sunrise"].doubleValue
        self.sunset = jsoncurrent["sunset"].doubleValue
        self.temp = jsoncurrent["temp"].doubleValue
        self.tempRound = Int(round(temp))
        self.feellike = jsoncurrent["feel_like"].doubleValue
        self.pressure = jsoncurrent["pressure"].intValue
        self.humidity = jsoncurrent["humidity"].intValue
        self.uv = jsoncurrent["uvi"].doubleValue
        self.clouds = jsoncurrent["clouds"].intValue
        self.windSpeed = jsoncurrent["wind_speed"].doubleValue
        self.windDeg = jsoncurrent["wind_deg"].intValue
        self.jsonweather = jsoncurrent["weather"].array![0]
        self.main = jsonweather["main"].stringValue
        self.dscrption = jsonweather["description"].stringValue
        self.icon = jsonweather["icon"].stringValue
        
        
       
        var hourlyData: [HourlyData] = []
        for json in jsonResponse["hourly"].arrayValue {
            hourlyData.append(HourlyData(jsonResponse: json))
           
        }
        self.hourly = hourlyData
        
        var dailyData: [DailyData] = []
        for json in jsonResponse["daily"].arrayValue{
            dailyData.append(DailyData(jsonResponse: json))
        }
        self.daily = dailyData
        

    }
    
}
