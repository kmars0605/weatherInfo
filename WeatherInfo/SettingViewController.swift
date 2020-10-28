//
//  SetViewController.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/20.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit
import SafariServices


class SettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    let array = ["地点登録","アイコン説明","お問い合わせ"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = array[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // アクションを実装
        if indexPath.row == 0{
            let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPlace")
            self.present(settingPlaceViewController!, animated: true, completion: nil)
            let UINavigationController = tabBarController?.viewControllers?[0]
            tabBarController?.selectedViewController = UINavigationController
             
        } else if indexPath.row == 2{
            /*let inquiryViewController = self.storyboard?.instantiateViewController(withIdentifier: "Inquiry")
            self.present(inquiryViewController!, animated: true, completion: nil)
            let UINavigationController = tabBarController?.viewControllers?[0]
            tabBarController?.selectedViewController = UINavigationController*/
            let url = URL(string:"https://forms.gle/U6PhvHVNUxH6zgJD9")
            if let url = url{
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true, completion: nil)
            }
        } else if indexPath.row == 1{
            let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "IconDesc")
            self.present(settingPlaceViewController!, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
}
