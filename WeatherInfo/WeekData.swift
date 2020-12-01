//
//  WeekData.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/11/17.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class WeekData: NSObject {

    let main:String
    let icon:String
    let desc:String
    
     init(string: String) {
        main = string
        switch main {
        case "img/100.png":
            self.icon = "晴れ"
            self.desc = icon
        case "img/101.png":
            self.icon = "晴れ時々曇り"
            self.desc = icon
        case "img/102.png":
            self.icon = "晴れ時々雨"
            self.desc = icon
        case "img/104.png":
            self.icon = "晴れ時々雪"
            self.desc = icon
        case "img/110.png":
            self.icon = "晴れのち曇り"
            self.desc = icon
        case "img/112.png":
            self.icon = "晴れのち雨"
            self.desc = icon
        case "img/115.png":
            self.icon = "晴れのち雪"
            self.desc = icon
        case "img/200.png":
            self.icon = "曇り"
            self.desc = icon
        case "img/201.png":
            self.icon = "曇り時々晴れ"
            self.desc = icon
        case "img/202.png":
            self.icon = "曇り時々雨"
            self.desc = icon
        case "img/204.png":
            self.icon = "曇り時々雪"
            self.desc = icon
        case "img/210.png":
            self.icon = "曇りのち晴れ"
            self.desc = icon
        case "img/212.png":
            self.icon = "曇りのち雨"
            self.desc = icon
        case "img/215.png":
            self.icon = "曇りのち雪"
            self.desc = icon
        case "img/300.png":
            self.icon = "雨"
            self.desc = icon
        case "img/301.png":
            self.icon = "雨時々晴れ"
            self.desc = icon
        case "img/302.png":
            self.icon = "雨時々曇り"
            self.desc = icon
        case "img/303.png":
            self.icon = "雨時々雪"
            self.desc = icon
        case "img/308.png":
            self.icon = "暴雨風"
            self.desc = icon
        case "img/311.png":
            self.icon = "雨のち晴れ"
            self.desc = icon
        case "img/313.png":
            self.icon = "雨のち曇り"
            self.desc = icon
        case "img/314.png":
            self.icon = "雨のち雪"
            self.desc = icon
        case "img/400.png":
            self.icon = "雪"
            self.desc = icon
        case "img/401.png":
            self.icon = "雪時々晴れ"
            self.desc = icon
        case "img/402.png":
            self.icon = "雪時々曇り"
            self.desc = icon
        case "img/403.png":
            self.icon = "雪時々雨"
            self.desc = icon
        case "img/406.png":
            self.icon = "暴風雪"
            self.desc = icon
        case "img/411.png":
            self.icon = "雪のち晴れ"
            self.desc = icon
        case "img/413.png":
            self.icon = "雪のち曇り"
            self.desc = icon
        case "img/414.png":
            self.icon = "雪のち雨"
            self.desc = icon
        case "img/700.png":
            self.icon = "晴れ(夜)"
            self.desc = "晴れ"
        case "img/701.png":
            self.icon = "晴れ(夜)時々曇り"
            self.desc = "晴れ時々曇り"
        case "img/702.png":
            self.icon = "晴れ(夜)時々雨"
            self.desc = "晴れ時々雨"
        case "img/703.png":
            self.icon = "晴れ(夜)時々雪"
            self.desc = "晴れ時々雪"
        case "img/704.png":
            self.icon = "曇り時々晴れ(夜)"
            self.desc = "曇り時々晴れ"
        case "img/705.png":
            self.icon = "雨時々晴れ(夜)"
            self.desc = "雨時々晴れ"
        case "img/706.png":
            self.icon = "雪時々晴れ(夜)"
            self.desc = "雪時々晴れ"
        case "img/707.png":
            self.icon = "晴れ(夜)のち曇り"
            self.desc = "晴れのち曇り"
        case "img/708.png":
            self.icon = "晴れ(夜)のち雨"
            self.desc = "晴れのち雨"
        case "img/709.png":
            self.icon = "晴れ(夜)のち雪"
            self.desc = "晴れのち雪"
        case "img/710.png":
            self.icon = "曇りのち晴れ(夜)"
            self.desc = "曇りのち晴れ"
        case "img/711.png":
            self.icon = "雨のち晴れ(夜)"
            self.desc = "雨のち晴れ"
        case "img/712.png":
            self.icon = "雪のち晴れ(夜)"
            self.desc = "雪のち晴れ"
        default:
            self.icon = ""
            self.desc = ""
        }
    }
}
