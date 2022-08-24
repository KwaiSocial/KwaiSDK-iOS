//
//  KSOpenApiManager.m
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//
// 快手文档: https://open.kuaishou.com/platform/openApi?menu=9

#import "KSOpenApiManager.h"
#import "KSOpenApiManager+Utils.h"

// TODO: 按您网站注册信息,进行配置
NSString *const kKSAppIdTest = @"ks*******";
NSString *const kKSAppIdRelease = @"ks******";
NSString *const kKSUniversalLink = @"****网站注册时, 相同的universal link, 以/结尾****";

#pragma mark -

@interface KSOpenApiManager () <KSApiDelegate, KwaiSDKLogDelegate>

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *universalLink;

@end

@implementation KSOpenApiManager

+ (instancetype)shared {
    static KSOpenApiManager *gIns = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gIns = [[KSOpenApiManager alloc] init];
    });
    return gIns;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // TODO: 按需修改
        _appId = [self readAppId];
        _universalLink = kKSUniversalLink;
        _applicationList = [@[] mutableCopy]; //!< 为空时,目标应用仅为快手
       // 目标应用为快手或快手极速版
//        _applicationList = [@[@(KSApiApplication_Kwai), @(KSApiApplication_KwaiLite)] mutableCopy];
    }
    return self;
}

- (void)registerKwaiOpenSDK {
    // TODO: 请按文档检查工程配置 https://open.kuaishou.com/platform/openApi?menu=9
    [KSApi startLogByLevel:KwaiSDKLogLevelDetail logDelegate:self];
    [KSApi registerApp:self.appId universalLink:self.universalLink delegate:self];
}

#pragma mark - 快手回调入口

- (BOOL)handleUserActivity:(nonnull NSUserActivity *)userActivity {
    // 处理Universal link方式回调
    // NOTE: 请配置Associated Domains 添加applinks: **您的apple-app-site-association文件所在域名**
    // NOTE: 可用备忘录点击链接, 测试是否可跳转成功
    /// 苹果Universal Link官方文档: https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW1
 
    [self log:userActivity.webpageURL];
    return [KSApi handleOpenUniversalLink:userActivity];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    // Scheme方式回调, Universal link方式失败时
    // NOTE: 请配置Info.plist URL Types字段, 支持被调起
    // NOTE: 请配置Info.plist LSApplicationQueriesSchemes字段，支持调起快手
    [self log:url];
    return [KSApi handleOpenURL:url];
}

#pragma mark -- KSApiDelegate

- (void)ksApiDidReceiveResponse:(__kindof KSBaseResponse *)response {
    // SDK最终结果
    if ([response isKindOfClass:[KSAuthResponse class]]){
        KSAuthResponse *authResponse = (KSAuthResponse *)response;
        NSString *log = [NSString stringWithFormat:@"auth code: %@ state: %@ errorCode: %@ msg: %@",
                         authResponse.code, authResponse.state, @(authResponse.error.code), response.error.localizedDescription];
        [self log:log];
        
        // TODO: 替换成您自己的实际处理
        self.loginBlock ? self.loginBlock(authResponse.code, authResponse.error): nil;
    } else {
        
        NSString *log = [NSString stringWithFormat:@"responseType:%@, errorCode:%d state: %@ msg: %@", [response.class description],
                         (int)response.error.code, response.state, response.error.localizedDescription];
        [self log:log];
        
        // TODO: 替换成您自己的实际处理
        self.actionBlock ? self.actionBlock(response.state, response.error): nil;
    }
}

#pragma mark - KwaiSDKLogDelegate

- (void)onLog:(NSString*)log logLevel:(KwaiSDKLogLevel)level {
    [self logFormat:@"[%@] %@", level == KwaiSDKLogLevelNormal ? @"N" : @"D", log];
}

- (void)onStatistics:(NSString*)key value:(NSString *)value {
    [self logFormat:@"[Stat] %@:%@", key, value];
}

@end
