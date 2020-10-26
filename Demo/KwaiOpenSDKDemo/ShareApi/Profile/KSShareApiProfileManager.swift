//
//  KSShareApiProfileManager.swift
//  KwaiOpenSDKDemo
//
//  Created by MingBo Gao on 2020/5/14.
//  Copyright © 2020 MingBo Gao. All rights reserved.
//

import Foundation

class KSShareApiProfileManager {
    static func profileRequestTo(target openId: String) -> KSBaseRequest {
        let request = KSShowProfileRequest()
        request.targetOpenID = openId
        return request
    }
}

