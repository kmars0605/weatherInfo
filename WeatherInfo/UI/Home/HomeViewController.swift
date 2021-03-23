import UIKit
import CoreLocation
import Combine
import Alamofire
import PKHUD
import Kanna

class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var popLabel: UILabel!
    @IBOutlet weak var wingspdLabel: UILabel!
    @IBOutlet weak var laundryIndex: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tmrimageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var laundryIndxdesc: UILabel!
    //日付を表示するラベル
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tmrdayLabel: UILabel!
    //天気を表示するラベル
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tmrweatherLabel: UILabel!
    //都市名を表示するラベル
    @IBOutlet weak var cityLabel: UILabel!
    //最高気温を表示するラベル
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var tmrmaxTemp: UILabel!
    //最低気温を表示するラベル
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var tmrminTemp: UILabel!

    var onecall: OneCall?
    var requestCancellable: Cancellable?
    let userDefaults = UserDefaults.standard
    let decorder = JSONDecoder()

    deinit {
        requestCancellable?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for item in (self.tabBarController?.tabBar.items)! {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")

        let nib2 = UINib(nibName: "DailyTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "TableCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        start()
    }
}

extension HomeViewController {
    func start() {
        let reVisit = userDefaults.bool(forKey: "reVisit")
        if let address = userDefaults.object(forKey: "latest") as? String {
            CLGeocoder().geocodeAddressString(address) { [self] placemarks, error in
                guard let lat = placemarks?.first?.location?.coordinate.latitude else { return }
                guard let lon = placemarks?.first?.location?.coordinate.longitude else { return }
                if reVisit {
                    //再訪問
                    let upper = self.userDefaults.object(forKey: "upper") as! Int
                    let unixtime = Int(Date().timeIntervalSince1970)
                    let detail = readDetail()
                    self.onecall = readOnecall()![0]
                    //過去の位置情報と現在の位置情報を比較
                    if unixtime < upper && floor(onecall!.lat*100) == floor(lat*100) && floor(onecall!.lon*100) == floor(lon*100) {
                        //通信なし
                        self.setLabel(address: address, onecall: self.onecall!, detail: detail!)
                    } else {
                        //データ更新後アクセス
                        request(latitude: lat, longitude: lon, address: address)
                    }
                } else {
                    //初回アクセス
                    request(latitude: lat, longitude: lon, address: address)
                }
            }
        } else {
            print("エラー：位置情報なし")
        }
    }
    //URLSessionでの実装
    func request(latitude: Double, longitude: Double, address: String) {
        var detail: [DailyWeatherDetail] = []
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
                case .failure(let error):
                    print("エラー:\(error)")
                    HUD.flash(.labeledError(title: "通信に失敗しました。", subtitle: nil))
                }
            }, receiveValue: { [self] onecall in
                self.onecall = onecall
                for i in onecall.daily {
                    detail.append(DailyWeatherDetail(daily: i))
                }
                DispatchQueue.main.async {
                    self.setLabel(address: address, onecall: self.onecall!, detail: detail)
                    HUD.hide()
                }
                //OneCallのデータを保存
                saveOnecall(items: [onecall])
                saveDetail(items: detail)
                detail.removeAll()
                //通信した時間の1時間後をunixで保存
                self.userDefaults.set(self.onecall!.hourly[1].dt, forKey: "upper")
            })
        userDefaults.set(true, forKey: "reVisit")
    }
    //Alamofireでの実装
    func requestAF(latitude: Double, longitude: Double, address: String) {
        var detail: [DailyWeatherDetail] = []
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee"
        HUD.show(.progress)
        requestCancellable = AF.request(url).publishDecodable(type: OneCall.self, decoder: decorder)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("通信成功")
                case .failure(let error):
                    print("エラー:\(error)")
                    HUD.flash(.labeledError(title: "通信に失敗しました。", subtitle: nil))
                }
            }, receiveValue: { [self] onecall in
                self.onecall = onecall
                for i in onecall.daily {
                    detail.append(DailyWeatherDetail(daily: i))
                }
                self.setLabel(address: address, onecall: self.onecall!, detail: detail)
                HUD.hide()
                //OneCallのデータを保存
                saveOnecall(items: [onecall])
                saveDetail(items: detail)
                detail.removeAll()
                //通信した時間の1時間後をunixで保存
                self.userDefaults.set(self.onecall!.hourly[1].dt, forKey: "upper")
            })
        userDefaults.set(true, forKey: "reVisit")
    }
}

extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.onecall == nil{
            return 0
        }else {
            return onecall!.hourly.count/2
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HourlyCollectionViewCell
        //cell.setHourlyData(hourlyArray[indexPath.item])
        cell.setHourlyData(onecall!.hourly[indexPath.item])

        return cell
    }

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

extension HomeViewController {
    func setLabel(address: String,onecall: OneCall,detail: [DailyWeatherDetail]){
        let outputFormatterDD = DateFormatter()
        outputFormatterDD.locale = Locale(identifier: "ja_JP")
        outputFormatterDD.dateFormat = "d日(EEE)"
        let today = (outputFormatterDD.string(from: Date(timeIntervalSince1970: Double(self.onecall!.daily[0].dt))))
        let tomorrow = (outputFormatterDD.string(from: Date(timeIntervalSince1970: Double(self.onecall!.daily[1].dt))))
        self.dayLabel.text = "\(today)"
        self.cityLabel.text = address
        self.weatherLabel.text = "\(detail[0].mainjp)"
        self.maxTemp.text = "\(Int(round(self.onecall!.daily[0].temp.max)))℃"
        self.minTemp.text = "\(Int(round(self.onecall!.daily[0].temp.min)))℃"
        self.imageView.image = UIImage(named: "\(self.onecall!.daily[0].weather[0].icon)")
        self.tmrdayLabel.text = "\(tomorrow)"
        self.tmrweatherLabel.text = "\(detail[1].mainjp)"
        self.tmrmaxTemp.text = "\(Int(round(self.onecall!.daily[1].temp.max)))℃"
        self.tmrminTemp.text = "\(Int(round(self.onecall!.daily[1].temp.min)))℃"
        self.tmrimageView.image = UIImage(named: "\(self.onecall!.daily[1].weather[0].icon)")
        self.laundryIndex.image = UIImage(named: "index\(detail[0].laundryIndex)")
        self.humidLabel.text = "\(self.onecall!.hourly[0].humidity)%"
        self.popLabel.text = "\(self.onecall!.hourly[0].pop)%"
        self.wingspdLabel.text = "\(round(self.onecall!.hourly[0].windSpeed))m"
        self.laundryIndxdesc.text = "\(detail[0].laundryIndexdesc)"
        self.collectionView.reloadData()
        self.tableView.reloadData()
        self.contentView.frame.size.height += self.tableView.frame.size.height + self.adView.frame.size.height + 8
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.contentView.frame.size.height)
    }
}

extension HomeViewController {
    func saveOnecall(items: [OneCall]) {
        let data = items.map { try! JSONEncoder().encode($0) }
        userDefaults.set(data as [Any], forKey: "oneCall")
    }

    func readOnecall() -> [OneCall]? {
        guard let items = userDefaults.array(forKey: "oneCall") as? [Data] else { return [OneCall]() }
        let decodedItems = items.map { try! JSONDecoder().decode(OneCall.self, from: $0) }
        return decodedItems
    }

    func saveDetail(items: [DailyWeatherDetail]) {
        let data = items.map { try! JSONEncoder().encode($0) }
        userDefaults.set(data as [Any], forKey: "detail")
    }

    func readDetail() -> [DailyWeatherDetail]? {
        guard let items = userDefaults.array(forKey: "detail") as? [Data] else { return [DailyWeatherDetail]() }
        let decodedItems = items.map { try! JSONDecoder().decode(DailyWeatherDetail.self, from: $0) }
        return decodedItems
    }
}
