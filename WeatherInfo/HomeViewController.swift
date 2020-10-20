//
//  HomeViewController.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/09.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

/// Location の View
class HomeViewController: UIViewController,CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource  {
    var address = "地名"
    var onecall:OneCallData?
    var place:CLLocation?
    let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var laundryIndex: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var adView: UIView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tmrimageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    //ロケーションマネージャ
    var locationManager: CLLocationManager!
    var latitude: String?
    var longitude: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let nib = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        let nib2 = UINib(nibName: "DailyTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "TableCell")
        // ロケーションマネージャのセットアップ
        setupLocationManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        location()
    }
    //ロケーションマネージャのセットアップ
    func setupLocationManager() {
        locationManager = CLLocationManager()
        
        // 権限をリクエスト
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        
        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    //アラートを表示する
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        //OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        // UIAlertController に Action を追加
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    
    func location(){
        if let _ = UserDefaults.standard.object(forKey: "LATEST") as? String {
            self.address = userDefaults.object(forKey: "LATEST") as! String
            self.cityLabel.text = address
            
            CLGeocoder().geocodeAddressString(self.address) { placemarks, error in
                if let lat = placemarks?.first?.location?.coordinate.latitude {
                    self.latitude = "\(lat)"
                    
                }
                if let lon = placemarks?.first?.location?.coordinate.longitude {
                    self.longitude = "\(lon)"
                    
                }
                if self.latitude != nil && self.longitude != nil {
                AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(self.latitude!)&lon=\(self.longitude!)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee").responseJSON{
                    response in
                    switch response.result{
                    case .success(let value):
                        print("通信成功")
                        self.onecall = OneCallData(jsonResponse: JSON(value))
                        self.setLabel(onecall: self.onecall!)
                        self.collectionView.reloadData()
                        self.tableView.reloadData()
                        
                        self.contentView.frame.size.height += self.tableView.frame.size.height + self.adView.frame.size.height + 8
                        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.contentView.frame.size.height)
                        
                    case .failure(let value):
                        print("通信失敗")
                        debugPrint(value)
                    }
                }
                }
            }
            
        }
    }
    
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
    
    func setLabel(onecall: OneCallData){
        self.dayLabel.text = "\(self.onecall!.daily[0].daydt)"
        self.weatherLabel.text = "\(self.onecall!.daily[0].main)"
        self.maxTemp.textColor = UIColor.red
        self.maxTemp.text = "\(self.onecall!.daily[0].maxtempRound)℃"
        self.minTemp.textColor = UIColor.blue
        self.minTemp.text = "\(self.onecall!.daily[0].mintempRound)℃"
        /*if let weatherIcon = URL(string: "https://openweathermap.org/img/wn/\(self.onecall!.icon).png"),
            let data = try? Data(contentsOf: weatherIcon),
            let image = UIImage(data: data) {
            self.imageView.image = image
        }*/
        self.imageView.image = UIImage(named: "\(self.onecall!.daily[0].icon)")
        print(self.onecall!.daily[0].icon)
        self.tmrdayLabel.text = "\(self.onecall!.daily[1].daydt)"
        self.tmrweatherLabel.text = "\(self.onecall!.daily[1].main)"
        self.tmrmaxTemp.textColor = UIColor.red
        self.tmrmaxTemp.text = "\(self.onecall!.daily[1].maxtempRound)℃"
        self.tmrminTemp.textColor = UIColor.blue
        self.tmrminTemp.text = "\(self.onecall!.daily[1].mintempRound)℃"
       
        /*if let weatherIcon = URL(string: "https://openweathermap.org/img/wn/\(self.onecall!.daily[1].icon).png"),
            let data = try? Data(contentsOf: weatherIcon),
            let image = UIImage(data: data) {
            self.tmrimageView.image = image
        }*/
        self.tmrimageView.image = UIImage(named: "\(self.onecall!.daily[1].icon)")
        self.laundryIndex.image = UIImage(named: "index\(self.onecall!.daily[1].laundryIndex)")
        
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
        cell.setDailyData(onecall!.daily[indexPath.row])
        tableView.isScrollEnabled = false
        return cell
    }
}


