import UIKit

class DailyTableViewCell: UITableViewCell {
    //日付を表示
    @IBOutlet weak var dayLabel: UILabel!
    //天気を表示
    @IBOutlet weak var weatherImage: UIImageView!
    //最高気温を表示
    @IBOutlet weak var maxtemp: UILabel!
    //最低気温を表示
    @IBOutlet weak var mintemp: UILabel!
    //湿度を表示
    @IBOutlet weak var humidity: UILabel!
    //洗濯指数を表示
    @IBOutlet weak var laundryIndex: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //DailyDataをセルに表示
    func setDailyData(_ daily: Daily,_ detail: DailyWeatherDetail){
        let outputFormatterDD = DateFormatter()
        outputFormatterDD.locale = Locale(identifier: "ja_JP")
        outputFormatterDD.dateFormat = "d日(EEE)"
        let day = (outputFormatterDD.string(from: Date(timeIntervalSince1970: Double(daily.dt))))
        self.dayLabel.adjustsFontSizeToFitWidth = true
        self.dayLabel.text = "\(day)"
        self.maxtemp.adjustsFontSizeToFitWidth = true
        self.maxtemp.text = "\(Int(round(daily.temp.max)))℃"
        self.mintemp.adjustsFontSizeToFitWidth = true
        self.mintemp.text = "\(Int(round(daily.temp.min)))℃"
        self.humidity.adjustsFontSizeToFitWidth = true
        self.humidity.text = "\(daily.humidity)%"
        self.weatherImage.image = UIImage(named: "\(daily.weather[0].icon)")
        self.laundryIndex.image = UIImage(named: "index\(detail.laundryIndex)")
    }
}
