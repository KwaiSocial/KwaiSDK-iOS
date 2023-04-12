//
//  KSMediaViewController.m
//  KSSDKShareKit
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import "KSMediaViewController.h"
#import "CTAssetsPickerController.h"
#import "KSOpenApiManager+Media.h"

#define kChooseResource                (100000001)
#define kChooseThumbnail               (100000002)

@interface ExtendAssetsPickerController:CTAssetsPickerController

@property (nonatomic, assign) NSInteger tag;

@end

@implementation ExtendAssetsPickerController

@end

#pragma mark -

@interface KSMediaViewController () <CTAssetsPickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *currentChooseLabel;
@property (nonatomic, weak) IBOutlet UILabel *tagsLabel;

@property (nonatomic, weak) IBOutlet UIButton *resourceButton;
@property (nonatomic, weak) IBOutlet UIButton *chooseThumbnail;
@property (nonatomic, weak) IBOutlet UIButton *tagsButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;

@property (nonatomic, weak) IBOutlet UISwitch *disableFallbackSwitch;
@property (nonatomic, weak) IBOutlet UIButton *associateButton;

@property (nonatomic, strong) KSShareMedia *shareMedia;

@end

@implementation KSMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareMedia = [[KSShareMedia alloc] init];
    [self updateChooseState];
}

- (IBAction)didTouchChooseFeatureStep {
    [self showActionSheet:@"请选择跳转页面"
                  message:nil
            cancelHandler:^(UIAlertAction *action) {
        self.shareMedia.feature = KSShareMediaFeature_Undefine;
        [self updateChooseState];
    } actions:
     @{
       @"图片编辑页":^(UIAlertAction *action) {
        self.shareMedia.feature  = KSShareMediaFeature_PictureEdit;
        [self updateChooseState];
    },
       @"单视频编辑页":^(UIAlertAction *action) {
        self.shareMedia.feature  = KSShareMediaFeature_VideoEdit;
        [self updateChooseState];
    },
       @"裁剪页(支持多视频)":^(UIAlertAction *action) {
        self.shareMedia.feature  = KSShareMediaFeature_Preprocess;
        [self updateChooseState];
    },
       @"单视频发布页":^(UIAlertAction *action) {
        self.shareMedia.feature  = KSShareMediaFeature_VideoPublish;
        [self updateChooseState];
    },
       @"智能剪裁":^(UIAlertAction *action) {
        self.shareMedia.feature  = KSShareMediaFeature_AICut;
        [self updateChooseState];
    },
     }];
}

- (IBAction)didTouchChooseResourceStep {
    // 判断是否支持当前类型分享
    if (![KSApi isAppInstalledFor:KSApiApplication_Kwai]) {
        [self showAlert:@"提示"
                message:@"未安装快手"
          cancelHandler:^(UIAlertAction *action) {
        } actions:nil];
        return;
    }
    
    __weak __typeof(self) ws = self;
    [self showActionSheet:@"请选择获取素材方式"
                  message:nil
            cancelHandler:^(UIAlertAction *action) {
    } actions:@{
       @"相册":^(UIAlertAction *action) {
         __strong __typeof(ws) ss = ws;
         ExtendAssetsPickerController *browser = [[ExtendAssetsPickerController alloc] init];
         browser.tag = kChooseResource;
         browser.delegate = ss;
         [ss presentViewController:browser animated:YES completion:nil];
      }
    }];
    
    CTAssetsPickerController *browser = [[CTAssetsPickerController alloc] init];
    browser.delegate = self;
    browser.showsSelectionIndex = YES;
    [self presentViewController:browser animated:YES completion:nil];
}

- (IBAction)didTouchChooseThumbnail:(id)sender {
    __weak __typeof(self) ws = self;
    [self showActionSheet:@"请选择获取封面的方式"
                  message:nil
            cancelHandler:^(UIAlertAction *action) {
    } actions:@{
       @"相册":^(UIAlertAction *action) {
          __strong __typeof(ws) ss = ws;
          ExtendAssetsPickerController *browser = [[ExtendAssetsPickerController alloc] init];
          browser.tag = kChooseThumbnail;
          browser.delegate = ss;
          [ss presentViewController:browser animated:YES completion:nil];
       }
    }];
    
    CTAssetsPickerController *browser = [[CTAssetsPickerController alloc] init];
    browser.delegate = self;
    browser.showsSelectionIndex = YES;
    [self presentViewController:browser animated:YES completion:nil];
}

