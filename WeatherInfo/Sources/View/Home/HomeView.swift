import Foundation
import UIKit
import NendAd
import PKHUD
import SwiftUI

class HomeView: UIView {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var adView: NADView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var indexView: UIView!

    let view = ContentView()
    var weatherModel: WeatherModel!
    public func setView(address: String){
        collectionView.delegate  = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self

        cityLabel.text = address
        //Header
        let width = self.frame.width
        let xibHeaderView = HeaderView(frame: CGRect(x: 20, y: 0, width: width-10, height: 177))
        xibHeaderView.set(onecall: weatherModel.onecall!, detail: weatherModel.detail)
        headerView.addSubview(xibHeaderView)
        //Middle
        let xibMiddleView = MiddleView(frame: CGRect(x: 0, y: 0, width: 375, height: 129))
        xibMiddleView.set(onecall: weatherModel.onecall!, detail: weatherModel.detail)
        middleView.addSubview(xibMiddleView)
        indexView.addSubview(convertUIView(width: width))

        collectionView.reloadData()
        tableView.reloadData()
        contentView.frame.size.height += tableView.frame.size.height + adView.frame.size.height + 8
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentView.frame.size.height)
    }

    func communicationError() {
        DispatchQueue.main.async {
            HUD.show(.labeledError(title: L10n.CommunicationErrorView.Title.text, subtitle: nil))
        }
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.2){ HUD.hide() }
    }

    func netWorkError() {
        DispatchQueue.main.async {
            HUD.show(.labeledError(title: L10n.NetWorkErrorView.Title.text, subtitle: L10n.NetWorkErrorView.Message.text))
        }
    }

    func netWorkSuccess() {
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
}

extension HomeView {
    func convertUIView(width:CGFloat) -> UIView {
        let rect = CGRect(x: 0, y: 0, width: width, height: 40)
        let window = UIWindow(frame: rect)
        let hosting = UIHostingController(rootView: view)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        return hosting.view
    }
}

extension HomeView: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = weatherModel.onecall {
            return weatherModel.onecall!.hourly.count/2
        }else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HourlyCollectionViewCell
        cell.setHourlyData(weatherModel.onecall!.hourly[indexPath.item])
        return cell
    }
}

extension HomeView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = weatherModel.onecall {
            return weatherModel.onecall!.daily.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! DailyTableViewCell
        var detail: [DailyWeatherDetail] = []
        for i in weatherModel.onecall!.daily {
            detail.append(DailyWeatherDetail(daily: i))
        }
        cell.setDailyData(weatherModel.onecall!.daily[indexPath.row], detail[indexPath.row])
        tableView.isScrollEnabled = false
        return cell
    }
}
