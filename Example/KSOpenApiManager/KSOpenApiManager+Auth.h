//
//  KSOpenApiManager+Auth.h
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//
//  具体使用说明: https://open.kuaishou.com/platform/openApi?menu=10

#import <Foundation/Foundation.h>
#import "KSOpenApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSOpenApiManager (Auth)

- (void)loginWithoutH5;
- (void)loginWithH5Container:(UIViewController *)h5Controller;

- (void)cleanLoginInfo;

@end

NS_ASSUME_NONNULL_END
