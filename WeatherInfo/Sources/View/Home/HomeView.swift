import Foundation
import UIKit
import NendAd
import PKHUD

class HomeView: UIView {
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var popLabel: UILabel!
    @IBOutlet weak var wingSpeedLabel: UILabel!
    @IBOutlet weak var laundryIndexImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var adView: NADView!
    @IBOutlet weak var todayImageView: UIImageView!
    @IBOutlet weak var tomorrowImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var laundryIndexLabel: UILabel!
    //日付を表示するラベル
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var tomorrowLabel: UILabel!
    //天気を表示するラベル
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tomorrowWeatherLabel: UILabel!
    //都市名を表示するラベル
    @IBOutlet weak var cityLabel: UILabel!
    //最高気温を表示するラベル
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var tomorrowMaxTempLabel: UILabel!
    //最低気温を表示するラベル
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var tomorrowMinTempLabel: UILabel!

    var onecall: OneCall?

    public func setView(address: String,detail: [DailyWeatherDetail]){
        let outputFormatterDD = DateFormatter()
        outputFormatterDD.locale = Locale(identifier: "ja_JP")
        outputFormatterDD.dateFormat = "d日(EEE)"
        let today = (outputFormatterDD.string(from: Date(timeIntervalSince1970: Double(onecall!.daily[0].dt))))
        let tomorrow = (outputFormatterDD.string(from: Date(timeIntervalSince1970: Double(onecall!.daily[1].dt))))
        collectionView.delegate  = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        todayLabel.text = "\(today)"
        cityLabel.text = address
        weatherLabel.text = "\(detail[0].mainjp)"
        maxTempLabel.text = "\(Int(round(onecall!.daily[0].temp.max)))℃"
        minTempLabel.text = "\(Int(round(onecall!.daily[0].temp.min)))℃"
        todayImageView.image = UIImage(named: "\(onecall!.daily[0].weather[0].icon)")
        tomorrowLabel.text = "\(tomorrow)"
        tomorrowWeatherLabel.text = "\(detail[1].mainjp)"
        tomorrowMaxTempLabel.text = "\(Int(round(onecall!.daily[1].temp.max)))℃"
        tomorrowMinTempLabel.text = "\(Int(round(onecall!.daily[1].temp.min)))℃"
        tomorrowImageView.image = UIImage(named: "\(onecall!.daily[1].weather[0].icon)")
        laundryIndexImageView.image = UIImage(named: "index\(detail[0].laundryIndex)")
        humidLabel.text = "\(onecall!.hourly[0].humidity)%"
        popLabel.text = "\(onecall!.hourly[0].pop)%"
        wingSpeedLabel.text = "\(round(onecall!.hourly[0].windSpeed))m"
        laundryIndexLabel.text = "\(detail[0].laundryIndexdesc)"
        collectionView.reloadData()
        tableView.reloadData()
        contentView.frame.size.height += tableView.frame.size.height + adView.frame.size.height + 8
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentView.frame.size.height)
    }

    func errorProcess() {
        HUD.show(.labeledError(title: L10n.CommunicationErrorView.Title.text, subtitle: nil))
        DispatchQueue.main.asyncAfter(deadline:.now() + 2.0){ HUD.hide() }
        UserDefaults.standard.set(nil, forKey: "upper")
        UserDefaults.standard.set(nil, forKey: "reVisit")
        UserDefaults.standard.set(nil, forKey: "oneCall")
        UserDefaults.standard.set(nil, forKey: "detail")
    }
}

extension HomeView: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.onecall == nil{
            return 0
        }else {
            return onecall!.hourly.count/2
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HourlyCollectionViewCell
        cell.setHourlyData(onecall!.hourly[indexPath.item])
        return cell
    }
}

extension HomeView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.onecall == nil{
            return 0
        }else {
            return onecall!.daily.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! DailyTableViewCell
        var detail: [DailyWeatherDetail] = []
        for i in onecall!.daily {
            detail.append(DailyWeatherDetail(daily: i))
        }
        cell.setDailyData(onecall!.daily[indexPath.row], detail[indexPath.row])
        tableView.isScrollEnabled = false
        return cell
    }
}
