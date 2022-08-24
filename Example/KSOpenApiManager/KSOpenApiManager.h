//
//  KSOpenApiManager.h
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KwaiSDK/KSApi.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kKSAppIdTest;
FOUNDATION_EXPORT NSString *const kKSAppIdRelease;

typedef void(^DidLoginBlock)(NSString *code, NSError *error);
typedef void(^ActionCallbackBlock)(NSString *state, NSError *error);
typedef void(^LogBlock)(NSObject *log);

@interface KSOpenApiManager : NSObject

@property (nonatomic, copy, readonly) NSString *appId;
@property (nonatomic, copy, readonly) NSString *universalLink;

@property (nonatomic, strong) NSMutableArray *applicationList;
@property (nonatomic, copy) NSString *selfOpenID;

// NOTE: Demo UI显示使用, 请更新成自身操作
@property (nonatomic, copy) DidLoginBlock loginBlock;
@property (nonatomic, copy) ActionCallbackBlock actionBlock;
@property (nonatomic, copy) LogBlock logBlock;

+ (instancetype)shared;

- (void)registerKwaiOpenSDK;

- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)handleUserActivity:(nonnull NSUserActivity *)userActivity;

@end

NS_ASSUME_NONNULL_END
