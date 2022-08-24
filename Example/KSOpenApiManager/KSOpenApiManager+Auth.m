//
//  KSOpenApiManager+Auth.m
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import "KSOpenApiManager+Auth.h"
#import "KSOpenApiManager+Utils.h"

@implementation KSOpenApiManager (Auth)

- (void)loginWithoutH5 {
    KSAuthRequest *req = [[KSAuthRequest alloc] init];
    req.scope = @"user_info";
    req.applicationList = [self.applicationList copy];
    
    __weak __typeof(self) ws = self;
    [KSApi sendRequest:req completion:^(BOOL success) {
        __strong __typeof(ws) ss = ws;
        [ss logFormat:@"%s success: %@", __func__, success ? @"YES" : @"NO"];
    }];
}

- (void)loginWithH5Container:(UIViewController *)h5Controller {
    KSAuthRequest *req = [[KSAuthRequest alloc] init];
    req.scope = @"user_info";
    req.applicationList = [self.applicationList copy];
    req.h5AuthViewController = h5Controller;
    
    __weak __typeof(self) ws = self;
    [KSApi sendRequest:req completion:^(BOOL success) {
        __strong __typeof(ws) ss = ws;
        [ss logFormat:@"%s success: %@", __func__, success ? @"YES" : @"NO"];
    }];
}

- (void)cleanLoginInfo {
    if (!self.universalLink || !self.appId) {
        return;
    }
    NSString *urlString = [NSString pathWithComponents:@[self.universalLink, self.appId, @"share_media?result=100200112&message=Invalid%2520universalLink&errorDomain=-5000"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:NSUserActivityTypeBrowsingWeb];
    activity.webpageURL = url;
    [KSApi handleOpenUniversalLink:activity];
}

@end
