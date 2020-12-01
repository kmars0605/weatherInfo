//
//  TabBarController.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/09.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    let homeViewController = HomeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        settingJustAfterUpdating()

        if homeViewController.userDefaults.object(forKey: "latest") == nil {
            let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPlace")
            self.present(settingPlaceViewController!, animated: true, completion: nil)
            
        }
    }
    
    func settingJustAfterUpdating() {
        // 最新バージョン番号の取得
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") else { return }
        let newVersionKey: String = "ver" + (version as! String)
        print("ver:\(newVersionKey)")
        // 初回起動時のみ処理が呼ばれるようにフラグを立てる
        /*homeViewController.userDefaults.setValue(true, forKey: newVersionKey)
        print("!!!!!!!!!!!!!2")
        print(homeViewController.userDefaults.object(forKey: newVersionKey))
        // もしも最新バージョンでのアプリ起動が初めてならば
        if homeViewController.userDefaults.bool(forKey: newVersionKey) {

            if homeViewController.userDefaults.object(forKey: "latest") != nil{
                homeViewController.userDefaults.setValue(nil, forKey: "latest")
            }

            // 不要となった過去バージョンにおけるフラグをUserDefaultsから削除する
            // verから始まる名前のキーが他の用途向けに無いよう設計に注意!
            guard let dataList = homeViewController.userDefaults.persistentDomain(forName: Bundle.main.bundleIdentifier!) else { return }
            let versionKeys = dataList.map({ (data) -> String in
                return data.key
            }).filter { (key) -> Bool in
                return key.hasPrefix("ver") // keyが"ver"から始まる場合
            }
            versionKeys.forEach { (key) in
                homeViewController.userDefaults.removeObject(forKey: key)
            }
            // 次回起動以降は処理が呼ばれなくなるようにフラグを折る
            homeViewController.userDefaults.setValue(false, forKey: newVersionKey)
            print("!!!!!!!!!!!!!!")
            print(homeViewController.userDefaults.object(forKey: newVersionKey))
            homeViewController.userDefaults.synchronize()
        }*/
        
        let visit = UserDefaults.standard.bool(forKey: newVersionKey)
        
        if visit {
            print("アップデート済み")
        }else{
            // もしも最新バージョンでのアプリ起動が初めてならば
            if homeViewController.userDefaults.object(forKey: "latest") != nil{
                homeViewController.userDefaults.setValue(nil, forKey: "latest")
        }
            UserDefaults.standard.set(true, forKey: newVersionKey)
            print(UserDefaults.standard.object(forKey: newVersionKey))
        }
    }
    
    

}
