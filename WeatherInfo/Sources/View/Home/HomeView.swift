import Foundation
import UIKit
import NendAd
import PKHUD

class HomeView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var adView: NADView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!

    var onecall: OneCall?
    public func setView(address: String,detail: [DailyWeatherDetail]){
        collectionView.delegate  = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        cityLabel.text = address
        collectionView.reloadData()
        tableView.reloadData()
        contentView.frame.size.height += tableView.frame.size.height + adView.frame.size.height + 8
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentView.frame.size.height)
    }

    func errorProcess() {
        DispatchQueue.main.async {
            HUD.show(.labeledError(title: L10n.CommunicationErrorView.Title.text, subtitle: nil))
        }
        DispatchQueue.main.asyncAfter(deadline:.now() + 2.0){ HUD.hide() }
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
