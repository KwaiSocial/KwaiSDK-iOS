//
//  KSDemoViewController.m
//  KwaiOpenSDKDemo
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import "KSDemoViewController.h"
#import "KSShareMessageViewController.h"
#import "KSMediaViewController.h"
#import "KSOpenApiManager.h"
#import "KSOpenApiManager.h"
#import "KSOpenApiManager+Auth.h"
#import "KSOpenApiManager+Profile.h"
#import "KSOpenApiManager+Utils.h"

@interface KSDemoViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *openIDTextView;

@property (strong, nonatomic) IBOutlet UISwitch *targetOpenIdSwitch;
@property (strong, nonatomic) IBOutlet UITextView *targetOpenIdTextView;

@property (weak, nonatomic) IBOutlet UITextView *appIdTextView;
@property (weak, nonatomic) IBOutlet UITextView *targetAppTextView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *jumpTypeSegmentControl;

@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UIButton *cleanLogButton;

@property (weak, nonatomic) IBOutlet UIButton *cleanLoginInfoButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation KSDemoViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGesture];
    self.appIdTextView.delegate = self;
    self.targetOpenIdTextView.delegate = self;
    self.openIDTextView.delegate = self;
    [[KSOpenApiManager shared] registerKwaiOpenSDK];
    [self setupLogView];
    [self setupAppIdView];
    self.versionLabel.text = [NSString stringWithFormat: @"v%@", [KSApi apiVersion]];
    
    [self addObservers];
    [self.jumpTypeSegmentControl setEnabled:NO];
//    [self.cleanLoginInfoButton setEnabled:NO];
    [self.view resignFirstResponder];
}

#pragma mark -

- (void)addObservers {
    __weak __typeof(self) ws = self;
    [[KSOpenApiManager shared] setLoginBlock:^(NSString * _Nonnull code, NSError * _Nonnull error) {
        __strong __typeof(ws) ss = ws;
        [ss didLogin:code];
    }];
    
    [[KSOpenApiManager shared] setActionBlock:^(NSString * _Nonnull state, NSError * _Nonnull error) {
        
    }];
    
    [[KSOpenApiManager shared] setLogBlock:^(NSObject * _Nonnull log) {
        __strong __typeof(ws) ss = ws;
        NSString *string = [NSString stringWithFormat:@"%@", log];
        [ss textViewAddString:string];
        NSLog(@"%@", string);
    }];
}

#pragma mark - Gesture

- (void)addGesture {
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [self.view addGestureRecognizer:tgr];
}

- (void)endEditing {
    [self.openIDTextView resignFirstResponder];
    [self.targetOpenIdTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -

- (IBAction)login:(id)sender {
    [[KSOpenApiManager shared] loginWithH5Container:self];
}

- (IBAction)showProfile:(id)sender {
    NSString *targetOpenId = self.targetOpenIdTextView.text;
    [[KSOpenApiManager shared] showProfile:targetOpenId];
}

- (IBAction)shareMessage {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    KSShareMessageViewController * vc = (KSShareMessageViewController *)[sb instantiateViewControllerWithIdentifier:@"shareMessage"];
    [self presentViewController:vc animated:YES completion:nil];
    
    if (self.targetOpenIdSwitch.isOn) {
        NSString *targetOpenId = self.targetOpenIdTextView.text;
        targetOpenId = targetOpenId.length > 0 ? targetOpenId: nil;
        vc.receiverOpenId = targetOpenId;
    }
}

- (IBAction)shareMedia:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    KSMediaViewController * vc = (KSMediaViewController *)[sb instantiateViewControllerWithIdentifier:@"media"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Login & Clean Login Info

- (void)didLogin:(NSString *)code {
    __weak __typeof(self) ws = self;
    [[KSOpenApiManager shared] getOpenIDFromCode:code completion:^(NSString * _Nonnull openId, NSError * _Nonnull error) {
        __strong __typeof(ws) ss = ws;
        ss.openIDTextView.text = openId;
        if (openId.length) {
            [[KSOpenApiManager shared] setSelfOpenID:openId];
            self.targetOpenIdTextView.text = openId; //方便调试，使用自己的id作为targetId
        }
    }];
}

- (IBAction)cleanLoginInfo:(id)sender {
    [[KSOpenApiManager shared] cleanLoginInfo];
}

#pragma mark -  切换目标App

- (NSMutableArray *)applicationList {
    return [KSOpenApiManager shared].applicationList;
}

- (IBAction)targetAppKwaiTapped:(id)sender {
    if ([self.applicationList containsObject:@(KSApiApplication_Kwai)]) {
        [self.applicationList removeObject:@(KSApiApplication_Kwai)];
    } else {
        [self.applicationList addObject:@(KSApiApplication_Kwai)];
    }
    
    __block NSString *str = @"";
    [self.applicationList enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue == KSApiApplication_Kwai) {
            str = [str stringByAppendingString:@" 快手 "];
        } else if (obj.integerValue == KSApiApplication_KwaiLite) {
            str = [str stringByAppendingString:@" 快手极速版 "];
        }
    }];
    self.targetAppTextView.text = str;
}

- (IBAction)targetAppKwaiLiteTapped:(id)sender {
    if ([self.applicationList containsObject:@(KSApiApplication_KwaiLite)]) {
        [self.applicationList removeObject:@(KSApiApplication_KwaiLite)];
    } else {
        [self.applicationList addObject:@(KSApiApplication_KwaiLite)];
    }
    __block NSString *str = @"";
    [self.applicationList enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue == KSApiApplication_Kwai) {
            str = [str stringByAppendingString:@" 快手 "];
        } else if (obj.integerValue == KSApiApplication_KwaiLite) {
            str = [str stringByAppendingString:@" 快手极速版 "];
        }
    }];
    self.targetAppTextView.text = str;
}

