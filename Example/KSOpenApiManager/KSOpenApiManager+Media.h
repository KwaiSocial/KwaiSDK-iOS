//
//  KSOpenApiManager+Media.h
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//
//  具体使用说明: https://open.kuaishou.com/platform/openApi?menu=10
//  NOTE: 需要Info.plist添加键值NSPhotoLibraryUsageDescription

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#import "KSOpenApiManager.h"
#import <KwaiSDK/KSApiObject.h>

NS_ASSUME_NONNULL_BEGIN

@class KSShareMedia;

@interface KSOpenApiManager (Media)

- (void)shareMedia:(KSShareMedia *)shareMedia
        shareItems:(NSArray<KSShareMediaAsset *> *)shareItems
         thumbnail:(KSShareMediaAsset *)thumbnail
        completion:(void(^)(BOOL))completion;

@end

#pragma mark -

@interface KSShareMedia : NSObject
@property (nonatomic, assign) KSShareMediaFeature feature;
@property (nonatomic, assign) BOOL disableFallback;

@property (nonatomic, copy) PHAsset *thumbnail;
@property (nonatomic, copy) NSArray<PHAsset*> *assets;

// NOTE: 首次测试不要填充, 涉及权限，有可能失败
@property (nonatomic, strong) NSMutableArray<NSString *> *tags;
@property (nonatomic, strong) NSMutableDictionary *extraEntity;

@property (nonatomic, assign) KSMediaAssociateType associateType;
@property (nonatomic, strong) KSMediaAssociateObject *associateObject;

- (void)share:(void(^)(BOOL))completion;

#pragma mark -

- (BOOL)firstAssetIsImage;

@end

NS_ASSUME_NONNULL_END
