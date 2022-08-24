//
//  KSOpenApiManager+Utils.m
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import "KSOpenApiManager+Utils.h"

@implementation KSOpenApiManager (Utils)

#pragma mark - Log

- (void)log:(NSObject *)logObj {
    // TODO: 替换成您自己的实际处理，输出到您的日志系统
    self.logBlock ? self.logBlock(logObj) : nil;
}

- (void)logFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *customMessage = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self log:customMessage];
}

#pragma mark - Demo: change appId

- (NSString *)readAppId {
    NSString *appId = [[NSUserDefaults standardUserDefaults] stringForKey:@"fake_appId"];
    if (appId.length == 0) {
        appId = kKSAppIdRelease;
    }
    return appId;
}

- (void)saveAppId:(NSString *)appId {
    [[NSUserDefaults standardUserDefaults] setObject:appId forKey:@"fake_appId"];
}


#pragma mark - Demo: fetch openId
// NOTE: 获得openId应该由服务器端实现,请参照https://open.kuaishou.com/platform/openApi?menu=55
// NOTE: 此函数仅为演示及快速测试Demo功能，线上请勿将appSecret存储于客户端
- (void)getOpenIDFromCode:(NSString *)code completion:(void(^)(NSString *, NSError *))completion {
    NSString *appSecret = @"";
    
    if (!code || code.length == 0) {
        NSError *error = [NSError errorWithDomain:NSArgumentDomain code:-1 userInfo:@{
            NSLocalizedDescriptionKey: @"code is nil"
        }];
        completion ? completion(nil, error): nil;
        return;
    }
    NSString *appId = [self appId];
    

    if (appSecret.length == 0) {
        NSError *error = [NSError errorWithDomain:NSArgumentDomain code:-1 userInfo:@{
            NSLocalizedDescriptionKey: @"appSecret is nil"
        }];
        completion ? completion(nil, error): nil;
        return;
    } else {
        [self logFormat:@"%s 仅限演示, appSecret请妥善保存", __func__];
    }
    
    // https://open.kuaishou.com/platform/openApi?menu=13
    NSString *urlString = [NSString stringWithFormat:
                           @"https://open.kuaishou.com/oauth2/access_token?grant_type=code&app_id=%@&app_secret=%@&code=%@",
                           appId, appSecret, code];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *openId = nil;
        if (((NSHTTPURLResponse *)response).statusCode == 200){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (json[@"open_id"]){
                openId = json[@"open_id"];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion ? completion(openId, error): nil;
        });
    }];
    [dataTask resume];
}

@end