- (IBAction)didTouchManageTagsStep {
    __weak __typeof(self) ws = self;
    __block UITextField *lastTextField = nil;
    void (^addBlock)(UIAlertAction *action) = ^(UIAlertAction *action) {
        __strong __typeof(ws) ss = ws;
        [ss showEditAlert:@"添加标签"
                  message:nil
         firstTextHandler:^(UITextField *textField) {
            lastTextField = textField;
        } secondTextHandler:nil
            cancelHandler:^(UIAlertAction *action) {
        } actions:@{
            @"添加":^(UIAlertAction *action) {
              __strong __typeof(ws) ss = ws;
              if (lastTextField.text.length > 0) {
                [ss.shareMedia.tags addObject:lastTextField.text];
                [ss updateChooseState];
              }
           },
        }];
    };
    
    void (^cleanBlock)(UIAlertAction *action) = ^(UIAlertAction *action) {
        __strong __typeof(ws) ss = ws;
        [ss.shareMedia.tags removeAllObjects];
        [ss updateChooseState];
    };
    
    [self showActionSheet:@"编辑标签"
                  message:nil
            cancelHandler:^(UIAlertAction *action) {
    } actions:@{
        @"添加":addBlock,
        @"清空":cleanBlock
    }];
}

- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTouchManageExtraInfoStep {
    __weak __typeof(self) ws = self;
    void (^editBlock)(UIAlertAction *action) = ^(UIAlertAction *action) {
        __strong __typeof(ws) ss = ws;
        __block UITextField *lastKeyTextField = nil;
        __block UITextField *lastValueTextField = nil;
        [ss showEditAlert:@"编辑ExtraInfo"
                  message:nil
         firstTextHandler:^(UITextField *textField) {
            lastKeyTextField = textField;
        }
        secondTextHandler:^(UITextField *textField) {
            lastValueTextField = textField;
        } cancelHandler:^(UIAlertAction *action) {
        } actions:@{
            @"修改":^(UIAlertAction *action) {
              __strong __typeof(ws) ss = ws;
              if (!ss.shareMedia.extraEntity) {
                  ss.shareMedia.extraEntity = [NSMutableDictionary dictionary];
              }
              ss.shareMedia.extraEntity[lastKeyTextField.text] = lastValueTextField.text;
          },
        }];
    };
    void (^cleanBlock)(UIAlertAction *action) = ^(UIAlertAction *action) {
        __strong __typeof(ws) ss = ws;
        ss.shareMedia.extraEntity = [NSMutableDictionary dictionary];
    };
    
    [self showActionSheet:@"编辑ExtraInfo"
                  message:[NSString stringWithFormat:@"%@", self.shareMedia.extraEntity]
            cancelHandler:^(UIAlertAction *action) {
    } actions:@{
       @"编辑":editBlock,
       @"清空": cleanBlock,
    }];
}

- (IBAction)didTouchAddAssociateInfo:(id)sender {
    
    __block UITextField *titleTF;
    __block UITextField *appIdTF;
    __block UITextField *pathTF;
    __weak __typeof(self) ws = self;
    [self showEditAlert:@"添加关联信息" message:nil configHandlers:@[
        ^ (UITextField *textField)
          {
        textField.placeholder = @"title";
        titleTF = textField;
    },
          ^ (UITextField *textField)
          {
        textField.placeholder = @"appId";
        appIdTF = textField;
    },
          ^ (UITextField *textField)
          {
        textField.placeholder = @"path";
        pathTF = textField;
    },
    ] cancelHandler:^(UIAlertAction *action) {
        
        
    } actions:@{
        @"确认":^(UIAlertAction *action) {
        __strong __typeof(ws) ss = ws;
        KSMediaAssociateKWAppObject *object = [[KSMediaAssociateKWAppObject alloc] init];
        object.title = titleTF.text;
        object.kWAppId = appIdTF.text;
        object.kWAppPath = pathTF.text;
        ss.shareMedia.associateType = KSMediaAssociateKWApp;
        ss.shareMedia.associateObject = object;
      },
    }];
}

