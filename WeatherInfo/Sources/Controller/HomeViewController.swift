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
                        request(latitude: lat, longitude: lon, address: address)
                    }
                } else {
                    //初回訪問
                    request(latitude: lat, longitude: lon, address: address)
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

extension HomeViewController {
    //URLSessionでの実装
    func request(latitude: Double, longitude: Double, address: String) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee")!
        HUD.show(.progress)
        requestCancellable = URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .map({(data, res) in
                return data
            })
            .decode(type: OneCall.self, decoder: decorder)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("通信成功")
                    break
                case .failure:
                    print("通信失敗")
                    HUD.hide()
                    HUD.show(.labeledError(title: L10n.SearchErrorView.Title.text, subtitle: nil))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { HUD.hide() }
                }
            }, receiveValue: { [self] onecall in
                weatherModel.onecall = onecall
                weatherModel.detail = onecall.daily.map{DailyWeatherDetail(daily: $0)}
                homeView.onecall = onecall
                DispatchQueue.main.async {
                    homeView.setView(address: address, detail: weatherModel.detail)
                    HUD.hide()
                }
                weatherModel.saveDetail(items: weatherModel.detail)
                //OneCallのデータを保存
                weatherModel.saveOnecall(items: [onecall])
                //通信した時間の1時間後をunixで保存
                UserDefaults.standard.set(weatherModel.onecall!.hourly[1].dt, forKey: "upper")
                weatherModel.detail.removeAll()
            })
        UserDefaults.standard.set(true, forKey: "reVisit")
    }
    //Alamofireでの実装
    func requestAF(latitude: Double, longitude: Double, address: String) {
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee"
        requestCancellable = AF.request(url).publishDecodable(type: OneCall.self, decoder: decorder)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    //通信成功
                    break
                case .failure:
                    //error
                    HUD.show(.labeledError(title: L10n.CommunicationErrorView.Title.text, subtitle: nil))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { HUD.hide() }
                }
            }, receiveValue: { [self] onecall in
                weatherModel.onecall = onecall
                weatherModel.detail = onecall.daily.map{DailyWeatherDetail(daily: $0)}
                homeView.onecall = onecall
                DispatchQueue.main.async {
                    homeView.setView(address: address, detail: weatherModel.detail)
                    HUD.hide()
                }
                weatherModel.saveDetail(items: weatherModel.detail)
                //OneCallのデータを保存
                weatherModel.saveOnecall(items: [onecall])
                //通信した時間の1時間後をunixで保存
                UserDefaults.standard.set(weatherModel.onecall!.hourly[1].dt, forKey: "upper")
                weatherModel.detail.removeAll()
            })
        UserDefaults.standard.set(true, forKey: "reVisit")
    }
}
