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
    let mainjp:String
    let icon:String
    let pop:Double
    let jsontemp:JSON
    let maxtemp:Double
    let mintemp:Double
    let maxtempRound:Int
    let mintempRound:Int
    let humidity:Int
    let humidPer:Double
    var laundryIndex:Int
    var e:Double
    var vaporAmount:Double
    var humidCapacity:Double
    var totalScore:Int?
    var outputFormatterDD = DateFormatter()
    
    
    
    init(jsonResponse: JSON) {
        self.jsondt = jsonResponse["dt"].doubleValue
        outputFormatterDD.locale = Locale(identifier: "ja_JP")
        outputFormatterDD.dateFormat = "d日(EEE)"
        self.daydt = (outputFormatterDD.string(from: Date(timeIntervalSince1970: jsondt)))
        self.jsonweather = jsonResponse["weather"].array![0]
        self.main = jsonweather["main"].stringValue
        self.icon = jsonweather["icon"].stringValue
        self.pop  = jsonResponse["pop"].doubleValue
        self.jsontemp = jsonResponse["temp"]
        self.maxtemp = jsontemp["max"].doubleValue
        self.mintemp = jsontemp["min"].doubleValue
        self.maxtempRound = Int(round(maxtemp))
        self.mintempRound = Int(round(mintemp))
        self.humidity = jsonResponse["humidity"].intValue
        self.humidPer = Double(humidity) / 100
        self.e = 6.1078*pow(10, 7.5*maxtemp/(maxtemp+237.3))
        self.vaporAmount = 217*e/(10+273.15)
        //飽和水蒸気量
        print("飽和水蒸気量：\(vaporAmount)")
        self.humidCapacity = round(vaporAmount*(1-humidPer))
        print("含有力:\(humidCapacity)")
        
        switch Int(maxtemp){
        case -100...18 :
            self.totalScore = Int(round(humidCapacity*1))
            print(totalScore!)
        case 19:
            self.totalScore = Int(round(humidCapacity*1.05))
            print(totalScore!)
        case 20:
            self.totalScore = Int(round(humidCapacity*1.11))
            print(totalScore!)
        case 21:
            self.totalScore = Int(round(humidCapacity*1.17))
            print(totalScore!)
        case 22:
            self.totalScore = Int(round(humidCapacity*1.22))
            print(totalScore!)
        case 23:
            self.totalScore = Int(round(humidCapacity*1.28))
            print(totalScore!)
        case 24:
            self.totalScore = Int(round(humidCapacity*1.33))
            print(totalScore!)
        case 25...100:
            self.totalScore = Int(round(humidCapacity*1.4))
            print(totalScore!)
            
        default:
            print("ok")
        }
        
        
        switch totalScore! {
        case -500...5:
            self.laundryIndex = 1
            print("洗濯指数：1")
            if self.pop >= 0.7{
                self.laundryIndex = 1
            }
        case 6...9:
            self.laundryIndex = 2
            print("洗濯指数：2")
            switch pop {
            case 0.7...1:
                self.laundryIndex = 1
            case 0.5...0.69:
                self.laundryIndex = 2
            case 0.3...0.49:
                self.laundryIndex = 2
            default:
                self.laundryIndex = 2
            }
        case 10...13:
            self.laundryIndex = 3
            print("洗濯指数：3")
            switch pop {
            case 0.7...1:
                self.laundryIndex = 1
            case 0.5...0.69:
                self.laundryIndex = 2
            case 0.3...0.49:
                self.laundryIndex = 3
            default:
                self.laundryIndex = 3
            }
        case 14...16:
            self.laundryIndex = 4
            print("洗濯指数：4")
            switch pop {
            case 0.7...1:
                self.laundryIndex = 1
            case 0.5...0.69:
                self.laundryIndex = 2
            case 0.3...0.49:
                self.laundryIndex = 3
            default:
                self.laundryIndex = 4
            }
        case 17...500:
            self.laundryIndex = 5
            print("洗濯指数：5")
            switch pop {
            case 0.7...1:
                self.laundryIndex = 1
            case 0.5...0.69:
                self.laundryIndex = 2
            case 0.3...0.49:
                self.laundryIndex = 3
            default:
                self.laundryIndex = 5
            }
        default:
            self.laundryIndex = 6
            print("ok")
            
        }
        
        switch main {
        case "Thunderstorm":
            self.mainjp = "雷雨"
        case "Drizzle":
            self.mainjp = "弱い雨"
        case "Rain":
            self.mainjp = "雨"
        case "Snow":
            self.mainjp = "雪"
        case "Clear":
            self.mainjp = "快晴"
        case "Clouds":
            self.mainjp = "雷雨"
        case "Thunderstorm":
            self.mainjp = "雷雨"
        case "Thunderstorm":
            self.mainjp = "雷雨"
        case "Thunderstorm":
            self.mainjp = "雷雨"
        case "Thunderstorm":
            self.mainjp = "雷雨"
        default:
            self.mainjp = "a"
            print("a")
        }
        
        
        
    }
    
}