- (IBAction)didTouchShareStep {
    __weak __typeof(self) ws = self;
    self.shareMedia.disableFallback = self.disableFallbackSwitch.isOn;
    
    [self.shareMedia share:^(BOOL success) {
        __strong __typeof(ws) ss = ws;
        if (!success) {
            [ss showAlert:@"提示" message:@"调用分享失败" cancelHandler:^(UIAlertAction *action) {
            } actions:nil];
        } else {
            [ss dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - CTAssetsPickerControllerDelegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray<PHAsset*> *)assets {
    void(^warningBlock)(NSString *message) = ^(NSString *message) {
        [self showAlertController:picker
                            title:@"警告"
                          message:message
                   preferredStyle:UIAlertControllerStyleAlert
                      cancelTitle:@"知道了"
                    cancelHandler:^(UIAlertAction *action) {
                    } actions:nil];
    };
    NSInteger tag = kChooseResource;
    if ([picker isKindOfClass:ExtendAssetsPickerController.class]) {
        tag = ((ExtendAssetsPickerController *) picker).tag;
    }
    
    if (tag == kChooseResource) {
        self.shareMedia.assets = assets;
    } else if (tag == kChooseThumbnail) {
        if (assets.count > 1 || assets.firstObject.mediaType != PHAssetMediaTypeImage) {
            warningBlock(@"请选择单张缩略图");
            return;
        }
        self.shareMedia.thumbnail = assets.firstObject;
    }
    [self updateChooseState];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private

- (void)updateChooseState {
    NSMutableString *currentChoose = [NSMutableString string];
    if (self.shareMedia.assets.count > 0) {
        if (self.shareMedia.assets.count == 1 && ![self.shareMedia firstAssetIsImage]) {
            [currentChoose appendString:@"选择了一个视频"];
            if (self.shareMedia.thumbnail != nil) {
                [currentChoose appendString:@"[封面]"];
            }
        } else if (self.shareMedia.assets.count > 1) {
            [currentChoose appendString:[NSString stringWithFormat:@"选择了%ld个资源", (long)self.shareMedia.assets.count]];
        } else if (self.shareMedia.assets.count == 1 && [self.shareMedia firstAssetIsImage]) {
            [currentChoose appendString:@"选择了一个图片"];
        }
    } else {
        if (self.shareMedia.feature  == KSShareMediaFeature_Preprocess) {
            [currentChoose appendString:@"选择 [多段视频/图片]"];
        }
    }
    if (self.shareMedia.feature  == KSShareMediaFeature_Preprocess) {
        [currentChoose appendString:@" 分享到 [裁剪页]"];
    }
    if (self.shareMedia.feature  == KSShareMediaFeature_Undefine) {
        self.resourceButton.enabled = NO;
        self.shareButton.enabled = NO;
        self.chooseThumbnail.enabled = NO;
    } else {
        self.resourceButton.enabled = YES;
        self.shareButton.enabled = YES;
        self.chooseThumbnail.enabled = NO;
        if (self.shareMedia.assets.count > 0) {
            self.chooseThumbnail.enabled = YES;
        }
    }
    if (self.shareMedia.tags.count > 0) {
        self.tagsLabel.text = [self.shareMedia.tags componentsJoinedByString:@"#"];
    } else {
        self.tagsLabel.text = @"";
    }
    if (currentChoose.length <= 0) {
        self.currentChooseLabel.text = @"请选择分享参数";
    } else {
        self.currentChooseLabel.text = currentChoose;
    }
}

- (void)showActionSheet:(NSString *)title
                message:(NSString *)message
          cancelHandler:(void (^)(UIAlertAction *action))cancelHandler
                actions:(NSDictionary<NSString *, void (^)(UIAlertAction *action)> *)actions {
    [self showAlertController:self title:title message:message preferredStyle:UIAlertControllerStyleActionSheet cancelTitle:@"取消" cancelHandler:cancelHandler actions:actions];
}

- (void)showAlert:(NSString *)title
          message:(NSString *)message
    cancelHandler:(void (^)(UIAlertAction *action))cancelHandler
          actions:(NSDictionary<NSString *, void (^)(UIAlertAction *action)> *)actions {
    [self showAlertController:self title:title message:message preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"知道了" cancelHandler:cancelHandler actions:actions];
}

- (void)showEditAlert:(NSString *)title
              message:(NSString *)message
          firstTextHandler:(void (^)(UITextField *textField))firstTextHandler
          secondTextHandler:(void (^)(UITextField *textField))secondTextHandler
        cancelHandler:(void (^)(UIAlertAction *action))cancelHandler
              actions:(NSDictionary<NSString *, void (^)(UIAlertAction *action)> *)actions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (firstTextHandler) {
        [alertController addTextFieldWithConfigurationHandler:firstTextHandler];
    }
    if (secondTextHandler) {
        [alertController addTextFieldWithConfigurationHandler:secondTextHandler];
    }
    [actions enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, void (^ _Nonnull obj)(UIAlertAction *), BOOL * _Nonnull stop) {
        [alertController addAction:[UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:obj]];
    }];
    if (cancelHandler != nil) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelHandler]];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showEditAlert:(NSString *)title
              message:(NSString *)message
       configHandlers:(NSArray<void (^)(UITextField *textField)> *)configHandlers
        cancelHandler:(void (^)(UIAlertAction *action))cancelHandler
              actions:(NSDictionary<NSString *, void (^)(UIAlertAction *action)> *)actions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [configHandlers enumerateObjectsUsingBlock:^(void (^ _Nonnull obj)(UITextField *), NSUInteger idx, BOOL * _Nonnull stop) {
        [alertController addTextFieldWithConfigurationHandler:obj];
    }];
    
    [actions enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, void (^ _Nonnull obj)(UIAlertAction *), BOOL * _Nonnull stop) {
        [alertController addAction:[UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:obj]];
    }];
    
    if (cancelHandler != nil) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelHandler]];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertController:(UIViewController *)controller
                      title:(NSString *)title
                    message:(NSString *)message
             preferredStyle:(UIAlertControllerStyle)preferredStyle
                cancelTitle:(NSString *)cancelTitle
              cancelHandler:(void (^)(UIAlertAction *action))cancelHandler
                    actions:(NSDictionary<NSString *, void (^)(UIAlertAction *action)> *)actions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    [actions enumerateKeysAndObjectsUsingBlock:
     ^(NSString * _Nonnull key, void (^ _Nonnull obj)(UIAlertAction *), BOOL * _Nonnull stop) {
        [alertController addAction:[UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:obj]];
    }];
    if (cancelHandler != nil) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelHandler]];
    }
    [controller presentViewController:alertController animated:YES completion:nil];
}

@end
