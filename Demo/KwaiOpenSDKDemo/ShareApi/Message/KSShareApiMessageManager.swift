//
//  KSShareApiMessageManager.swift
//  KwaiOpenSDKDemo
//
//  Created by MingBo Gao on 2020/5/14.
//  Copyright © 2020 MingBo Gao. All rights reserved.
//

import Foundation

class KSShareApiMessageManager {
    private static let shareObject: KSShareWebPageObject = {
        let object = KSShareWebPageObject()
        object.title = "其实我是title"
        object.desc = "其实我的desc"
        object.linkURL = "https://www.kuaishou.com/"
        return object
    }()
    
    static func messageRequestTo(receiver id:String?, myId:String?) -> KSBaseRequest {
        let request = KSShareMessageRequest()
        request.shareObject = self.shareObject
        request.receiverOpenID = id
        request.openID = myId
        request.shareScene = .scopeSession
        return request
    }
}
