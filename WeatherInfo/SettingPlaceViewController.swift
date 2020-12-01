//
//  SettingPlaceViewController.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/09.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SettingPlaceViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MKLocalSearchCompleterDelegate,UITextFieldDelegate {
    
    var latitude:Double?
    var longitude:Double?
    
    @IBOutlet weak var cancelIcon: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    let homeViewController = HomeViewController()
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBAction private func textFieldEditingChanged(_ sender: Any) {
        searchCompleter.queryFragment = textField.text!
    }
    
    private var searchCompleter = MKLocalSearchCompleter()
    var subaddress : String?
    var address = "地名"
    var mainaddress = "地名"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchCompleter.delegate = self
        textField.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if homeViewController.userDefaults.object(forKey: "latest") != nil{
            self.cancelButton.isHidden = false
            self.cancelIcon.isHidden = false
            self.cancelButton.isEnabled = true
            self.textField.placeholder = "位置情報を入力"
        } else if homeViewController.userDefaults.object(forKey: "latest") == nil{
            self.cancelButton.isHidden = true
            self.cancelIcon.isHidden = true
            self.cancelButton.isEnabled = false
            self.textField.placeholder = "位置情報を登録してください"
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleter.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let completion = searchCompleter.results[indexPath.row]
        if completion.subtitle != "近くを検索" {
            print(completion.title)
            print(completion.subtitle)
            cell.textLabel?.text = completion.title
            cell.detailTextLabel?.text = completion.subtitle
        }
        
       
        return cell
    }
    
    // 正常に検索結果が更新されたとき
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        tableView.reloadData()
    }
    
    // 検索が失敗したとき
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("エラー")
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.subaddress = "\(searchCompleter.results[indexPath.row].subtitle)"
        self.address = "\(searchCompleter.results[indexPath.row].title)"
        
        if self.subaddress! == ""{
            self.mainaddress = self.address
        } else{
            self.mainaddress = self.subaddress!
        }
        
        CLGeocoder().geocodeAddressString(self.mainaddress) { placemarks, error in
            if let lat = placemarks?.first?.location?.coordinate.latitude, let lon = placemarks?.first?.location?.coordinate.longitude {
                print("緯度 : \(lat)")
                self.latitude = lat
                print("経度 : \(lon)")
                self.longitude = lon
                
                
                let location = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
                CLGeocoder().reverseGeocodeLocation(location) { [self] placemarks, error in
                    if let firstPlacemark = placemarks?.first {
                        var placeName = ""
                        var localName = ""
                        var placeNumber = 0
                        var localNumber = [0]
                        var localWeekNumber = 0
                        
                        
                        if let administrativeArea = firstPlacemark.administrativeArea, let locality = firstPlacemark.locality{
                            placeName.append(administrativeArea)
                            localName.append(locality)
                            
                            switch placeName {
                            case "宗谷地方":
                                placeNumber = 301
                                localNumber = [2,3,4]
                                localWeekNumber = 1
                            case "上川","留萌地方":
                                placeNumber = 302
                                let array1 = ["士別市","名寄市","和寒町","剣淵町","下川町","美深町","音威子府村","中川町","幌加内町",       "旭川市","鷹栖町","東神楽町","当麻町","比布町","愛別町","上川町","東川町","美瑛町","富良野市","上富良野町","中富良野町","南富良野町","占冠村"]
                         
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "網走","北見","紋別地方":
                                placeNumber = 303
                                let array1 = ["斜里町","清里町","小清水町","網走市","佐呂間町","大空町","美幌町","津別町"]
                                
                                let array2 = ["北見市","訓子府町","置戸町"]
                                
                                
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "釧路","根室","十勝地方":
                                placeNumber = 304
                                let array1 = ["弟子屈町","標茶町","鶴居村","厚岸町","浜中町","釧路市","釧路町","白糠町"]
                                
                                let array2 = ["中標津町","標津町","羅臼町","別海町","根室市"]
                             
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "胆振","日高地方":
                                placeNumber = 305
                                let array1 = ["伊達市","豊浦町","壮瞥町","洞爺湖町","室蘭市","苫小牧市","登別市","白老町","厚真町","安平町","むかわ町"]
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "石狩","空知","後志地方":
                                placeNumber = 306
                                let array1 = ["石狩市","当別町","新篠津村","札幌市","江別市","千歳市","恵庭市","北広島市"]
                                
                                let array2 = [ "深川市","妹背牛町","秩父別町","北竜町","沼田町","芦別市","赤平市","滝川市","砂川市","歌志内市","奈井江町","上砂川町","浦臼町","新十津川町","雨竜町","夕張市","岩見沢市","美唄市","三笠市","南幌町","由仁町","長沼町","栗山町,月形町"]
                       
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "渡島","檜山地方":
                                placeNumber = 307
                                let array1 = ["八雲町","長万部町","函館市","北斗市","七飯町","鹿部町","森町","松前町","福島町","知内町","木古内町"]
                                localNumber = [2,3,4]
                                
                                localNumber = [6,7,8]
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [10,11,12]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [14,15,16]
                                }
                                localWeekNumber = 1
                            case "青森県":
                                placeNumber = 308
                                let array1 = ["青森市","平内町","今別町","蓬田村","外ヶ浜町","五所川原市","板柳町","鶴田町","中泊町","つがる市","鰺ヶ沢町","深浦町",           "弘前市","黒石市","平川市","西目屋村","藤崎町","大鰐町","田舎館村"]
                                
                                let array2 = [ "むつ市","大間町","東通村","風間浦村","佐井村"]
                               
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                        localWeekNumber = 1
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                    localWeekNumber = 2
                                }
                                
                            case "秋田県":
                                placeNumber = 309
                                
                                let array1 = ["能代市","藤里町","三種町","八峰町","秋田市","男鹿市","潟上市","五城目町","八郎潟町","井川町","大潟村","由利本荘市","にかほ市"]
                               
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "岩手県":
                                placeNumber = 310
                                let array1 = ["二戸市","軽米町","九戸村","一戸町","盛岡市","八幡平市","滝沢市","雫石町","葛巻町","岩手町","紫波町","矢巾町","花巻市","北上市","西和賀町","遠野市","奥州市","金ケ崎町","一関市","平泉町"]
                                
                                let array2 = ["久慈市","普代村","野田村","洋野町","宮古市","山田町","岩泉町","田野畑村"]
                                
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                        localWeekNumber = 1
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                    localWeekNumber = 2
                                }
                                
                            case "山形県":
                                placeNumber = 311
                                let array1 = [ "村山市","東根市","尾花沢市","大石田町","寒河江市","河北町","西川町","朝日町","大江町","山形市","上山市","天童市","山辺町","中山町"]
                                
                                let array2 = ["米沢市","南陽市","高畠町","川西町","長井市","小国町","白鷹町","飯豊町"]
                                
                                let array3 = ["酒田市","遊佐町","鶴岡市","三川町","庄内町"]
                                  
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [10,11,12]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [14,15,16]
                                }
                                localWeekNumber = 1
                            case "宮城県":
                                placeNumber = 312
                                let array1 = [ "気仙沼市","南三陸町","石巻市","東松島市","女川町","登米市","栗原市","大崎市","涌谷町","美里町","仙台市","塩竈市","名取市","多賀城市","岩沼市","富谷市","亘理町","山元町","松島町","七ヶ浜町","利府町","大和町","大郷町","角田市","大河原町","村田町","柴田町","丸森町"]
                                
                                
                                
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                        localWeekNumber = 1
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                    localWeekNumber = 2
                                }
                                
                            case "福島県":
                                placeNumber = 313
                                let array1 = [ "福島市","伊達市","桑折町","国見町","川俣町","郡山市","須賀川市","二本松市","田村市","本宮市","大玉村","鏡石町","天栄村","三春町","小野町","白河市","西郷村","泉崎村","中島村","矢吹町","棚倉町","矢祭町","塙町","鮫川村","石川町","玉川村","平田村","浅川町","古殿町"]
                                
                                let array2 = ["相馬市","南相馬市","新地町","飯舘村","広野町","楢葉町","富岡町","川内村","大熊町","双葉町","浪江町","葛尾村","いわき市"]
                                
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                        localWeekNumber = 1
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 1
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                    localWeekNumber = 2
                                }
                                
                            case "茨城県":
                                placeNumber = 314
                                let array1 = [ "日立市","常陸太田市","高萩市","北茨城市","ひたちなか市","常陸大宮市","那珂市","東海村","大子町","水戸市","笠間市","小美玉市","茨城町","大洗町","城里町"]
                               
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "群馬県":
                                placeNumber = 315
                                let array1 = ["沼田市","片品村","川場村","昭和村","みなかみ町","中之条町","長野原町","嬬恋村","草津町","高山村","東吾妻町"]
                                
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                    localWeekNumber = 1
                                }
                                
                                
                                localWeekNumber = 1
                            case "栃木県":
                                placeNumber = 316
                                let array1 = ["大田原市","矢板市","那須塩原市","塩谷町","那須町","日光市"]
                                
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                }
                                localWeekNumber = 1
                            case "埼玉県":
                                placeNumber = 317
                                let array1 = ["春日部市","草加市","越谷市","八潮市","三郷市","蓮田市","幸手市","吉川市","白岡市","宮代町","杉戸町","松伏町",
                                              "さいたま市","川越市","川口市","所沢市","狭山市","上尾市","蕨市","戸田市","朝霞市","志木市","和光市","新座市","桶川市","北本市","富士見市","ふじみ野市","伊奈町","三芳町","川島町","飯能市","入間市","坂戸市","鶴ヶ島市","日高市","毛呂山町","越生町"]
                                
                                let array2 = ["行田市","加須市","羽生市","鴻巣市","久喜市","熊谷市","本庄市","東松山市","深谷市","滑川町","嵐山町","小川町","吉見町","鳩山町","ときがわ町","東秩父村","美里町","神川町","上里町","寄居町"]
                                
                                
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array1[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "千葉県":
                                placeNumber = 318
                                let array1 = [ "銚子市","旭市","匝瑳市","香取市","神崎町","多古町","東庄町","茂原市","東金市","山武市","大網白里市","九十九里町","芝山町","横芝光町","一宮町","睦沢町","長生村","白子町","長柄町","長南町"]
                                
                                let array2 = [ "成田市","佐倉市","四街道市","八街市","印西市","白井市","富里市","酒々井町","栄町","市川市","船橋市","松戸市","野田市","習志野市","柏市","流山市","八千代市","我孫子市","鎌ヶ谷市","浦安市","千葉市","市原市"]
                                
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array1[n])) {
                                        count2 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "東京都":
                                placeNumber = 319
                                let array1 =  ["大島町","利島村","新島村","神津島村"]
                                let array2 = ["三宅村","御蔵島","村八丈町","青ヶ島村"]
                                let array3 = ["小笠原村"]
                                
                                
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array1[n])) {
                                        count2 += 1
                                        localNumber = [10,11,12]
                                        localWeekNumber = 2
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array1[n])) {
                                        count3 += 1
                                        localNumber = [14,15,16]
                                        localWeekNumber = 2
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                    localWeekNumber = 1
                                }
                                
                            case "神奈川県":
                                placeNumber = 320
                                let array1 = ["横浜市","川崎市","平塚市","藤沢市","茅ヶ崎市","大和市","海老名市","座間市","綾瀬市","寒川町","大磯町","二宮町","横須賀市","鎌倉市","逗子市","三浦市","葉山町"]
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                                
                            case "山梨県":
                                placeNumber = 321
                                
                                let  array1 = [ "都留市","大月市","上野原市","道志村","小菅村","丹波山村","富士吉田市","西桂町","忍野村","山中湖村","鳴沢村","富士河口湖町"]
                                
                                var count1 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 1
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                    localWeekNumber = 1
                                }
                                
                                
                            case "長野県":
                                placeNumber = 322
                                let array1 = ["中野市","飯山市","山ノ内町","木島平村","野沢温泉村","栄村","長野市","須坂市","千曲市","坂城町","小布施町","高山村","信濃町","小川村","飯綱町","大町市","池田町","松川村","白馬村","小谷村"]
                                let array2 = ["上田市","東御市","青木村","長和町","小諸市","佐久市","小海町","川上村","南牧村","南相木村","北相木村","佐久穂町","軽井沢町","御代田町","立科町","松本市","塩尻市","安曇野市","麻績村","生坂村","山形村","朝日村","筑北村","岡谷市","諏訪市","茅野市","下諏訪町","富士見町","原村"]
                                var count1 = 0
                                var count2 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                        localWeekNumber = 1
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                    localWeekNumber = 2
                                }
                                
                            case "新潟県":
                                placeNumber = 323
                                let array1 = ["上越市","糸魚川市","妙高市"]
                                let array2 =  ["三条市","加茂市","田上町","魚沼市","長岡市","小千谷市","見附市","出雲崎町","柏崎市","刈羽村","南魚沼市","湯沢町","十日町市","津南町"]
                                let array3 =  ["村上市","関川村","粟島浦村","新発田市","胎内市","聖籠町","新潟市","燕市","阿賀野市","弥彦村","五泉市","阿賀町"]
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [10,11,12]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [14,15,16]
                                }
                                localWeekNumber = 1
                            case "富山県":
                                placeNumber = 324
                                let array1 = ["朝日町","黒部市","魚津市","滑川市","入善町","富山市","舟橋村","上市町","立山町"]
                                var count1 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "石川県":
                                placeNumber = 325
                                let array1 = ["輪島市","珠洲市","穴水町","能登町","七尾市","羽咋市","志賀町","宝達志水町","中能登町"]
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                }
                                localWeekNumber = 1
                            case "福井県":
                                placeNumber = 326
                                let array1 = ["大野市","勝山市","福井市","あわら市","坂井市","永平寺町","越前町","鯖江市","越前市","池田町","南越前町"]
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "静岡県":
                                placeNumber = 327
                                let array1 = ["熱海市","伊東市","伊豆市","伊豆の国市","函南町","下田市","東伊豆町","河津町","南伊豆町","松崎町","西伊豆町"]
                                
                                let array2 = ["沼津市","三島市","御殿場市","裾野市","清水町","長泉町","小山町","富士宮市","富士市"]
                                
                                let array3 = ["静岡市","川根本町","島田市","焼津市","藤枝市","牧之原市","吉田町"]
                                
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [10,11,12]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [14,15,16]
                                }
                                localWeekNumber = 1
                            case "岐阜県":
                                placeNumber = 328
                                let array1 = ["高山市","飛騨市","白川村","下呂市"]
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                    localWeekNumber = 1
                                }
                                
                            case "愛知県":
                                placeNumber = 329
                                let array1 = ["新城市","設楽町","東栄町","豊根村","豊橋市","豊川市","蒲郡市","田原市","豊田市"]
                                var count1 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                }
                                localWeekNumber = 1
                            case "三重県":
                                placeNumber = 330
                                let array1 = [ "四日市市","桑名市","鈴鹿市","亀山市","いなべ市","木曽岬町","東員町","菰野町","朝日町","川越町","津市","松阪市","多気町","明和町","名張市","伊賀市"]
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "大阪府":
                                placeNumber = 331
                                localNumber = [2,3,4]
                                localWeekNumber = 1
                            case "兵庫県":
                                placeNumber = 332
                                let array1 = ["豊岡市","香美町","新温泉町","養父市","朝来市"]
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                    localWeekNumber = 1
                                }
                                
                            case "京都府":
                                placeNumber = 333
                                let array1 = ["宮津市","京丹後市","伊根町","与謝野町","舞鶴市","綾部市","福知山市"]
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                    localWeekNumber = 1
                                }
                                
                            case "滋賀県":
                                placeNumber = 334
                                let array1 = ["長浜市","米原市","彦根市","愛荘町","豊郷町","甲良町","多賀町","大津市","高島市"]
                                localNumber = [6,7,8]
                                
                                
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                    localWeekNumber = 1
                                }
                                
                            case "奈良県":
                                placeNumber = 335
                                let array1 = [ "宇陀市","山添村","奈良市","大和高田市","大和郡山市","天理市","橿原市","桜井市","御所市","生駒市","香芝市","葛城市","平群町","三郷町","斑鳩町","安堵町","川西町","三宅町","田原本町","高取町","明日香村","上牧町","王寺町","広陵町","河合町","五條市","吉野町","大淀町","下市町"]
                                
                                
                                
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "和歌山県":
                                placeNumber = 336
                                let array1 = ["和歌山市","海南市","橋本市","紀の川市","岩出市","紀美野町","かつらぎ町","九度山町","高野町","有田市","御坊市","湯浅町","広川町","有田川町","美浜町","日高町","由良町","印南町","みなべ町","日高川町"]
                                
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "島根県":
                                placeNumber = 337
                                let array1 = ["松江市","安来市","出雲市","雲南市","奥出雲町","飯南町"]
                                let array2 = ["大田市","川本町","美郷町","邑南町","浜田市","江津市","益田市","津和野町","吉賀町"]
                                
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "広島県":
                                placeNumber = 338
                                let array1 = ["三次市","庄原市","安芸高田市","安芸太田町","北広島町"]
                                
                                
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                    localWeekNumber = 1
                                }
                                
                            case "鳥取県":
                                placeNumber = 339
                                let array1 = ["鳥取市","岩美町","若桜町","智頭町","八頭町"]
                                
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "岡山県":
                                placeNumber = 340
                                let array1 = ["美作市","勝央町","奈義町","西粟倉村","津山市","鏡野町","久米南町","美咲町","真庭市","新庄村","新見市"]
                                
                                
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 2
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                    localWeekNumber = 1
                                }
                                
                            case "香川県":
                                placeNumber = 341
                                localNumber = [2,3,4]
                                localWeekNumber = 1
                            case "愛媛県":
                                placeNumber = 342
                                let array1 = ["新居浜市","西条市","四国中央市","今治市","上島町"]
                                
                                let array2 = ["松山市","伊予市","東温市","久万高原町","松前町","砥部町"]
                                
                                
                                
                                
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "徳島県":
                                placeNumber = 343
                                let array1 = ["徳島市","鳴門市","小松島市","松茂町","北島町","藍住町","板野町","吉野川市","阿波市","石井町","上板町","美馬市","佐那河内村","神山町","つるぎ町","三好市","東みよし町"]
                           
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                            case "高知県":
                                placeNumber = 344
                                let array1 = ["室戸市","東洋町","安芸市","奈半利町","田野町","安田町","北川村","馬路村","芸西村"]
                                
                                let array2 = [ "高知市","南国市","土佐市","須崎市","香南市","香美市","いの町","日高村","本山町","大豊町","土佐町","大川村","仁淀川町","佐川町","越知町"]
                                
                                
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "山口県":
                                placeNumber = 345
                                
                                let array1 = ["萩市","美祢市","阿武町","長門市"]
                                
                                let array2 = ["岩国市","和木町","光市","柳井市","周防大島町","上関町","田布施町","平生町"]
                                
                                let array3 = ["下松市","周南市","山口市","防府市"]
                                
                                
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [14,15,16]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [10,11,12]
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                }
                                localWeekNumber = 1
                            case "福岡県":
                                placeNumber = 346
                                let array1 = ["福岡市","筑紫野市","春日市","大野城市","宗像市","太宰府市","古賀市","福津市","糸島市","那珂川市","宇美町","篠栗町","志免町","須恵町","新宮町","久山町","粕屋町"]
                                
                                let array2 = ["北九州市","中間市","芦屋町","水巻町","岡垣町","遠賀町","行橋市","豊前市","苅田町","みやこ町","吉富町","上毛町","築上町"]
                                
                                let array3 = [ "直方市","飯塚市","田川市","宮若市","嘉麻市","小竹町","鞍手町","桂川町","香春町","添田町","糸田町","川崎町","大任町","赤村","福智町"]
                                
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [10,11,12]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [14,15,16]
                                }
                                localWeekNumber = 1
                            case "佐賀県":
                                placeNumber = 347
                                
                                let array1 = ["唐津市","玄海町","伊万里市","有田町"]
                                
                                
                                
                                var count1 = 0
                                
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                
                                if localNumber == [0]{
                                    localNumber = [2,3,4]
                                }
                                localWeekNumber = 1
                            case "長崎県":
                                placeNumber = 348
                                
                                let array1 = ["平戸市","松浦市","佐世保市","東彼杵町","川棚町","波佐見町","佐々町"]
                                
                                let array2 = ["島原市","雲仙市","南島原市","諫早市","大村市","長崎市","長与町","時津町","西海市"]
                                
                                let array3 = ["上対馬","壱岐市"]
                                
                                
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 1
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [2,3,4]
                                        localWeekNumber = 1
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [10,11,12]
                                        localWeekNumber = 2
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [14,15,16]
                                    localWeekNumber = 2
                                }
                                
                            case "熊本県":
                                placeNumber = 349
                                let array1 = ["山鹿市","菊池市","合志市","大津町","菊陽町","荒尾市","玉名市","玉東町","南関町","長洲町","和水町","熊本市","西原村","御船町","嘉島町","益城町","甲佐町","山都町","八代市","宇土市","宇城市","美里町","氷川町"]
                                
                                let array2 = ["阿蘇市","南小国町","小国町","産山村","高森町","南阿蘇村"]
                                
                                let array3 = ["上天草市","天草市","苓北町","水俣市","芦北町","津奈木町"]
                                
                                
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [10,11,12]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [14,15,16]
                                }
                                localWeekNumber = 1
                            case "大分県":
                                placeNumber = 350
                                let array1 = ["中津市","豊後高田市","宇佐市","国東市","姫島村"]
                                
                                let array2 = ["大分市","別府市","臼杵市","津久見市","杵築市","由布市","日出町"]
                                
                                let array3 = ["佐伯市","豊後大野市"]
                                
                                
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [14,15,16]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "宮崎県":
                                placeNumber = 351
                                let array1 = ["小林市","えびの市","高原町","都城市","三股町"]
                                
                                let array2 =  ["延岡市","日向市","門川町","西都市","高鍋町","新富町","木城町","川南町","都農町"]
                                
                                let array3 =  ["宮崎市","国富町","綾町","日南市","串間市"]
                                
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [10,11,12]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [14,15,16]
                                }
                                localWeekNumber = 1
                            case "鹿児島県":
                                placeNumber = 352
                                let array1 = [ "阿久根市","出水市","伊佐市","長島町","薩摩川内市","霧島市","さつま町","姶良市","湧水町","鹿児島市","日置市","いちき串木野市","枕崎市","指宿市","南さつま市","南九州市"]
                                
                                let array2 = ["曽於市","志布志市","大崎町","鹿屋市","垂水市","東串良町","錦江町","南大隅町","肝付町"]
                                
                                let array3 = ["西之表市","三島村","中種子町","南種子町","屋久島町"]
                                
                                var count1 = 0
                                var count2 = 0
                                var count3 = 0
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                        localWeekNumber = 1
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [6,7,8]
                                        localWeekNumber = 1
                                    }
                                }
                                for n in 0..<array3.count {
                                    if (localName.contains(array3[n])) {
                                        count3 += 1
                                        localNumber = [10,11,12]
                                        localWeekNumber = 1
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [14,15,16]
                                    localWeekNumber = 2
                                }
                                
                            case "沖縄県":
                                placeNumber = 353
                                let array1 = ["伊平屋村","伊是名村","国頭村","大宜味村","東村","名護市","今帰仁村","本部町","伊江村","恩納村","宜野座村","金武町"]
                                
                                let array2 = [ "宜野湾市","沖縄市","うるま市","読谷村","嘉手納町","北谷町","北中城村","中城村","那覇市","浦添市","糸満市","豊見城市","南城市","西原町","与那原町","南風原町","八重瀬町","渡嘉敷村","座間味村","粟国村","渡名喜村"]
                                
                                var count1 = 0
                                var count2 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [6,7,8]
                                    }
                                }
                                for n in 0..<array2.count {
                                    if (localName.contains(array2[n])) {
                                        count2 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [10,11,12]
                                }
                                localWeekNumber = 1
                            case "大東島地方":
                                placeNumber = 354
                                localNumber = [2,3,4]
                                localWeekNumber = 1
                            case "宮古島地方":
                                placeNumber = 355
                                localNumber = [2,3,4]
                                localWeekNumber = 1
                            case "八重山地方":
                                placeNumber = 356
                                let array1 = ["石垣市","竹富町"]
                                var count1 = 0
                                
                                for n in 0..<array1.count {
                                    if (localName.contains(array1[n])) {
                                        count1 += 1
                                        localNumber = [2,3,4]
                                    }
                                }
                                if localNumber == [0]{
                                    localNumber = [6,7,8]
                                }
                                localWeekNumber = 1
                                
                            default:
                                placeNumber = 11111
                            }
                            
                            print(placeName)
                            print(locality)
                            
                        }
                        
                        print("Set県番号：\(placeNumber)")
                        print("Set位置詳細番号：\(localNumber)")
                        print("Set週間番号：\(localWeekNumber)")
                        self.homeViewController.userDefaults.setValue(placeNumber, forKey: "placeNumber")
                        self.homeViewController.userDefaults.setValue(localNumber, forKey: "localNumber")
                        self.homeViewController.userDefaults.setValue(localWeekNumber, forKey: "localWeekNumber")
                        self.homeViewController.userDefaults.setValue(self.address, forKey: "address")
                        homeViewController.userDefaults.set(self.mainaddress, forKey:"latest")
                        homeViewController.userDefaults.synchronize()
                        // セルの選択を解除
                        tableView.deselectRow(at: indexPath, animated: true)
                        
                        //let nextViewController = TabBarController()
                        //self.present(nextViewController, animated: true, completion: nil) // 画面遷移
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
                
            }
            
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
   
}
