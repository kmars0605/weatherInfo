//
//  OfficialData.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/11/04.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class OfficialData: NSObject {

    let dayTDWeather:String
    //let dayTMWeather:String
    //let dayDATWeather:String
    
    init(string:String){
        self.dayTDWeather = string
    }
    
}
