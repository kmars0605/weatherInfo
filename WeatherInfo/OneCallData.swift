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
    let jsonresponse:JSON
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
    //let jsonweather: JSON
    let main: String
    let dscrption: String
    let icon:String
    
    let hourly: [HourlyData]
    var outputFormatterHH = DateFormatter()
    var outputFormatterDD = DateFormatter()
    
    let daily: [DailyData]
  
    init(jsonResponse:JSON) {
        self.jsonresponse = jsonResponse
        self.lat = jsonResponse["lat"].floatValue
        self.lon = jsonResponse["lon"].floatValue
        
        self.jsoncurrent = jsonResponse["current"]
        self.jsondt = jsonResponse["current"]["dt"].doubleValue
        outputFormatterHH.dateFormat = "HH時"
        self.hourdt = (outputFormatterHH.string(from: Date(timeIntervalSince1970: jsondt)))
        outputFormatterDD.locale = Locale(identifier: "ja_JP")
        outputFormatterDD.dateFormat = "d日(EEE)"
        self.daydt = (outputFormatterDD.string(from: Date(timeIntervalSince1970: jsondt)))
        self.sunrise = jsonResponse["current"]["sunrise"].doubleValue
        self.sunset = jsonResponse["current"]["sunset"].doubleValue
        self.temp = jsonResponse["current"]["temp"].doubleValue
        self.tempRound = Int(round(temp))
        self.feellike = jsonResponse["current"]["feel_like"].doubleValue
        self.pressure = jsonResponse["current"]["pressure"].intValue
        self.humidity = jsonResponse["current"]["humidity"].intValue
        self.uv = jsonResponse["current"]["uvi"].doubleValue
        self.clouds = jsonResponse["current"]["clouds"].intValue
        self.windSpeed = jsonResponse["current"]["wind_speed"].doubleValue
        self.windDeg = jsonResponse["current"]["wind_deg"].intValue
        //self.jsonweather = jsonResponse["current"]["weather"].array![0]
        self.main = jsonResponse["current"]["weather"].array![0]["main"].stringValue
        self.dscrption = jsonResponse["current"]["weather"].array![0]["description"].stringValue
        self.icon = jsonResponse["current"]["weather"].array![0]["icon"].stringValue
        
        
       
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