#pragma mark -  Jumpout Style

- (IBAction)jumpTypeSegmentControlValueChanged:(UISegmentedControl *)sender {
    //Todo
}

#pragma mark - AppId


- (IBAction)changeAppid:(id)sender {
    __block UITextField *lastTextField = nil;
    [self showEditAlert: @"替换appId（确认后会杀掉app）"
                message: nil
            textHandler: ^(UITextField *textField) {
        lastTextField = textField;
    } cancelHandler: ^(UIAlertAction *action) {
    
    } actions:
     @{
        @"使用textFile输入内容": ^(UIAlertAction *action) {
        if (lastTextField.text.length > 0) {
            [[KSOpenApiManager shared] saveAppId:lastTextField.text];
            exit(0);
        }
    },
        @"使用release-appid": ^(UIAlertAction *action) {
        [[KSOpenApiManager shared] saveAppId:kKSAppIdRelease];
        exit(0);
    },
        @"使用test-appid": ^(UIAlertAction *action) {
        [[KSOpenApiManager shared] saveAppId:kKSAppIdTest];
        exit(0);
    }
    }];
}

- (void)setupAppIdView {
    NSString *appId = [[KSOpenApiManager shared] appId];
    NSString *textViewSufix;
    if ([appId isEqualToString:kKSAppIdTest]) {
        textViewSufix = @"测试环境AppId";
    } else if ([appId isEqualToString:kKSAppIdRelease]) {
        textViewSufix = @"正式环境AppId";
    } else {
        textViewSufix = @"自定义的AppId";
    }
    
    self.appIdTextView.text = [NSString stringWithFormat:@"%@--%@",appId, textViewSufix];
}

- (void)showEditAlert: (NSString *)title
              message: (NSString *)message
          textHandler: (void (^)(UITextField *textField))textHandler
        cancelHandler: (void (^)(UIAlertAction *action))cancelHandler
              actions: (NSDictionary<NSString *, void (^)(UIAlertAction *action)> *)actions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    if (textHandler != nil) {
        [alertController addTextFieldWithConfigurationHandler: textHandler];
    }
    [actions enumerateKeysAndObjectsUsingBlock: ^(NSString * _Nonnull key, void (^ _Nonnull obj)(UIAlertAction *), BOOL * _Nonnull stop) {
        [alertController addAction: [UIAlertAction actionWithTitle: key style: UIAlertActionStyleDefault handler: obj]];
    }];
    if (cancelHandler != nil) {
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: cancelHandler]];
    }
    [self presentViewController: alertController animated: YES completion: nil];
}

#pragma mark -  LogView

- (void)setupLogView {
    [self textViewAddString:@""];
#if BETA
    [self textViewAddString:@"当前是BETA环境"];
#elif DEBUG
    [self textViewAddString:@"当前是DEBUG环境"];
#elif RELEASE
    [self textViewAddString:@"当前是RELEASE环境"];
#endif
}

- (void)textViewAddString:(NSString *)str {
    self.logTextView.text = [self.logTextView.text stringByAppendingString:str];
    self.logTextView.text = [self.logTextView.text stringByAppendingString:@"\n------------------\n"];
}

- (IBAction)cleanLogButton:(id)sender {
    self.logTextView.text = @"";
}

@end
