import UIKit
import Foundation

class MiddleView: UIView {
    @IBOutlet weak var laundryIndexImageView: UIImageView!
    @IBOutlet weak var laundryIndexLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var popLabel: UILabel!
    @IBOutlet weak var wingSpeedLabel: UILabel!
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
        let view = Bundle.main.loadNibNamed("MiddleView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func set(onecall:OneCall,detail: [DailyWeatherDetail]) {
        laundryIndexImageView.image = UIImage(named: "index\(detail[0].laundryIndex)")
        laundryIndexLabel.text = "\(detail[0].laundryIndexdesc)"
        humidLabel.text = "\(onecall.hourly[0].humidity)%"
        popLabel.text = "\(onecall.hourly[0].pop)%"
        wingSpeedLabel.text = "\(round(onecall.hourly[0].windSpeed))m"
    }
}

