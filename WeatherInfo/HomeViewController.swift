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
class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var address = "地名"
    var onecall:OneCallData?
    var place:CLLocation?
    let userDefaults = UserDefaults.standard
    var callNumber = 0
    var upper = 0
    var unixtime = 0
    
    
    
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
    
    var latitude: String?
    var longitude: String?
    
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
        callNumber += 1
        print("呼び出し：\(callNumber)")
        location()
    }
    
    func location(){
        if let _ = UserDefaults.standard.object(forKey: "latest") as? String {
            self.address = userDefaults.object(forKey: "latest") as! String
            self.cityLabel.text = address
            CLGeocoder().geocodeAddressString(self.address) { placemarks, error in
                if let lat = placemarks?.first?.location?.coordinate.latitude {
                    self.latitude = "\(lat)"
                    
                }
                if let lon = placemarks?.first?.location?.coordinate.longitude {
                    self.longitude = "\(lon)"
                    
                }
                
                if self.latitude != nil && self.longitude != nil {
                    let visit = UserDefaults.standard.bool(forKey: "visit")
                    if visit {
                        //二回目以降のアクセスかつデータ更新前アクセス
                        print("二回目以降データ更新前アクセス")
                        self.upper = self.userDefaults.object(forKey: "upper") as! Int
                        self.unixtime = Int(Date().timeIntervalSince1970)
                        print(self.upper)
                        print(self.unixtime)
                        let prelat =  OneCallData(jsonResponse: self.getJSON("data")!).lat
                        let prelon = OneCallData(jsonResponse: self.getJSON("data")!).lon
                        let roundlat = round(Double(self.latitude!)!*100)/100
                        let roundlon = round(Double(self.longitude!)!*100)/100
                        
                        if self.unixtime < self.upper && "\(roundlat)" == "\(prelat)" && "\(roundlon)" == "\(prelon)"  {
                            self.onecall = OneCallData(jsonResponse: self.getJSON("data")!)
                            self.setLabel(onecall: self.onecall!)
                            self.collectionView.reloadData()
                            self.tableView.reloadData()
                            
                            self.contentView.frame.size.height += self.tableView.frame.size.height + self.adView.frame.size.height + 8
                            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.contentView.frame.size.height)
                            
                            //データ更新後アクセス
                        } else {
                            print("データ更新後アクセス：通信あり")
                            AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(self.latitude!)&lon=\(self.longitude!)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee").responseJSON{
                                response in
                                switch response.result{
                                case .success(let value):
                                    print("データ更新成功")
                                    self.onecall = OneCallData(jsonResponse: JSON(value))
                                    self.setLabel(onecall: self.onecall!)
                                    self.collectionView.reloadData()
                                    self.tableView.reloadData()
                                    
                                    self.contentView.frame.size.height += self.tableView.frame.size.height + self.adView.frame.size.height + 8
                                    self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.contentView.frame.size.height)
                                    //JSON型のデータを保存
                                    self.saveJSON(json: JSON(value), key: "data")
                                    //通信した時間の1時間後をunixで保存
                                    self.userDefaults.set(self.onecall!.hourly[1].jsondt, forKey: "upper")
                                    
                                case .failure(let value):
                                    print("通信失敗")
                                    debugPrint(value)
                                }
                            }
                            UserDefaults.standard.set(true, forKey: "visit")
                        }
                        
                        
                    } else {
                        //初回アクセス
                        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(self.latitude!)&lon=\(self.longitude!)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee").responseJSON{
                            response in
                            switch response.result{
                            case .success(let value):
                                print("初回通信成功")
                                self.onecall = OneCallData(jsonResponse: JSON(value))
                                self.setLabel(onecall: self.onecall!)
                                self.collectionView.reloadData()
                                self.tableView.reloadData()
                                
                                self.contentView.frame.size.height += self.tableView.frame.size.height + self.adView.frame.size.height + 8
                                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.contentView.frame.size.height)
                                //JSON型のデータを保存
                                self.saveJSON(json: JSON(value), key: "data")
                                //通信した時間の1時間後をunixで保存
                                self.userDefaults.set(self.onecall!.hourly[1].jsondt, forKey: "upper")
                                self.userDefaults.set(self.address, forKey: "previous")
                                
                                
                            case .failure(let value):
                                print("通信失敗")
                                debugPrint(value)
                            }
                        }
                        UserDefaults.standard.set(true, forKey: "visit")
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
        self.weatherLabel.text = "\(self.onecall!.daily[0].mainjp)"
        self.maxTemp.text = "\(self.onecall!.daily[0].maxtempRound)℃"
        self.minTemp.text = "\(self.onecall!.daily[0].mintempRound)℃"
        self.imageView.image = UIImage(named: "\(self.onecall!.daily[0].icon)")
        self.tmrdayLabel.text = "\(self.onecall!.daily[1].daydt)"
        self.tmrweatherLabel.text = "\(self.onecall!.daily[1].mainjp)"
        self.tmrmaxTemp.text = "\(self.onecall!.daily[1].maxtempRound)℃"
        self.tmrminTemp.text = "\(self.onecall!.daily[1].mintempRound)℃"
        self.tmrimageView.image = UIImage(named: "\(self.onecall!.daily[1].icon)")
        self.laundryIndex.image = UIImage(named: "index\(self.onecall!.daily[0].laundryIndex)")
        self.humidLabel.text = "\(self.onecall!.hourly[0].humidity)%"
        self.popLabel.text = "\(self.onecall!.hourly[0].pop)%"
        self.wingspdLabel.text = "\(round(self.onecall!.hourly[0].windspd))m"
        self.laundryIndxdesc.text = self.onecall!.daily[0].laundryIndexdesc
        
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
    
    func saveJSON(json: JSON, key:String)  {
        if let jsonString = json.rawString(){
            UserDefaults.standard.setValue(jsonString, forKey: key)
        }
    }
    
    func getJSON(_ key: String)->JSON?{
        var p = ""
        if let result = UserDefaults.standard.string(forKey: key){
            p = result
        }
        if p != "" {
            if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    return try JSON(data: json)
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    
}


