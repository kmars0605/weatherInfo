//
//  IconDescViewController.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/27.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class IconDescViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let sectionTitle = ["天気アイコン","洗濯指数"]
    
    let arrayData1 = [
        ["title":"index1", "content":"乾かない。外干しをしても乾かないため、\n部屋干しを特に推奨。"],
        ["title":"index2", "content":"あまり乾かない。外干しをしても長時間\n干す必要があるため、部屋干しを推奨。"],
        ["title":"index3", "content":"やや乾く。普段より少し長めに\n干すことを推奨。部屋干しでも良い。"],
        ["title":"index4", "content":"乾く。平均的な干し時間（6時間程）で\n乾くため、外干しを推奨。"],
        ["title":"index5", "content":"よく乾く。短時間でカラッと乾くため、\n外干しを特に推奨。"],
    ]
    
    let arrayData2 = [
        ["title":"01d", "content":"日中の時間帯、快晴。"],
        ["title":"01n", "content":"夜中の時間帯、快晴。"],
        ["title":"02d", "content":"晴れ。雲がやや多めだが雨の心配はなし。"],
        ["title":"02n", "content":"晴れ。雲がやや多めだが雨の心配はなし。"],
        ["title":"03d", "content":"くもり。雲量25%〜50%"],
        ["title":"04d", "content":"くもり。雲量51%〜84%\nまたは雲量85%〜100%"],
        ["title":"09d", "content":"弱い雨。弱い雨が降ったり止んだり。"],
        ["title":"10d", "content":"雨または激しい雨。"],
        ["title":"11d", "content":"雷または雷雨。"],
        ["title":"13d", "content":"雪、激しい雪、みぞれ、ひょう。"],
        ["title":"50d", "content":"きり、砂塵、火山、灰突風、竜巻"]

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "IconDescTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: 44, height: 44))
        
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayData1.count
        }
        else if section == 1 {
            return arrayData2.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IconDescTableViewCell
        
        if indexPath.section == 0{
            cell.iconImage.image = UIImage(named: String(arrayData1[indexPath.row]["title"]!))
            cell.descLabel.text = arrayData1[indexPath.row]["content"]
        }else if indexPath.section == 1{
            cell.iconImage.image = UIImage(named: String(arrayData2[indexPath.row]["title"]!))
            cell.descLabel.text = arrayData2[indexPath.row]["content"]
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 背景色を変更する
        view.tintColor = UIColor.lightGray//UIColor(red: 0.12889, green: 0.71556, blue: 1.07556, alpha:1.0)
        
        
    }
}
