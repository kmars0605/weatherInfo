import UIKit
import CoreLocation
import PKHUD
import Kanna
import Combine
import Alamofire

class HomeViewController: UIViewController {
    //Viewの参照を保持
    @IBOutlet var homeView: HomeView!
    //Modelの参照を保持
    var weatherModel = WeatherModel()
    let decorder = JSONDecoder()
    var requestCancellable: Cancellable?

    deinit {
        requestCancellable?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for item in (self.tabBarController?.tabBar.items)! {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        }
        let nib = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
        homeView.collectionView.register(nib, forCellWithReuseIdentifier: "Cell")

        let nib2 = UINib(nibName: "DailyTableViewCell", bundle: nil)
        homeView.tableView.register(nib2, forCellReuseIdentifier: "TableCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        start()
    }
}

extension HomeViewController {
    func start() {
        if let address = UserDefaults.standard.object(forKey: "latest") as? String {
            CLGeocoder().geocodeAddressString(address) { [self] placemarks, error in
                guard let lat = placemarks?.first?.location?.coordinate.latitude else { return }
                guard let lon = placemarks?.first?.location?.coordinate.longitude else { return }
                if UserDefaults.standard.bool(forKey: "reVisit") {
                    //再訪問
                    let upper = UserDefaults.standard.object(forKey: "upper") as! Int
                    let unixtime = Int(Date().timeIntervalSince1970)
                    weatherModel.onecall = weatherModel.readOnecall()![0]
                    //過去の位置情報と現在の位置情報を比較
                    if unixtime < upper && floor(weatherModel.onecall!.lat*100) == floor(lat*100) && floor(weatherModel.onecall!.lon*100) == floor(lon*100) {
                        //通信なし
                        homeView.onecall = weatherModel.onecall
                        homeView.setView(address: address, detail: weatherModel.readDetail()!)
                    } else {
                        //通信あり
                        weatherModel.request(latitude: lat, longitude: lon)
                        HUD.show(.progress)
                        homeView.onecall = weatherModel.onecall
                        requestCancellable = weatherModel.$detail
                            .sink(receiveValue: { detail in 
                                if !detail.isEmpty {
                                    DispatchQueue.main.async {
                                        homeView.onecall = weatherModel.onecall
                                        homeView.setView(address: address, detail: detail)
                                        weatherModel.saveDetail(detail: detail)
                                    }
                                }
                            })
                        HUD.hide()
                    }
                } else {
                    //初回訪問
                    weatherModel.request(latitude: lat, longitude: lon)
                    HUD.show(.progress)
                    homeView.onecall = weatherModel.onecall
                    requestCancellable = weatherModel.$detail
                        .sink(receiveValue: { detail in
                            if !detail.isEmpty {
                                DispatchQueue.main.async {
                                    homeView.onecall = weatherModel.onecall
                                    homeView.setView(address: address, detail: detail)
                                    weatherModel.saveDetail(detail: detail)
                                }
                            }
                        })
                    HUD.hide()
                }
            }
        } else {
            print("位置情報なし")
        }
    }

    func errorProcess() {
        if weatherModel.detail.isEmpty {
            homeView.errorProcess()
            DispatchQueue.main.asyncAfter(deadline:.now() + 1.2){
                let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPlace")
                self.present(settingPlaceViewController!, animated: true, completion: nil)
                let UINavigationController = self.tabBarController?.viewControllers?[0]
                self.tabBarController?.selectedViewController = UINavigationController}
            return
        }
    }
}
