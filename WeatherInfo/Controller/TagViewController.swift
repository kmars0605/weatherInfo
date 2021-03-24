//
//  TagViewController.swift
//  WeatherInfo
//
//  Created by 伊藤光次郎 on 2020/10/19.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class TagViewController: UIViewController{
    
    @IBOutlet var tagView: TagView!
    let tag = Tag()
    override func viewDidLoad() {
        super.viewDidLoad()
        tagView.setView(tag: tag)
    }
}
