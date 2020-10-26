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
    //let jsonweather:JSON
    let main:String
    let desc:String
    let mainjp:String
    let icon:String
    let pop:Double
    //let jsontemp:JSON
    let maxtemp:Double
    let mintemp:Double
    let maxtempRound:Int
    let mintempRound:Int
    let humidity:Int
    let humidPer:Double
    var laundryIndex:Int
    var laundryIndexdesc:String
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
        //self.jsonweather = jsonResponse["weather"].array![0]
        self.main = jsonResponse["weather"].array![0]["main"].stringValue
        self.desc = jsonResponse["weather"].array![0]["description"].stringValue
        self.icon = jsonResponse["weather"].array![0]["icon"].stringValue
        self.pop  = jsonResponse["pop"].doubleValue
        //self.jsontemp = jsonResponse["temp"]
        self.maxtemp = jsonResponse["temp"]["max"].doubleValue
        self.mintemp = jsonResponse["temp"]["min"].doubleValue
        self.maxtempRound = Int(round(maxtemp))
        self.mintempRound = Int(round(mintemp))
        self.humidity = jsonResponse["humidity"].intValue
        self.humidPer = Double(humidity) / 100
        self.e = 6.1078*pow(10, 7.5*maxtemp/(maxtemp+237.3))
        self.vaporAmount = 217*e/(10+273.15)
        //飽和水蒸気量
        
        self.humidCapacity = round(vaporAmount*(1-humidPer))
        
        switch Int(maxtemp){
        case -100...18 :
            self.totalScore = Int(round(humidCapacity*1))
            
        case 19:
            self.totalScore = Int(round(humidCapacity*1.05))
            
        case 20:
            self.totalScore = Int(round(humidCapacity*1.11))
            
        case 21:
            self.totalScore = Int(round(humidCapacity*1.17))
            
        case 22:
            self.totalScore = Int(round(humidCapacity*1.22))
            
        case 23:
            self.totalScore = Int(round(humidCapacity*1.28))
            
        case 24:
            self.totalScore = Int(round(humidCapacity*1.33))
            
        case 25...100:
            self.totalScore = Int(round(humidCapacity*1.4))
            
            
        default:
            print("ok")
        }
        
        
        switch totalScore! {
        case -500...5:
            self.laundryIndex = 1
            
            if self.pop >= 0.7{
                self.laundryIndex = 1
            }
        case 6...9:
            self.laundryIndex = 2
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
            print("エラー")
            
        }
        switch laundryIndex {
        case 1:
            self.laundryIndexdesc = "部屋干し推奨"
        case 2:
            self.laundryIndexdesc = "あまり乾かない"
        case 3:
            self.laundryIndexdesc = "やや乾く"
        case 4:
            self.laundryIndexdesc = "よく乾く"
        case 5:
            self.laundryIndexdesc = "大変よく乾く"
        default:
            self.laundryIndexdesc = "エラー"
        }
        
        switch desc {
        case "thunderstorm with light rain":
            self.mainjp = "雷雨"
        case "thunderstorm with rain":
            self.mainjp = "雷雨"
        case "thunderstorm with heavy rain":
            self.mainjp = "激しい雷雨"
        case "light thunderstorm":
            self.mainjp = "雷"
        case "thunderstorm":
            self.mainjp = "雷"
        case "heavy thunderstorm":
            self.mainjp = "激しい雷"
        case "ragged thunderstorm":
            self.mainjp = "雷"
        case "thunderstorm with light drizzle":
            self.mainjp = "雷雨"
        case "thunderstorm with drizzle":
            self.mainjp = "雷雨"
        case "thunderstorm with heavy drizzle":
            self.mainjp = "激しい雷雨"
        case "light intensity drizzle":
            self.mainjp = "弱い雨"
        case "drizzle":
            self.mainjp = "雨"
        case "heavy intensity drizzle":
            self.mainjp = "強い雨"
        case "light intensity drizzle rain":
            self.mainjp = "雨"
        case "drizzle rain":
            self.mainjp = "雨"
        case "heavy intensity drizzle rain":
            self.mainjp = "強い雨"
        case "shower rain and drizzle":
            self.mainjp = "雨"
        case "heavy shower rain and drizzle":
            self.mainjp = "激しい雨"
        case "shower drizzle":
            self.mainjp = "雨"
        case "light rain":
            self.mainjp = "弱い雨"
        case "moderate rain":
            self.mainjp = "雨"
        case "heavy intensity rain":
            self.mainjp = "強い雨"
        case "very heavy rain":
            self.mainjp = "激しい雨"
        case "extreme rain":
            self.mainjp = "とても激しい雨"
        case "freezing rain":
            self.mainjp = "ひょう"
        case "light intensity shower rain":
            self.mainjp = "弱い雨"
        case "shower rain":
            self.mainjp = "雨"
        case "heavy intensity shower rain":
            self.mainjp = "強い雨"
        case "ragged shower rain":
            self.mainjp = "雨"
        case "light snow":
            self.mainjp = "雪"
        case "Snow":
            self.mainjp = "雪"
        case "Heavy snow":
            self.mainjp = "激しい雪"
        case "Sleet":
            self.mainjp = "みぞれ"
        case "Light shower sleet":
            self.mainjp = "みぞれ"
        case "Shower sleet":
            self.mainjp = "みぞれ"
        case "Light rain and snow":
            self.mainjp = "雪"
        case "Rain and snow":
            self.mainjp = "雪"
        case "Light shower snow":
            self.mainjp = "雪"
        case "Shower snow":
            self.mainjp = "雪"
        case "Heavy shower snow":
            self.mainjp = "激しい雪"
        case "mist":
            self.mainjp = "きり"
        case "Smoke":
            self.mainjp = "きり"
        case "Haze":
            self.mainjp = "きり"
        case "sand/ dust whirls":
            self.mainjp = "砂塵"
        case "fog":
            self.mainjp = "きり"
        case "sand":
            self.mainjp = "砂塵"
        case "dust":
            self.mainjp = "砂塵"
        case "volcanic ash":
            self.mainjp = "火山灰"
        case "squalls":
            self.mainjp = "突風"
        case "tornado":
            self.mainjp = "竜巻"
        case "clear sky":
            self.mainjp = "快晴"
        case "few clouds":
            self.mainjp = "くもり"
        case "scattered clouds":
            self.mainjp = "くもり"
        case "broken clouds":
            self.mainjp = "くもり"
        case "overcast clouds":
            self.mainjp = "くもり"
            
        default:
            self.mainjp = "エラー"
            print("エラー")
        }
        
        
        
    }
    
}
