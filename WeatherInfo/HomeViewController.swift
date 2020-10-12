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
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    //日付を表示するラベル
    @IBOutlet weak var dayLabel: UILabel!
    //天気を表示するラベル
    @IBOutlet weak var weatherLabel: UILabel!
    //都市名を表示するラベル
    @IBOutlet weak var cityLabel: UILabel!
    //温度を表示するラベル
    @IBOutlet weak var tempLabel: UILabel!
    //湿度を表示するラベル
    @IBOutlet weak var humidLabel: UILabel!
    //ロケーションマネージャ
    var locationManager: CLLocationManager!
    var latitude: String = "0"
    var longitude: String = "0"
    
    
    
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
                
                AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(self.latitude)&lon=\(self.longitude)&units=metric&lang=ja&APPID=12de4b711b7224a6556ea9e11f9a03ee").responseJSON{
                    response in
                    switch response.result{
                    case .success(let value):
                        self.onecall = OneCallData(jsonResponse: JSON(value))
                        print(self.onecall)
                        self.setLabel(onecall: self.onecall!)
                        self.collectionView.reloadData()
                        self.tableView.reloadData()
                        
                        
                    case .failure(let value):
                        debugPrint(value)
                    }
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if self.onecall == nil{
           return 0
            
        }else {
            return onecall!.hourly.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HourlyCollectionViewCell
        //cell.setHourlyData(hourlyArray[indexPath.item])
        cell.setHourlyData(onecall!.hourly[indexPath.item])
        
        return cell
    }
    
    func setLabel(onecall: OneCallData){
        self.dayLabel.text = "\(self.onecall!.daydt)"
        self.weatherLabel.text = "\(self.onecall!.main)"
        self.tempLabel.text = "\(self.onecall!.temp)℃"
        self.humidLabel.text = "\(self.onecall!.humidity)%"
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
        return cell
    }
}

