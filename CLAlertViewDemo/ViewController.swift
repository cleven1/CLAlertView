//
//  ViewController.swift
//  CLAlertViewDemo
//
//  Created by cleven on 2020/2/19.
//  Copyright © 2020 cleven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let alertView = CLAlertView(title: "标题", message: "内容")
        CLAlertManager.show(view: alertView)
    }

}

