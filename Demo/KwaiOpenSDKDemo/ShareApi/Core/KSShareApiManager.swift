//
//  KSShareApiManager.swift
//  KwaiOpenSDKDemo
//
//  Created by MingBo Gao on 2020/4/15.
//  Copyright © 2020 MingBo Gao. All rights reserved.
//

import Foundation

let targetOpenId = ""
let myOpenId = ""

class KSShareApiManager: NSObject {
    static let shared = KSShareApiManager()
    weak var viewController:UIViewController?
    
    func auth() {
        self.send(KSShareApiAuthManager.authRequest(on: self.viewController))
//        self.send(KSShareApiAuthManager.authRequest(on: nil))
    }
    
    func message() {
        self.send(KSShareApiMessageManager.messageRequestTo(receiver: nil, myId: myOpenId))
    }
    
    func messageWithTarget() {
        self.send(KSShareApiMessageManager.messageRequestTo(receiver: targetOpenId, myId: myOpenId))
    }
    
    func profile() {
        self.send(KSShareApiProfileManager.profileRequestTo(target: targetOpenId))
    }
    
    private func send(_ request:KSBaseRequest?) {
        guard let request = request else {
            return
        }
        KSApi.send(request) {
            print("sending request" + ($0 ? "succeed" : "failed"))
        }
    }
}

extension KSShareApiManager: KSApiDelegate {
    func ksApiDidReceive(_ response: KSBaseResponse) {
        print(response.error)
    }
}
