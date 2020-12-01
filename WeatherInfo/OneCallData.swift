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
import Kanna

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
    let jsonweather: JSON
    let main: String
    let dscrption: String
    let icon:String
    
    let hourly: [HourlyData]
    var outputFormatterHH = DateFormatter()
    var outputFormatterDD = DateFormatter()
    
    let daily: [DailyData]
    
    let weekly: [WeekData]
   
    //var officialData1:[String]
    var o1:String
    var o2:String
    var o3:String
    //var b:String
    //var officialData2:String
    //var officialData3:String
    
    init(jsonResponse:JSON,string1:String = "未定",string2:String = "未定",string3:String = "未定", array:[String] = []/*[String] = []*/) {
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
        self.jsonweather = jsonResponse["current"]["weather"].array![0]
        self.main = jsonweather["main"].stringValue
        self.dscrption = jsonweather["description"].stringValue
        self.icon = jsonweather["icon"].stringValue
        //self.officialData1 = string
        self.o1 = string1
        self.o2 = string2
        self.o3 = string3
        
        
        var hourlyData: [HourlyData] = []
        for json in jsonResponse["hourly"].arrayValue {
            hourlyData.append(HourlyData(jsonResponse: json))
            
        }
        self.hourly = hourlyData
        
        var dailyData: [DailyData] = []
        for json in jsonResponse["daily"].arrayValue{
            dailyData.append(DailyData(jsonResponse: json, string1:o1, string2: o2, string3: o3))
        }
        self.daily = dailyData
        
        var weekData: [WeekData] = []
        for i in array{
            weekData.append(WeekData(string: i))
        }
        //weekData.insert(WeekData(string: string1), at: 0)
        self.weekly = weekData
        //self.officialData2 =
    }
    
    
    

    
    
}





