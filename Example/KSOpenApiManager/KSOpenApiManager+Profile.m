//
//  KSOpenApiManager+Profile.m
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//
//  具体使用说明: https://open.kuaishou.com/platform/openApi?menu=10

#import "KSOpenApiManager+Profile.h"
#import "KSOpenApiManager+Utils.h"

@implementation KSOpenApiManager (Profile)

- (void)showProfile:(NSString *)targetOpenId {
    KSShowProfileRequest *req = [[KSShowProfileRequest alloc] init];
    req.applicationList = [self.applicationList copy];
    req.targetOpenID = targetOpenId;
    req.state = @"test profile state";
    __weak __typeof(self) ws = self;
    [KSApi sendRequest:req completion:^(BOOL success) {
        __strong __typeof(ws) ss = ws;
        [ss logFormat:@"%s success: %@", __func__, success ? @"YES" : @"NO"];
    }];
}

@end
