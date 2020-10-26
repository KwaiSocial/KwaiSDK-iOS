//
//  KSShareApiMeidaViewController.swift
//  KwaiOpenSDKDemo
//
//  Created by MingBo Gao on 2020/5/14.
//  Copyright © 2020 MingBo Gao. All rights reserved.
//

class KSShareApiMeidaViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            self.view.backgroundColor = .white
        }
    }
}



