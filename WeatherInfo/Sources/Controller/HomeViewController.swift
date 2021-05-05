import UIKit
import CoreLocation
import PKHUD
import Kanna
import Combine
import Alamofire
import Network

class HomeViewController: UIViewController {
    //Viewの参照を保持
    @IBOutlet var homeView: HomeView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var middle: UIView!
    //Modelの参照を保持
    var weatherModel = WeatherModel()
    let userModel = UserModel()
    let decorder = JSONDecoder()
    var requestCancellable: Cancellable?
    var errorCancellable : Cancellable?

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
        netWorkCheck()
    }
}

extension HomeViewController {
    func start() {
        if let address = userModel.loadAddress() {
            CLGeocoder().geocodeAddressString(address) { [self] placemarks, error in
                guard let lat = placemarks?.first?.location?.coordinate.latitude else { return }
                guard let lon = placemarks?.first?.location?.coordinate.longitude else { return }
                if userModel.loadVisitInfo() {
                    //再訪問
                    let upper = userModel.loadTime()
                    let unixtime = Int(Date().timeIntervalSince1970)
                    weatherModel.onecall = weatherModel.loadOnecall()![0]
                    //過去の位置情報と現在の位置情報を比較
                    if unixtime < upper && floor(weatherModel.onecall!.lat*100) == floor(lat*100) && floor(weatherModel.onecall!.lon*100) == floor(lon*100) {
                        //通信なし
                        homeView.onecall = weatherModel.onecall
                        //Viewの描画
                        homeView.setView(address: address, detail: weatherModel.loadDetail()!)
                        let xibHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: 375, height: 177))
                        xibHeaderView.set(onecall: weatherModel.onecall!, detail: weatherModel.loadDetail()!)
                        header.addSubview(xibHeaderView)
                        let xibMiddleView = MiddleView(frame: CGRect(x: 0, y: 0, width: 375, height: 129))
                        xibMiddleView.set(onecall: weatherModel.onecall!, detail: weatherModel.loadDetail()!)
                        middle.addSubview(xibMiddleView)
                    } else {
                        //通信あり
                        HUD.show(.progress)
                        weatherModel.request(latitude: lat, longitude: lon)
                        print("C:\(weatherModel.error)")
                        requestCancellable = weatherModel.$error
                            .sink(receiveValue: {error in
//                                if true {
//                                    print("error")
//                                    communicationError()
//                                }
                            })
                        requestCancellable = weatherModel.$detail
                            .sink(receiveValue: { detail in 
                                if !detail.isEmpty {
                                    DispatchQueue.main.async {
                                        homeView.onecall = weatherModel.onecall
                                        //Viewを描画
                                        homeView.setView(address: address, detail: detail)
                                        let xibHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: 375, height: 177))
                                        xibHeaderView.set(onecall: weatherModel.onecall!, detail: detail)
                                        header.addSubview(xibHeaderView)
                                        let xibMiddleView = MiddleView(frame: CGRect(x: 0, y: 0, width: 375, height: 129))
                                        xibMiddleView.set(onecall: weatherModel.onecall!, detail: weatherModel.detail)
                                        middle.addSubview(xibMiddleView)
                                        //保存
                                        userModel.saveTime(dt: weatherModel.onecall!.hourly[1].dt)
                                        weatherModel.saveDetail(detail: detail)
                                        HUD.hide()
                                    }
                                }
                            })
                    }
                } else {
                    //初回訪問
                    weatherModel.request(latitude: lat, longitude: lon)
                    errorCancellable = weatherModel.$error
                        .sink(receiveValue: {error in
                            if error {
                                //通信エラー処理
                                communicationError()
                            }
                        })
                    HUD.show(.progress)
                    requestCancellable = weatherModel.$detail
                        .sink(receiveValue: { detail in
                            if !detail.isEmpty {
                                DispatchQueue.main.async {
                                    homeView.onecall = weatherModel.onecall
                                    //Viewを描画
                                    homeView.setView(address: address, detail: detail)
                                    let xibHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: 375, height: 177))
                                    xibHeaderView.set(onecall: weatherModel.onecall!, detail: detail)
                                    header.addSubview(xibHeaderView)
                                    let xibMiddleView = MiddleView(frame: CGRect(x: 0, y: 0, width: 375, height: 129))
                                    xibMiddleView.set(onecall: weatherModel.onecall!, detail: weatherModel.detail)
                                    middle.addSubview(xibMiddleView)
                                    //保存
                                    userModel.saveTime(dt: weatherModel.onecall!.hourly[1].dt)
                                    userModel.saveVisitInfo(bool: true)
                                    weatherModel.saveDetail(detail: detail)
                                    HUD.hide()
                                }
                            }
                        })
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
            self.weatherModel.resetOnecall()
            self.weatherModel.resetDetail()
        }
        return
    }

    func netWorkCheck() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                //通信環境あり
                self.homeView.netWorkSuccess()
                self.start()
            } else {
                //通信環境なし
                self.homeView.netWorkError()
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
