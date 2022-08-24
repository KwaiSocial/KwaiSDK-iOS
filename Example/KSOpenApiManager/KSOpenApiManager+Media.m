//
//  KSOpenApiManager+Media.m
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import "KSOpenApiManager+Media.h"
#import "KSOpenApiManager+Utils.h"
#import <objc/runtime.h>

@implementation KSOpenApiManager (Media)

- (void)shareFeature:(KSShareMediaFeature)feature
          shareItems:(NSArray<KSShareMediaAsset *> *)shareItems
           thumbnail:(KSShareMediaAsset *)thumbnail
                tags:(NSArray<NSString *> *)tags
         extraEntity:(NSDictionary *)extraEntity
     disableFallback:(BOOL)disableFallback
          completion:(void(^)(BOOL))completion {
       
    KSShareMediaObject *mediaItem = [[KSShareMediaObject alloc] init];
    //建议为NO, 即执行兜底逻辑，无相关发布权限时进入预裁剪页
    mediaItem.disableFallback = disableFallback;
    mediaItem.extraEntity = extraEntity;
    mediaItem.tags = tags;
    
    mediaItem.coverAsset = thumbnail;
    mediaItem.multipartAssets = shareItems;
        
    KSShareMediaRequest *request = [[KSShareMediaRequest alloc] init];
    request.applicationList = [self.applicationList copy];
    request.mediaFeature = feature;
    request.mediaObject = mediaItem;
    __weak __typeof(self) ws = self;
    [KSApi sendRequest:request completion:^(BOOL success) {
        __strong __typeof(ws) ss = ws;
        [ss logFormat:@"%s success: %@", __func__, success ? @"YES" : @"NO"];
        completion ? completion(success) : nil;
    }];
}

@end

@implementation KSShareMedia

- (instancetype)init {
    self = [super init];
    if (self) {
        _disableFallback = NO;
        _assets = [NSMutableArray arrayWithCapacity:10];
        _tags = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)share:(void(^)(BOOL))completion {
    if (self.assets.count == 0) {
        [[KSOpenApiManager shared] logFormat:@"%s assets count is 0", __func__];
        completion ? completion(NO) : nil;
        return;
    }
    if (self.thumbnail && self.thumbnail.mediaType != PHAssetMediaTypeImage) {
        [[KSOpenApiManager shared] logFormat:@"%s thumbnail mediaType isn't image", __func__];
        completion ? completion(NO) : nil;
        return;
    }
    
    NSMutableArray<KSShareMediaAsset *> *shareItems = [NSMutableArray arrayWithCapacity:self.assets.count];
    for (PHAsset *asset in self.assets) {
        NSString *assetId = asset.localIdentifier;
        BOOL isImage = asset.mediaType == PHAssetMediaTypeImage;
        [shareItems addObject:[KSShareMediaAsset assetForPhotoLibrary:assetId isImage:isImage]];
    }
    KSShareMediaAsset *thumbnailItem = [KSShareMediaAsset assetForPhotoLibrary:self.thumbnail.localIdentifier isImage:YES];

    [[KSOpenApiManager shared] shareFeature:self.feature
                                 shareItems:shareItems
                                  thumbnail:thumbnailItem
                                       tags:self.tags
                                extraEntity:self.extraEntity
                            disableFallback:self.disableFallback
                                 completion:completion];
}

#pragma mark -

- (BOOL)firstAssetIsImage {
    return self.assets.firstObject.mediaType == PHAssetMediaTypeImage;
}

@end

