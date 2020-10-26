//
//  KSShareApiAuthManager.swift
//  KwaiOpenSDKDemo
//
//  Created by MingBo Gao on 2020/4/15.
//  Copyright © 2020 MingBo Gao. All rights reserved.
//

import Foundation


class KSShareApiAuthManager {
    private static let authRequest: KSAuthRequest = {
        let request = KSAuthRequest()
        request.scope = "user_info"
//        request.h5AuthViewController = appl
        return request
    }()
    
    static func authRequest(on viewController: UIViewController?) -> KSBaseRequest? {
        self.authRequest.h5AuthViewController = viewController
        return self.authRequest
    }
}
