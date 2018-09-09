//
//  ViewController.swift
//  FireUI
//
//  Created by hao yin on 2018/9/6.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let v = StackView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0 ..< 3 {
            let k = ItemView(width: 100, height: 0)
            k.grow = UInt(i + 1);
            let r = CGFloat(arc4random() % 1000) / 1000
            let g = CGFloat(arc4random() % 1000) / 1000
            let b = CGFloat(arc4random() % 1000) / 1000
            k.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
            self.view.addSubview(k)
        }
        
    }
}
