//
//  KSOpenApiManager+Message.m
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import "KSOpenApiManager+Message.h"
#import "KSOpenApiManager+Utils.h"

@implementation KSOpenApiManager (Message)

- (void)shareMesssageTo:(NSString *)receiverOpenID
                  title:(NSString *)title
                   desc:(NSString *)desc
                   link:(NSString *)link
             thumbImage:(NSData *)imageData
              extraInfo:(NSDictionary *)info {
    
    KSShareWebPageObject *shareObject = [[KSShareWebPageObject alloc] init];
    shareObject.title = title;
    shareObject.desc = desc;
    shareObject.linkURL = link;
    shareObject.thumbImage = imageData;
    
    KSShareMessageRequest *req = [[KSShareMessageRequest alloc] init];
    req.applicationList = [self.applicationList copy];
    req.shareScene = KSShareScopeSession;
    req.shareObject = shareObject;
    //NOTE: receiverOpenID为空时, 快手会显示好友列表请用户选择
    //NOTE: receiverOpenID为@""时, 会调用异常, 请注意区别
    req.receiverOpenID = receiverOpenID;
    if (req.receiverOpenID) {
        //NOTE: 如果指定了receiverOpenID，那么openID为空会报错
        //NOTE: 因为在指定接收用户的场景下，需要发送方的id去校验用户关系
        req.openID = [self selfOpenID];
    }
    req.state = @"test share state";
    
    __weak __typeof(self) ws = self;
    [KSApi sendRequest:req completion:^(BOOL success) {
        __strong __typeof(ws) ss = ws;
        [ss logFormat:@"%s success: %@", __func__, success ? @"YES" : @"NO"];
    }];
}

@end
