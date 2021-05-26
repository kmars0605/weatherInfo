import UIKit
import CoreLocation
import PKHUD
import Kanna
import Combine
import Alamofire
import Network

class HomeViewController: UIViewController {
    //Viewの参照を保持
    @IBOutlet private var homeView: HomeView!
    //Modelの参照を保持
    private var weatherModel = WeatherModel()
    private let userModel = UserModel()
    private var requestCancellable: Cancellable?
    private var errorCancellable : Cancellable?
    private let monitor = NWPathMonitor()
    deinit {
        requestCancellable?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        if let address = userModel.loadAddress() {
            CLGeocoder().geocodeAddressString(address) { [self] placemarks, error in
                guard let lat = placemarks?.first?.location?.coordinate.latitude else {
                    communicationError()
                    return
                }
                guard let lon = placemarks?.first?.location?.coordinate.longitude else {
                    communicationError()
                    return
                }
                //再訪問
                let upper = userModel.loadTime() ?? 0
                let unixtime = Int(Date().timeIntervalSince1970)
                weatherModel.loadData(of: WeatherModel.Key.onecall)
                //過去の位置情報と現在の位置情報を比較
                if unixtime < upper && floor((weatherModel.onecall?.lat ?? 0)*100) == floor(lat*100) && floor((weatherModel.onecall?.lon ?? 0)*100) == floor(lon*100) {
                    //通信なし
                    weatherModel.loadData(of: WeatherModel.Key.detail)
                    homeView.weatherModel = weatherModel
                    //Viewを描画
                    homeView.setView(address: address)
                } else {
                    //通信あり
                    HUD.show(.progress)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    weatherModel.request(latitude: lat, longitude: lon)
                    errorCancellable = weatherModel.$error
                        .sink(receiveValue: {error in
                            if error {
                                communicationError()
                            }
                        })
                    requestCancellable = weatherModel.$detail
                        .sink(receiveValue: { detail in
                            if !detail.isEmpty {
                                DispatchQueue.main.async {
                                    homeView.weatherModel = weatherModel
                                    //Viewを描画
                                    homeView.setView(address: address)
                                    //保存
                                    userModel.saveTime(dt: weatherModel.onecall!.hourly[1].dt)
                                    weatherModel.saveData(of: detail, to: WeatherModel.Key.detail)
                                    HUD.hide()
                                }
                            }
                        })
                    }
                }
            }
        } else {
            print("位置情報なし")
        }
    }

    func communicationError() {
        homeView.communicationError()
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.2){
            let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPlace")
            self.present(settingPlaceViewController!, animated: true, completion: nil)
            let UINavigationController = self.tabBarController?.viewControllers?[0]
            self.tabBarController?.selectedViewController = UINavigationController
            self.userModel.resetUserInfo()
            self.weatherModel.resetData(of: WeatherModel.Key.onecall)
            self.weatherModel.resetData(of: WeatherModel.Key.detail)
            self.weatherModel.error = false
        }
        return
    }
}
