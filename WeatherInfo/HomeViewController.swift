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
class HomeViewController: UIViewController,CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate  {
    var address = "地名"
    var onecall:OneCallData?
    var place:CLLocation?
    let userDefaults = UserDefaults.standard
    var latestPlace:String?
    var number = 1
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //日付を表示するラベル
    @IBOutlet weak var dayLabel: UILabel!
    // 緯度を表示するラベル
    @IBOutlet weak var latitude: UILabel!
    // 経度を表示するラベル
    @IBOutlet weak var longitude: UILabel!
    //時刻を表示するラベル
    @IBOutlet weak var timeLabel: UILabel!
    //天気を表示するラベル
    @IBOutlet weak var weatherLabel: UILabel!
    //都市名を表示するラベル
    @IBOutlet weak var cityLabel: UILabel!
    //温度を表示するラベル
    @IBOutlet weak var tempLabel: UILabel!
    //湿度を表示するラベル
    @IBOutlet weak var humidLabel: UILabel!
    // 緯度
    var latitudeNow: String = ""
    // 経度
    var longitudeNow: String = ""
    
    //ロケーションマネージャ
    var locationManager: CLLocationManager!
    var lat: String = "0"
    var lon: String = "0"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        //保存された場所をセット
        //self.latestPlace = userDefaults.string(forKey: "LATEST")!
        //self.cityLabel.text = latestPlace
        // ロケーションマネージャのセットアップ
        setupLocationManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        location()
    }
    
    //"位置情報を取得"ボタンを押下した際、位置情報をラベルに反映する
    //- Parameter sender: "位置情報を取得"ボタン
    @IBAction func getLocationInfo(_ sender: Any) {
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            self.latitude.text = latitudeNow
            self.longitude.text = longitudeNow
            
            print(latitudeNow)
        }
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
    
    // 位置情報が更新された際、位置情報を格納する
    //- Parameters:
    // - manager: ロケーションマネージャ
    // - locations: 位置情報
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     let location = locations.first
     let latitude = location?.coordinate.latitude
     let longitude = location?.coordinate.longitude
     
     print("!!!!!!")
     print(location)
     
     let place = CLLocation(latitude: latitude!, longitude: longitude!)
     CLGeocoder().reverseGeocodeLocation(place) { placemarks, error in
     guard let placemark = placemarks?.first, error == nil else { return }
     self.cityLabel.text = placemark.subLocality
     }
     // 位置情報を格納する
     //latitudeはオプショナルInt型だけど、Stirng()によってSting型へキャストされている
     self.latitudeNow = String(latitude!)
     self.longitudeNow = String(longitude!)
     
     self.lat = latitudeNow
     self.lon = longitudeNow
     
     userDefaults.set(self.cityLabel.text, forKey:"LATEST")
     userDefaults.synchronize()
     
     AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&lang=ja&APPID=12de4b711b7224a6556ea9e11f9a03ee").responseJSON{
     response in
     switch response.result{
     case .success(let value):
     self.onecall = OneCallData(jsonResponse: JSON(value))
     self.setLabel(onecall: self.onecall!)
     print("aaa")
     print(self.onecall)
     case .failure(let value):
     debugPrint(value)
     }
     }
     }*/
    
    func location(){
        if let _ = UserDefaults.standard.object(forKey: "LATEST") as? String {
            address = userDefaults.object(forKey: "LATEST") as! String
            self.cityLabel.text = address
            print("h:\(address)")
            
        }
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let lat = placemarks?.first?.location?.coordinate.latitude {
                self.lat = "\(lat)"
                print("h緯度 : \(self.lat)")
                self.latitude.text = "\(lat)"
                self.number = 2
            }
            if let lon = placemarks?.first?.location?.coordinate.longitude {
                self.lon = "\(lon)"
                print("h経度 : \(lon)")
                self.longitude.text = "\(lon)"
            }
        }
        print("???")
        print(self.lat)
        print(number)
        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(self.lat)&lon=\(self.lon)&units=metric&lang=ja&APPID=12de4b711b7224a6556ea9e11f9a03ee").responseJSON{
            response in
            switch response.result{
            case .success(let value):
                self.onecall = OneCallData(jsonResponse: JSON(value))
                print("onecall")
                print(self.onecall?.lat)
                self.setLabel(onecall: self.onecall!)
            case .failure(let value):
                debugPrint(value)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HourlyCollectionViewCell
        // cell.setHourlyData(hourlyArray[indexPath.item])
        //cell.setHourlyData(onecall!.hourly[indexPath.item])
        
        return cell
    }
    
    func setLabel(onecall: OneCallData){
        //self.dayLabel.text = ""
        self.latitude.text = "\(self.onecall!.lat)"
        print("one:\(self.onecall!.lat)")
        self.longitude.text = "\(self.onecall!.lon)"
        //self.timeLabel.text = "\()"
        self.weatherLabel.text = "\(self.onecall!.main)"
        self.tempLabel.text = "\(self.onecall!.temp)"
        self.humidLabel.text = "\(self.onecall!.humidity)"
    }
}

