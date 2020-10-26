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

class SettingPlaceViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MKLocalSearchCompleterDelegate {
    
    let homeViewController = HomeViewController()
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBAction private func textFieldEditingChanged(_ sender: Any) {
        searchCompleter.queryFragment = textField.text!
    }
    
    private var searchCompleter = MKLocalSearchCompleter()
    var address = "地名"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchCompleter.delegate = self
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleter.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let completion = searchCompleter.results[indexPath.row]
        cell.textLabel?.text = completion.title
        cell.detailTextLabel?.text = completion.subtitle
        
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
        self.address = "\(searchCompleter.results[indexPath.row].title)"
       
        homeViewController.userDefaults.set(self.address, forKey:"latest")
        homeViewController.userDefaults.synchronize()
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        //let nextViewController = TabBarController()
        //self.present(nextViewController, animated: true, completion: nil) // 画面遷移
        self.dismiss(animated: true, completion: nil)
        
    }
}
