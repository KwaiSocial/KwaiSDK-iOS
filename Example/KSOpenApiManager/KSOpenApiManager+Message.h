//
//  KSOpenApiManager+Message.h
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSOpenApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSOpenApiManager (Message)

- (void)shareMesssageTo:(NSString *)receiverOpenID
                  title:(NSString *)title
                   desc:(NSString *)desc
                   link:(NSString *)link
             thumbImage:(NSData *)imageData
              extraInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
