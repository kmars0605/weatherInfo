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
    
    let arrayData1 =  [
        ["JIS":"A","title":"a", "content":"液温は95℃を限度とし、洗濯機で洗濯ができる"],
        ["JIS":"","title":"b", "content":"液温は70℃を限度とし、洗濯機で洗濯ができる"],
        ["JIS":"B","title":"c", "content":"液温は60℃を限度とし、洗濯機で洗濯ができる"],
        ["JIS":"","title":"d", "content":"液温は60℃を限度とし、洗濯機で弱い洗濯ができる"],
        ["JIS":"","title":"e", "content":"液温は50℃を限度とし、洗濯機で洗濯ができる"],
        ["JIS":"","title":"f", "content":"液温は50℃を限度とし、洗濯機で弱い洗濯ができる"],
        ["JIS":"C","title":"g", "content":"液温は40℃を限度とし、洗濯機で洗濯ができる"],
        ["JIS":"D","title":"h", "content":"液温は40℃を限度とし、洗濯機で弱い洗濯ができる"],
        ["JIS":"","title":"i", "content":"液温は40℃を限度とし、洗濯機で非常に弱い洗濯ができる"],
        ["JIS":"","title":"j", "content":"液温は30℃を限度とし、洗濯機で洗濯ができる"],
        ["JIS":"E","title":"k", "content":"液温は30℃を限度とし、洗濯機で弱い洗濯ができる"],
        ["JIS":"","title":"l", "content":"液温は30℃を限度とし、洗濯機で非常に弱い洗濯ができる"],
        ["JIS":"F","title":"m", "content":"液温は40℃を限度とし、手洗いができる"],
        ["JIS":"G","title":"n", "content":"家庭での洗濯禁止"]
    ]
    let arrayData2 = [
        ["JIS":"L","title":"o", "content":"塩素系及び酸素系の漂白剤を使用して漂白ができる"],
        ["JIS":"","title":"p", "content":"酸素系漂白剤の使用はできるが、塩素系漂白剤は使用禁止"],
        ["JIS":"M","title":"q", "content":"塩素系及び酸素系漂白剤の使用禁止"]
    ]
    
    let arrayData3 = [
        ["JIS":"","title":"r", "content":"タンブル乾燥ができる(排気温度上限80C)"],
        ["JIS":"","title":"s", "content":"低い温度でのタンブル乾燥ができる(排気温度上限60C)"],
        ["JIS":"","title":"t", "content":"タンブル乾燥禁止"]
    ]
    
    let arrayData4 = [
        ["JIS":"N","title":"u", "content":"つり干しがよい"],
        ["JIS":"","title":"v", "content":"ぬれつり干しがよい"],
        ["JIS":"P","title":"w", "content":"平干しがよい"],
        ["JIS":"","title":"x", "content":"ぬれ平干しがよい"],
        ["JIS":"O","title":"y", "content":"日陰のつり干しがよい"],
        ["JIS":"","title":"z", "content":"日陰のぬれつり干しがよい"],
        ["JIS":"Q","title":"A", "content":"日陰の平干しがよい"],
        ["JIS":"","title":"B", "content":"日陰のぬれ平干しがよい"]
    ]
    
    let arrayData5 = [
        ["JIS":"a","title":"C", "content":"底面温度200℃を限度としてアイロン仕上げができる"],
        ["JIS":"b","title":"D", "content":"底面温度150℃を限度としてアイロン仕上げができる"],
        ["JIS":"c","title":"E", "content":"底面温度110℃を限度としてアイロン仕上げができる"],
        ["JIS":"d","title":"F", "content":"アイロン仕上げ禁止"]
    ]
    
    let arrayData6 = [
        ["JIS":"h","title":"G", "content":"パークロロエチレン及び石油系溶剤によるドライクリーニングができる"],
        ["JIS":"","title":"H", "content":"パークロロエチレン及び石油系溶剤による弱いドライクリーニングができる"],
        ["JIS":"i","title":"I", "content":"石油系溶剤によるドライクリーニングができる"],
        ["JIS":"","title":"J", "content":"石油系溶剤による弱いドライクリーニングができる"],
        ["JIS":"j","title":"K", "content":"ドライクリーニング禁止"],
        ["JIS":"","title":"L", "content":"ウエットクリーニングができる"],
        ["JIS":"","title":"M", "content":"弱い操作によるウエットクリーニングができる"],
        ["JIS":"","title":"N", "content":"非常に弱い操作によるウエットクリーニングができる"],
        ["JIS":"","title":"O", "content":"ウェットクリーニング禁止"]
    ]
    
    let arrayData7 = [
        ["JIS":"k","title":"", "content":"手絞りの場合は弱く、遠心脱水の場合は、短時間で絞るのがよい"],
        ["JIS":"l","title":"", "content":"絞ってはいけない"]
    ]
    
    let sectionTitle = ["洗濯処理","漂白処理","タンブル乾燥","自然乾燥","アイロン仕上げ","クリーニング","絞り方"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "TagTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
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
        else if section == 2 {
            return arrayData3.count
        }
        else if section == 3 {
            return arrayData4.count
        }
        else if section == 4 {
            return arrayData5.count
        }
        else if section == 5 {
            return arrayData6.count
        }
        else if section == 6 {
            return arrayData7.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TagTableViewCell
        
        if indexPath.section == 0{
            cell.newJISLabel.text = arrayData1[indexPath.row]["title"]
            cell.descLabel.text = arrayData1[indexPath.row]["content"]
            cell.JISLabel.text = arrayData1[indexPath.row]["JIS"]
        }else if indexPath.section == 1{
            cell.newJISLabel.text = arrayData2[indexPath.row]["title"]
            cell.descLabel.text = arrayData2[indexPath.row]["content"]
            cell.JISLabel.text = arrayData2[indexPath.row]["JIS"]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitle[section]
    }
}
