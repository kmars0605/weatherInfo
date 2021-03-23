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
    let sectionTitle = ["洗濯指数","天気アイコン"]
    let arrayData1 = [
        ["title":"index1", "content":"乾かない。外干しをしても乾かないため、\n部屋干しを特に推奨"],
        ["title":"index2", "content":"あまり乾かない。外干しをしても長時間\n干す必要があるため、部屋干しを推奨"],
        ["title":"index3", "content":"やや乾く。普段より少し長めに\n干すことを推奨。部屋干しでも良い。"],
        ["title":"index4", "content":"乾く。平均的な干し時間（6時間程）で\n乾くため、外干しを推奨"],
        ["title":"index5", "content":"よく乾く。短時間でカラッと乾くため、\n外干しを特に推奨。"],
    ]
    
    let arrayData2 = [
        ["title":"晴れ", "content":"日中の時間帯、晴れ"],
        ["title":"晴れ時々曇り", "content":"晴れ時々曇り"],
        ["title":"晴れ時々雨", "content":"晴れ時々雨"],
        ["title":"晴れ時々雪", "content":"晴れ時々雪"],
        ["title":"晴れのち曇り", "content":"晴れのち曇り"],
        ["title":"晴れのち雨", "content":"晴れのち雨"],
        ["title":"晴れのち雪", "content":"晴れのち雪"],
        ["title":"03d", "content":"くもり。雲量25%〜50%"],
        ["title":"曇り", "content":"くもり。雲量51%〜84%\nまたは雲量85%〜100%"],
        ["title":"曇り時々晴れ", "content":"曇り時々晴れ"],
        ["title":"曇り時々雨", "content":"曇り時々雨"],
        ["title":"曇り時々雪", "content":"曇り時々雪"],
        ["title":"曇りのち晴れ", "content":"曇りのち晴れ"],
        ["title":"曇りのち雨", "content":"曇りのち雨"],
        ["title":"曇りのち雪", "content":"曇りのち雪"],
        ["title":"09d", "content":"弱い雨。弱い雨が降ったり止んだり"],
        ["title":"雨", "content":"雨"],
        ["title":"雨時々晴れ", "content":"雨時々晴れ"],
        ["title":"雨時々曇り", "content":"雨時々曇り"],
        ["title":"雨時々雪", "content":"雨時々雪"],
        ["title":"暴風雨", "content":"暴風雨"],
        ["title":"雨のち晴れ", "content":"雨のち晴れ"],
        ["title":"雨のち曇り", "content":"雨のち曇り"],
        ["title":"雨のち雪", "content":"雨のち雪"],
        ["title":"雪", "content":"雪・激しい雪・みぞれ・ひょう"],
        ["title":"雪時々晴れ", "content":"雪時々晴れ"],
        ["title":"雪時々曇り", "content":"雪時々曇り"],
        ["title":"雪時々雨", "content":"雪時々雨"],
        ["title":"暴風雪", "content":"暴風雪"],
        ["title":"雪のち晴れ", "content":"雪のち晴れ"],
        ["title":"雪のち曇り", "content":"雪のち曇り"],
        ["title":"雪のち雨", "content":"雪のち雨"],
        ["title":"晴れ(夜)", "content":"夜中の時間帯、晴れ。"],
        ["title":"晴れ(夜)時々曇り", "content":"晴れ時々曇り"],
        ["title":"晴れ(夜)時々雨", "content":"晴れ時々雨"],
        ["title":"晴れ(夜)時々雪", "content":"晴れ時々雪"],
        ["title":"曇り時々晴れ(夜)", "content":"曇り時々晴れ"],
        ["title":"雨時々晴れ(夜)", "content":"雨時々晴れ"],
        ["title":"雪時々晴れ(夜)", "content":"雪時々晴れ"],
        ["title":"晴れ(夜)のち曇り", "content":"晴れのち曇り"],
        ["title":"晴れ(夜)のち雨", "content":"晴れのち雨"],
        ["title":"晴れ(夜)のち雪", "content":"晴れのち雪"],
        ["title":"曇りのち晴れ(夜)","content":"曇りのち晴れ"],
        ["title":"雨のち晴れ(夜)","content":"雨のち晴れ"],
        ["title":"雪のち晴れ(夜)","content":"雪のち晴れ"],
        ["title":"11d", "content":"雷・雷雨"],
        ["title":"50d", "content":"きり・砂塵・火山・灰突風・竜巻"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "IconDescTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: 44, height: 44))
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
