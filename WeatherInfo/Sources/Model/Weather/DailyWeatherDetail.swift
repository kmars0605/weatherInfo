import Foundation

class DailyWeatherDetail: Codable {
    let desc:String
    let mainjp:String
    let jsonicon:String
    let icon:String
    let pop:Double
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

    init(daily: Daily) {
        self.desc = daily.weather[0].description
        self.jsonicon = daily.weather[0].icon
        self.pop  = daily.pop
        self.maxtemp = daily.temp.max
        self.mintemp = daily.temp.min
        self.maxtempRound = Int(round(maxtemp))
        self.mintempRound = Int(round(mintemp))
        self.humidity = daily.humidity
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
            break
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
        }
        switch laundryIndex {
        case 1:
            self.laundryIndexdesc = L10n.LaundryIndexLevel1.TiTle.text
        case 2:
            self.laundryIndexdesc = L10n.LaundryIndexLevel2.TiTle.text
        case 3:
            self.laundryIndexdesc = L10n.LaundryIndexLevel3.TiTle.text
        case 4:
            self.laundryIndexdesc = L10n.LaundryIndexLevel4.TiTle.text
        case 5:
            self.laundryIndexdesc = L10n.LaundryIndexLevel5.TiTle.text
        default:
            self.laundryIndexdesc = L10n.LaundryIndexErrorView.Title.text
        }
        switch desc {
        //雷
        case "thunderstorm with light rain":
            self.mainjp = "雷雨"
            self.icon = "11d"
        case "thunderstorm with rain":
            self.mainjp = "雷雨"
            self.icon = "11d"
        case "thunderstorm with heavy rain":
            self.mainjp = "激しい雷雨"
            self.icon = "11d"
        case "light thunderstorm":
            self.mainjp = "雷"
            self.icon = "11d"
        case "thunderstorm":
            self.mainjp = "雷"
            self.icon = "11d"
        case "heavy thunderstorm":
            self.mainjp = "激しい雷"
            self.icon = "11d"
        case "ragged thunderstorm":
            self.mainjp = "雷"
            self.icon = "11d"
        case "thunderstorm with light drizzle":
            self.mainjp = "雷雨"
            self.icon = "11d"
        case "thunderstorm with drizzle":
            self.mainjp = "雷雨"
            self.icon = "11d"
        case "thunderstorm with heavy drizzle":
            self.mainjp = "激しい雷雨"
            self.icon = "11d"
        //雨
        case "light intensity drizzle":
            self.mainjp = "弱い雨"
            self.icon = "09d"
        case "drizzle":
            self.mainjp = "雨"
            self.icon = "09d"
        case "heavy intensity drizzle":
            self.mainjp = "強い雨"
            self.icon = "10d"
        case "light intensity drizzle rain":
            self.mainjp = "雨"
            self.icon = "10d"
        case "drizzle rain":
            self.mainjp = "雨"
            self.icon = "10d"
        case "heavy intensity drizzle rain":
            self.mainjp = "強い雨"
            self.icon = "10d"
        case "shower rain and drizzle":
            self.mainjp = "雨"
            self.icon = "10d"
        case "heavy shower rain and drizzle":
            self.mainjp = "激しい雨"
            self.icon = "10d"
        case "shower drizzle":
            self.mainjp = "雨"
            self.icon = "09d"
        case "light rain":
            self.mainjp = "弱い雨"
            self.icon = "09d"
        case "moderate rain":
            self.mainjp = "雨"
            self.icon = "10d"
        case "heavy intensity rain":
            self.mainjp = "強い雨"
            self.icon = "10d"
        case "very heavy rain":
            self.mainjp = "激しい雨"
            self.icon = "10d"
        case "extreme rain":
            self.mainjp = "とても激しい雨"
            self.icon = "10d"
        case "freezing rain":
            self.mainjp = "ひょう"
            self.icon = "13d"
        case "light intensity shower rain":
            self.mainjp = "弱い雨"
            self.icon = "09d"
        case "shower rain":
            self.mainjp = "雨"
            self.icon = "10d"
        case "heavy intensity shower rain":
            self.mainjp = "強い雨"
            self.icon = "10d"
        case "ragged shower rain":
            self.mainjp = "雨"
            self.icon = "10d"
        //ゆき
        case "light snow":
            self.mainjp = "雪"
            self.icon = "13d"
        case "snow":
            self.mainjp = "雪"
            self.icon = "13d"
        case "heavy snow":
            self.mainjp = "激しい雪"
            self.icon = "13d"
        case "sleet":
            self.mainjp = "みぞれ"
            self.icon = "13d"
        case "light shower sleet":
            self.mainjp = "みぞれ"
            self.icon = "13d"
        case "shower sleet":
            self.mainjp = "みぞれ"
            self.icon = "13d"
        case "light rain and snow":
            self.mainjp = "雪"
            self.icon = "13d"
        case "rain and snow":
            self.mainjp = "雪"
            self.icon = "13d"
        case "light shower snow":
            self.mainjp = "雪"
            self.icon = "13d"
        case "shower snow":
            self.mainjp = "雪"
            self.icon = "13d"
        case "heavy shower snow":
            self.mainjp = "激しい雪"
            self.icon = "13d"
        //その他
        case "mist":
            self.mainjp = "きり"
            self.icon = "50d"
        case "smoke":
            self.mainjp = "きり"
            self.icon = "50d"
        case "haze":
            self.mainjp = "きり"
            self.icon = "50d"
        case "sand/ dust whirls":
            self.mainjp = "砂塵"
            self.icon = "50d"
        case "fog":
            self.mainjp = "きり"
            self.icon = "50d"
        case "sand":
            self.mainjp = "砂塵"
            self.icon = "50d"
        case "dust":
            self.mainjp = "砂塵"
            self.icon = "50d"
        case "volcanic ash":
            self.mainjp = "火山灰"
            self.icon = "50d"
        case "squalls":
            self.mainjp = "突風"
            self.icon = "50d"
        case "tornado":
            self.mainjp = "竜巻"
            self.icon = "50d"
        //晴れ
        case "clear sky":
            self.mainjp = "快晴"
            switch self.jsonicon {
            case "01d":
                self.icon = "01d"
            case "01n":
                self.icon = "01n"
            default:
                self.icon = "01d"
            }
        case "few clouds":
            self.mainjp = "晴れ"
            switch self.jsonicon {
            case "02d":
                self.icon = "02d"
            case "02n":
                self.icon = "02n"
            default:
                self.icon = "01d"
            }
        //くもり
        case "scattered clouds":
            self.mainjp = "くもり"
            self.icon = "03d"
        case "broken clouds":
            self.mainjp = "くもり"
            self.icon = "04d"
        case "overcast clouds":
            self.mainjp = "くもり"
            self.icon = "04d"
        default:
            self.mainjp = "エラー"
            self.icon = "エラー"
        }
    }
}
