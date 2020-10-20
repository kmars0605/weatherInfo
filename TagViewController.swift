//
//  TagViewController.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/19.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class TagViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let arrayData =  [
        ["JIS":"A","title":"a", "content":"液温は95Cを限度とし、洗濯機で洗濯ができる"],
        ["JIS":"","title":"b", "content":"液温は70Cを限度とし、洗濯機で洗濯ができる"],
        ["JIS":"B","title":"c", "content":"液温は60Cを限度とし、洗濯機で洗濯ができる"],
        ["JIS":"","title":"d", "content":"液温は60Cを限度とし、洗濯機で弱い洗濯ができる"],
        ["JIS":"","title":"e", "content":"液温は50Cを限度とし、洗濯機で洗濯ができる"],
        ["JIS":"","title":"f", "content":"液温は50Cを限度とし、洗濯機で弱い洗濯ができる"],
        ["JIS":"C","title":"g", "content":"液温は40Cを限度とし、洗濯機で洗濯ができる"],
        ["JIS":"D","title":"h", "content":"液温は40Cを限度とし、洗濯機で弱い洗濯ができる"],
        ["JIS":"","title":"i", "content":"液温は40Cを限度とし、洗濯機で非常に弱い洗濯ができる"],
        ["JIS":"","title":"j", "content":"液温は30Cを限度とし、洗濯機で洗濯ができる"],
        /*["JIS":"E","title":"k", "content":"液温は30Cを限度とし、洗濯機で弱い洗濯ができる"],
        ["JIS":"","title":"l", "content":"液温は30Cを限度とし、洗濯機で非常に弱い洗濯ができる"],
        ["JIS":"F","title":"m", "content":"液温は40Cを限度とし、手洗いができる"],
        ["JIS":"G","title":"n", "content":"家庭での洗濯禁止"],
        ["JIS":"L","title":"o", "content":"塩素系及び酸素系の漂白剤を使用して漂白ができる"],
        ["JIS":"","title":"p", "content":"酸素系漂白剤の使用はできるが、塩素系漂白剤は使用禁止"],
        ["JIS":"M","title":"q", "content":"塩素系及び酸素系漂白剤の使用禁止"],
        ["JIS":"","title":"r", "content":"タンブル乾燥ができる(排気温度上限80C)"],
        ["JIS":"","title":"s", "content":"低い温度でのタンブル乾燥ができる(排気温度上限60C)"],
        ["JIS":"","title":"t", "content":"タンブル乾燥禁止"],
        ["JIS":"N","title":"u", "content":"つり干しがよい"],
        ["JIS":"","title":"v", "content":"ぬれつり干しがよい"],
        ["JIS":"P","title":"w", "content":"平干しがよい"],
        ["JIS":"","title":"x", "content":"ぬれ平干しがよい"],
        ["JIS":"O","title":"y", "content":"日陰のつり干しがよい"],
        ["JIS":"","title":"z", "content":"日陰のぬれつり干しがよい"],
        ["JIS":"Q","title":"A", "content":"日陰の平干しがよい"],
        ["JIS":"","title":"B", "content":"日陰のぬれ平干しがよい"],
        ["JIS":"a","title":"C", "content":"底面温度200を限度としてアイロン仕上げができる"],
        ["JIS":"b","title":"D", "content":"底面温度150Cを限度としてアイロン仕上げができる"],
        ["JIS":"c","title":"E", "content":"底面温度110Cを限度としてアイロン仕上げができる"],
        ["JIS":"d","title":"F", "content":"アイロン仕上げ禁止"],
        ["JIS":"h","title":"G", "content":"パークロロエチレン及び石油系溶剤によるドライクリーニングができる"],
        ["JIS":"","title":"H", "content":"パークロロエチレン及び石油系溶剤による弱いドライクリーニングができる"],
        ["JIS":"i","title":"I", "content":"石油系溶剤によるドライクリーニングができる"],
        ["JIS":"","title":"J", "content":"石油系溶剤による弱いドライクリーニングができる"],
        ["JIS":"j","title":"K", "content":"ドライクリーニング禁止"],
        ["JIS":"","title":"L", "content":"ウエットクリーニングができる"],
        ["JIS":"","title":"M", "content":"弱い操作によるウエットクリーニングができる"],
        ["JIS":"","title":"N", "content":"非常に弱い操作によるウエットクリーニングができる"],
        ["JIS":"","title":"O", "content":"ウェットクリーニング禁止"],
        ["JIS":"k","title":"", "content":"手絞りの場合は弱く、遠心脱水の場合は、短時間で絞るのがよい"],
        ["JIS":"l","title":"", "content":"絞ってはいけない"]*/
    ]
   // let JIS = ["A","","B","C","D","E","F","G","H","I","J","K","L","M","a","b","c","d","e","f","g","h","i","j","k","l","N","O","P","Q"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "TagTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TagTableViewCell
        
        cell.newJISLabel.text = arrayData[indexPath.row]["title"]
        cell.descLabel.text = arrayData[indexPath.row]["content"]
        cell.JISLabel.text = arrayData[indexPath.row]["JIS"]
        
        
        
        
        return cell
        
        
    }
    
    
    
    
}
