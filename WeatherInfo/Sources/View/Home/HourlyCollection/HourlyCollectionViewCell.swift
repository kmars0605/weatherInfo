
import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    //時間を表示するラベル
    @IBOutlet weak var timeLabel: UILabel!
    //気温を表示するラベル
    @IBOutlet weak var tempLabel: UILabel!
    //湿度を表示するラベル
    @IBOutlet weak var humidLabel: UILabel!
    //天気画像を表示するビュー
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setHourlyData(_ hourly:Hourly){
        //時間の表示
        let outputFormatterHH = DateFormatter()
        outputFormatterHH.dateFormat = "HH時"
        let time = (outputFormatterHH.string(from: Date(timeIntervalSince1970: Double(hourly.dt))))
        self.timeLabel.text = "\(time)"
        //気温の表示
        self.tempLabel.text = "\(Int(round(hourly.temp)))℃"
        //湿度の表示
        self.humidLabel.text = "\(hourly.humidity)%"
        //画像を表示
        self.imageView.image = UIImage(named: "\(hourly.weather[0].icon)")
    }
}

