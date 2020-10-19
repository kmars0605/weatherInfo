//
//  SettingViewController.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/09.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    @IBOutlet weak var currentLocation: UILabel!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = UserDefaults.standard.object(forKey: "LATEST") as? String{
            self.currentLocation.text = userDefaults.object(forKey: "LATEST") as! String
        }
    }
    @IBAction func settingPlaceButton(_ sender: Any) {
        let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPlace")
        self.present(settingPlaceViewController!, animated: true, completion: nil)
    }
    
    @IBAction func iconDescButton(_ sender: Any) {
    }
    
    @IBAction func inquiryButton(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
