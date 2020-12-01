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
import Kanna


var a : [String] = []
var b : [String] = []
/// Location の View
class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var address = "地名"
    var onecall:OneCallData?
    var place:CLLocation?
    let userDefaults = UserDefaults.standard
    var callNumber = 0
    var upper = 0
    var unixtime = 0
    var official:OfficialData?
    var officialData:String?
    let visit = UserDefaults.standard.bool(forKey: "visit")
    let prefLang = Locale.preferredLanguages.first
    
    
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
        print("優先言語:\(prefLang)")
        isJapanese()
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
            print("県番号：\(userDefaults.object(forKey: "placeNumber"))")
            print("位置詳細番号：\(userDefaults.object(forKey: "localNumber"))")
            print("週間番号：\(userDefaults.object(forKey: "localWeekNumber"))")
            self.address = userDefaults.object(forKey: "latest") as! String
            self.cityLabel.text = userDefaults.object(forKey: "address") as? String
            CLGeocoder().geocodeAddressString(self.address) { [self] placemarks, error in
                if let lat = placemarks?.first?.location?.coordinate.latitude {
                    self.latitude = "\(lat)"
                    
                }
                if let lon = placemarks?.first?.location?.coordinate.longitude {
                    self.longitude = "\(lon)"
                    
                }
                
                if self.latitude != nil && self.longitude != nil {
                    
                    
                    
                    if visit {
                        //二回目以降のアクセスかつデータ更新前アクセス
                        print("二回目以降データ更新前アクセス")
                        

                        
                        self.upper = self.userDefaults.object(forKey: "upper") as! Int
                        self.unixtime = Int(Date().timeIntervalSince1970)
                        let prelat =  OneCallData(jsonResponse: self.getJSON("data")!).lat
                        let prelon = OneCallData(jsonResponse: self.getJSON("data")!).lon
                        let roundlat = round(Double(self.latitude!)!*100)/100
                        let roundlon = round(Double(self.longitude!)!*100)/100
                        
                        if self.unixtime < self.upper && "\(roundlat)" == "\(prelat)" && "\(roundlon)" == "\(prelon)"  {
                            print("データ更新後アクセス：通信なし")
                            AF.request("https://www.jma.go.jp/jp/week/\(userDefaults.object(forKey: "placeNumber") ?? "").html#top").responseString { [self] response in
                                switch response.result{
                                case .success(let value):
                                    print("週間気象庁通信成功")
                                    let html = value
                                    if let doc = try? HTML(html: html, encoding: .utf8){
                                    
                                        for i in 1...7{
                                            
                                            if userDefaults.object(forKey: "localWeekNumber") as! Int == 1{
                                                let link = doc.xpath("//*[@id='infotablefont']//tr[2]/td[\(i)]/img/@src").first
                                                
                                                b.append(link?.text ?? "")
                                            } else {
                                                let link = doc.xpath("//*[@id='infotablefont']/td[\(i)]/img/@src").first
                                                b.append(link?.text ?? "")
                                            }
                                        }
                                        print(b)
                                        if b.count > 7{
                                            for i in 1...8{
                                                b.remove(at: 0)
                                            }
                                          
                                        }
                                        
                                        userDefaults.setValue(b, forKey: "officialWeek")
                                        AF.request("https://www.jma.go.jp/jp/yoho/\(userDefaults.object(forKey: "placeNumber") ?? "").html#top").responseString { [self] response in
                                            switch response.result{
                                            case .success(let value):
                                                print("3日間気象庁通信成功")
                                                let html = value
                                                if let doc = try? HTML(html: html, encoding: .utf8){
                                                    let localArray:[Int] = userDefaults.array(forKey: "localNumber") as! [Int]
                                                    for i in localArray{
                                                        let link = doc.xpath("//*[@id='forecasttablefont']//tr[\(i)]/th/img/@src").first
                                                            a.append(link?.text ?? "")
                                                    }
                                                    if doc.xpath("//*[@id='forecasttablefont']//tr[\(localArray[2])]/th/img/@src").first == nil{
                                                        print("3日目nil")
                                                        a.removeLast()
                                                        a.append(b[0])
                                                        
                                                    }
                                                    if a.count > 3{
                                                        
                                                        for i in 1...3{
                                                            a.remove(at: 0)
                                                        }
                                                        print("3日間配列更新完了")
                                                    }
                                                    b.insert(a[0], at: 0)
                                                    print("最新a：\(a)")
                                                    print("最新b：\(b)")
                                                    userDefaults.setValue(a, forKey: "official")
                                                    
                                                }
                                                
                                            case .failure(let value):
                                                print("通信失敗")
                                                debugPrint(value)
                                            }
                                        }
                                        
                                        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(self.latitude!)&lon=\(self.longitude!)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee").responseJSON{
                                            response in
                                            //responseには通信したデータが入る
                                            switch response.result{
                                            case .success(let value):
                                                print("データ更新成功")
                                                self.onecall = OneCallData(jsonResponse: JSON(value),string1: a[0], string2: a[1], string3: a[2],array: b)
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
                                        
                                    }
                                    
                                case .failure(let value):
                                    print("通信失敗")
                                    debugPrint(value)
                                }
                            }
                            
                            //データ更新後アクセス
                        } else {
                            print("データ更新後アクセス：通信あり")
                            self.cityLabel.text = userDefaults.object(forKey: "address") as? String
                            AF.request("https://www.jma.go.jp/jp/week/\(userDefaults.object(forKey: "placeNumber") ?? "").html#top").responseString { [self] response in
                                switch response.result{
                                case .success(let value):
                                    print("週間気象庁通信成功")
                                    let html = value
                                    if let doc = try? HTML(html: html, encoding: .utf8){
                                    
                                        for i in 1...7{
                                            if userDefaults.object(forKey: "localWeekNumber") as! Int == 1{
                                                let link = doc.xpath("//*[@id='infotablefont']//tr[2]/td[\(i)]/img/@src").first
                                                b.append(link?.text ?? "")
                                            } else {
                                                let link = doc.xpath("//*[@id='infotablefont']/td[\(i)]/img/@src").first
                                                b.append(link?.text ?? "")
                                                
                                                
                                            }
                                        }
                                        if b.count > 7{
                                            for i in 1...8{
                                                b.remove(at: 0)
                                            }
                                          
                                        }
                                       
                                        userDefaults.setValue(b, forKey: "officialWeek")
                                        AF.request("https://www.jma.go.jp/jp/yoho/\(userDefaults.object(forKey: "placeNumber") ?? "").html#top").responseString { [self] response in
                                            switch response.result{
                                            case .success(let value):
                                                print("3日間気象庁通信成功")
                                                let html = value
                                                if let doc = try? HTML(html: html, encoding: .utf8){
                                                    let localArray:[Int] = userDefaults.array(forKey: "localNumber") as! [Int]
                                                    for i in localArray{
                                                        let link = doc.xpath("//*[@id='forecasttablefont']//tr[\(i)]/th/img/@src").first
                                                            a.append(link?.text ?? "")
                                                    }
                                                    if doc.xpath("//*[@id='forecasttablefont']//tr[\(localArray[2])]/th/img/@src").first == nil{
                                                        print("3日目nil")
                                                        a.removeLast()
                                                        a.append(b[0])
                                                        
                                                    }
                                                    if a.count > 3{
                                                        for i in 1...3{
                                                            a.remove(at: 0)
                                                        }
                                                        print("3日間配列更新完了")
                                                    }
                                                    b.insert(a[0], at: 0)
                                                    print("最新a：\(a)")
                                                    print("最新b：\(b)")
                                                    userDefaults.setValue(a, forKey: "official")
                                                    
                                                }
                                                
                                            case .failure(let value):
                                                print("通信失敗")
                                                debugPrint(value)
                                            }
                                        }
                                        
                                        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(self.latitude!)&lon=\(self.longitude!)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee").responseJSON{
                                            response in
                                            //responseには通信したデータが入る
                                            switch response.result{
                                            case .success(let value):
                                                print("データ更新成功")
                                                self.onecall = OneCallData(jsonResponse: JSON(value),string1: a[0], string2: a[1], string3: a[2],array: b)
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
                                        
                                    }
                                    
                                case .failure(let value):
                                    print("通信失敗")
                                    debugPrint(value)
                                }
                            }
                            
                           
                        }
                        
                        
                    } else {
                        //初回通信
                        print("!!!!!!!!!!")
                        print(userDefaults.object(forKey: "placeNumber") ?? "")
                        self.cityLabel.text = userDefaults.object(forKey: "address") as? String
                        AF.request("https://www.jma.go.jp/jp/week/\(userDefaults.object(forKey: "placeNumber") ?? "").html#top").responseString { [self] response in
                            switch response.result{
                            case .success(let value):
                                
                                let html = value
                                if let doc = try? HTML(html: html, encoding: .utf8){
                                
                                    for i in 1...7{
                                        if userDefaults.object(forKey: "localWeekNumber") as! Int == 1{
                                            let link = doc.xpath("//*[@id='infotablefont']//tr[2]/td[\(i)]/img/@src").first
                                            b.append(link?.text ?? "")
                                        } else {
                                            let link = doc.xpath("//*[@id='infotablefont']/td[\(i)]/img/@src").first
                                            b.append(link?.text ?? "")
                                        }
                                    }
                                    
                                    
                                    print("週間気象庁通信成功")
                                    if b.count > 7{
                                        for i in 1...8{
                                            b.remove(at: 0)
                                        }
                                    }
                                    userDefaults.setValue(b, forKey: "officialWeek")
                                    AF.request("https://www.jma.go.jp/jp/yoho/\(userDefaults.object(forKey: "placeNumber") ?? "").html#top").responseString { [self] response in
                                        switch response.result{
                                        case .success(let value):
                                            print("3日間気象庁通信成功")
                                            let html = value
                                            if let doc = try? HTML(html: html, encoding: .utf8){
                                                let localArray:[Int] = userDefaults.array(forKey: "localNumber") as! [Int]
                                                for i in localArray{
                                                    let link = doc.xpath("//*[@id='forecasttablefont']//tr[\(i)]/th/img/@src").first
                                                        a.append(link?.text ?? "")
                                                }
                                                if doc.xpath("//*[@id='forecasttablefont']//tr[\(localArray[2])]/th/img/@src").first == nil{
                                                    print("3日目nil")
                                                    a.removeLast()
                                                    a.append(b[0])
                                                    
                                                }
                                                if a.count > 3{
                                                    for i in 1...3{
                                                        a.remove(at: 0)
                                                    }
                                                    print("3日間配列更新完了")
                                                }
                                                b.insert(a[0], at: 0)
                                                
                                                userDefaults.setValue(a, forKey: "official")
                                                
                                            }
                                            
                                        case .failure(let value):
                                            print("通信失敗")
                                            debugPrint(value)
                                        }
                                    }
                                    
                                    AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(self.latitude!)&lon=\(self.longitude!)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee").responseJSON{
                                        response in
                                        //responseには通信したデータが入る
                                        switch response.result{
                                        case .success(let value):
                                            print("初回通信成功")
                                            print("最新a：\(a)")
                                            print("最新b：\(b)")
                                            self.onecall = OneCallData(jsonResponse: JSON(value),string1: a[0], string2: a[1], string3: a[2],array: b)
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
                                    
                                }
                                
                            case .failure(let value):
                                print("通信失敗")
                                debugPrint(value)
                            }
                        }
                        userDefaults.set(true, forKey: "visit")
                        
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
        //self.weatherLabel.text = "\(self.onecall!.daily[0].mainjp)"
        self.weatherLabel.text = "\(self.onecall!.weekly[0].desc)"
        self.maxTemp.text = "\(self.onecall!.daily[0].maxtempRound)℃"
        self.minTemp.text = "\(self.onecall!.daily[0].mintempRound)℃"
        self.imageView.image = UIImage(named: "\(self.onecall!.weekly[0].icon)")
        self.tmrdayLabel.text = "\(self.onecall!.daily[1].daydt)"
        //self.tmrweatherLabel.text = "\(self.onecall!.daily[1].mainjp)"
        self.tmrweatherLabel.text = "\(self.onecall!.weekly[1].desc)"
        self.tmrmaxTemp.text = "\(self.onecall!.daily[1].maxtempRound)℃"
        self.tmrminTemp.text = "\(self.onecall!.daily[1].mintempRound)℃"
        //self.tmrimageView.image = UIImage(named: "\(self.onecall!.daily[1].icon)")
        self.tmrimageView.image = UIImage(named: "\(self.onecall!.weekly[1].icon)")
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
        cell.setDailyData(onecall!.daily[indexPath.row],onecall!.weekly[indexPath.row])
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
    func isJapanese()  {
       
            if prefLang!.hasPrefix("ja"){
                print("日本語")
            }else{
                print("その他")
            }
    }

    
    
}


