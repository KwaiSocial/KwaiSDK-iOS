//
//  KSOpenApiManager+Utils.h
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSOpenApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSOpenApiManager (Utils)

// Log输出
- (void)log:(NSObject *)logObj;
- (void)logFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

// Demo功能: 切换AppId
- (NSString *)readAppId;
- (void)saveAppId:(NSString *)appId;

// Demo功能: 演示如何从code中获得openId
- (void)getOpenIDFromCode:(NSString *)code completion:(void(^)(NSString *, NSError *))completion;


@end

NS_ASSUME_NONNULL_END
