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
    //    let jsonCurrent:String
    //
    //    let jsonCurrentdt:String
    //    let currentdt: Double?
    //
    //    let jsonSunrise:JSON
    //    let jsonSunset:JSON
    //
    //    let jsonCurrentTemp:Double?
    //    let currentTemp :Double?
    //
    //    let currentHumid :Int
    //
    //    let jsonUV :JSON
    //
    //    let jsonCurrentWindSpeed :JSON
    //    let jsonCurrentWindDeg :JSON
    //
    //    let jsonCurrentWeather :JSON
    //
    //    //minutely情報
    //    let jsonMinute :JSON
    //    let minutedt :JSON
    //    let precipitation :JSON
    //    var outputFormatter = DateFormatter()
    //
    //    //hourly情報
    //    let jsonHourlyarray :JSON
    //
    //    let jsonHourly:JSON
    //    let jsonHourlydt:JSON
    //    let hourdt : Double?
    //
    //    let jsonHourlyTemp :Double?
    //    let hourlyTemp:Double?
    //    let jsonHourlyHumid :JSON
    //
    //    let jsonHourlyClouds :JSON
    //
    //    let jsonHourlyWindSpeed :JSON
    //
    //    let jsonHourlyWindDeg :JSON
    //
    //    let jsonHoulyWeather:JSON
    // CurrentData(jsonResponse: jsonResponse)
    init(jsonResponse:JSON) {
        self.lat = jsonResponse["lat"].floatValue
        self.lon = jsonResponse["lon"].floatValue
        
        self.jsoncurrent = jsonResponse["current"]
        self.jsondt = jsoncurrent["dt"].doubleValue
        outputFormatterHH.dateFormat = "HH時"
        self.hourdt = (outputFormatterHH.string(from: Date(timeIntervalSince1970: jsondt)))
        outputFormatterDD.locale = Locale(identifier: "ja_JP")
        outputFormatterDD.dateFormat = "dd日(EEE)"
        self.daydt = (outputFormatterDD.string(from: Date(timeIntervalSince1970: jsondt)))
        self.sunrise = jsoncurrent["sunrise"].doubleValue
        self.sunset = jsoncurrent["sunset"].doubleValue
        self.temp = jsoncurrent["temp"].doubleValue
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
        
        
        /*var currentData: [CurrentData] = []
        
        for json in 0...1 {
            currentData.append(CurrentData(jsonResponse: jsonResponse["current"]))
            print("aaa")
            print(currentData.count)
        }
        self.current = currentData*/
        
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
        
//        //Current情報
//        jsonCurrent = jsonResponse["current"].string!
//        
//        jsonCurrentdt = jsonCurrent["dt"]
//        currentdt = Double("\(jsonCurrentdt)")
//        
//        jsonSunrise = jsonCurrent["sunrise"]
//        jsonSunset = jsonCurrent["sunset"]
//        
//        jsonCurrentTemp = Double("\(jsonCurrent["temp"])")
//        currentTemp = round(jsonCurrentTemp!)
//        
//        jsonCurrentHumid = jsonCurrent["humidity"]
//        
//        jsonUV = jsonCurrent["uvi"]
//        
//        jsonCurrentWindSpeed = jsonCurrent["wind_speed"]
//        jsonCurrentWindDeg = jsonCurrent["wind_deg"]
//        
//        jsonCurrentWeather = jsonCurrent["weather"].array![0]
//        //その他もこのように場合分けして日本語にするSwitch文？
//        if jsonCurrentWeather["main"].stringValue == "Clouds"{
//            //self.weatherLabel.text = "くもり"
//        }
//        
//        
//        //minutely情報
//        jsonMinute = jsonResponse["minutely"]
//        minutedt = jsonMinute["dt"]
//        precipitation = jsonMinute["precipitation"]
//        outputFormatter = DateFormatter()
//        
//        //hourly情報
//        jsonHourlyarray = jsonResponse["hourly"]
//        
//        
//        jsonHourly = jsonHourlyarray.array![0]
//        jsonHourlydt = jsonHourly["dt"]
//        
//        print("//////////")
//        
//        print(jsonHourlydt)
//        hourdt = Double("\(jsonHourlydt)")
//        
//        jsonHourlyTemp = Double("\(jsonHourly["temp"])")
//        
//        hourlyTemp = round(jsonHourlyTemp!)
//        
//        jsonHourlyHumid = jsonHourly["humidity"]
//        
//        jsonHourlyClouds = jsonHourly["clouds"]
//        
//        jsonHourlyWindSpeed = jsonHourly["wind_speed"]
//        
//        jsonHourlyWindDeg = jsonHourly["wind_deg"]
//        
//        jsonHoulyWeather = jsonHourly["weather"].array![0]
//        
//        if jsonHoulyWeather["main"].stringValue == "Clouds"{
//            
//        }
//        
//        outputFormatter.dateFormat = "HH時"
//        //self.timeLabel.text = (outputFormatter.string(from: Date(timeIntervalSince1970: dt!)))
//        outputFormatter.dateFormat = ""
//        
//        /*case .failure(let value):
//         debugPrint(value)
//         }
//         
//         
//         }*/
//        //}
    }
    
}
