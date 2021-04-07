import UIKit
import Foundation

class HeaderView: UIView {
    @IBOutlet weak var todayImageView: UIImageView!
    @IBOutlet weak var tomorrowImageView: UIImageView!
    //日付を表示するラベル
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var tomorrowLabel: UILabel!
    //天気を表示するラベル
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tomorrowWeatherLabel: UILabel!
    //最高気温を表示するラベル
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var tomorrowMaxTempLabel: UILabel!
    //最低気温を表示するラベル
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var tomorrowMinTempLabel: UILabel!

    // コードから呼び出す際使用
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    // Storyboardから利用する際に使用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

    func set(onecall:OneCall,detail: [DailyWeatherDetail]) {
        let outputFormatterDD = DateFormatter()
        outputFormatterDD.locale = Locale(identifier: "ja_JP")
        outputFormatterDD.dateFormat = "d日(EEE)"
        let today = (outputFormatterDD.string(from: Date(timeIntervalSince1970: Double(onecall.daily[0].dt))))
        let tomorrow = (outputFormatterDD.string(from: Date(timeIntervalSince1970: Double(onecall.daily[1].dt))))
        self.todayLabel.text = "\(today)"
        weatherLabel.text = "\(detail[0].mainjp)"
        maxTempLabel.text = "\(Int(round(onecall.daily[0].temp.max)))℃"
        minTempLabel.text = "\(Int(round(onecall.daily[0].temp.min)))℃"
        todayImageView.image = UIImage(named: "\(onecall.daily[0].weather[0].icon)")
        tomorrowLabel.text = "\(tomorrow)"
        tomorrowWeatherLabel.text = "\(detail[1].mainjp)"
        tomorrowMaxTempLabel.text = "\(Int(round(onecall.daily[1].temp.max)))℃"
        tomorrowMinTempLabel.text = "\(Int(round(onecall.daily[1].temp.min)))℃"
        tomorrowImageView.image = UIImage(named: "\(onecall.daily[1].weather[0].icon)")
    }
}
