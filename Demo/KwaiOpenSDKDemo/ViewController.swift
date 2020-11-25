//
//  ViewController.swift
//  KwaiOpenSDKDemo
//
//  Created by MingBo Gao on 2020/4/15.
//  Copyright © 2020 MingBo Gao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var sdkVersionLable: UILabel!
    @IBOutlet weak var appIdLabel: UILabel!
    @IBOutlet weak var universalLinkLabel: UILabel!
    @IBOutlet weak var bundleIdLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    private func setupViews() {
        self.sdkVersionLable.text = KSApi.apiVersion()
        self.appIdLabel.text = KSConfigCenter.appId
        self.universalLinkLabel.text = KSConfigCenter.universalLink
        self.bundleIdLabel.text = Bundle.main.bundleIdentifier
    }

    @IBAction func authButton(_ sender: Any) {
        KSShareApiManager.shared.viewController = self
        KSShareApiManager.shared.auth()
    }
    
    @IBAction func messageTapped(_ sender: Any) {
        KSShareApiManager.shared.message()
    }
    
    @IBAction func messageWithTargetTapped(_ sender: Any) {
        KSShareApiManager.shared.messageWithTarget()
    }
    
    @IBAction func jumpProfileTapped(_ sender: Any) {
        KSShareApiManager.shared.profile()
    }
    
    @IBAction func exportSettingTapped(_ sender: Any) {
        var params: [String : Any] = [:]
        params["sdkVersion"] = KSApi.apiVersion()
        params["appId"] = KSConfigCenter.appId
        params["universalLinks"] = KSConfigCenter.universalLink
        params["bundleId"] = Bundle.main.bundleIdentifier
        params["QueriesSchemes"] = Bundle.main.infoDictionary!["LSApplicationQueriesSchemes"]
        UIPasteboard.general.string = "\(params)"
    }
}

