//
//  TagViewController.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/09.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class TagViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate  {

    
    @IBOutlet weak var tableView: UITableView!
    let tag = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        // "Cell" はストーリーボードで設定したセルのID
        let testCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                               for: indexPath)
       
      
        let label = testCell.contentView.viewWithTag(1) as! UILabel
        
        //label.font = UIFont(name: "ISOsymbol", size: 17.0)
        label.textColor = UIColor.red
        label.text = tag[indexPath.row]
        //label.backgroundColor = UIColor.red
        
       
        
        return testCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // section数は１つ
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // 要素数を入れる、要素以上の数字を入れると表示でエラーとなる
        return tag.count
    }
    
    


}
