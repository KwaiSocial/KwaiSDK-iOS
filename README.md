# 快手开放平台SDK

## 介绍

快手开发平台SDK提供了第三方app跳转到快手终端进行交互的能力，其中包括快手登陆授权，分享私信、视频、图片到快手，跳转指定用户个人主页等功能。



## 接入指南

### 1.配置您应用的UniversalLinks

由于苹果iOS 13系统版本安全升级，为此openSDK在3.0.0版本进行了适配。 3.0.0版本支持Universal Links方式跳转，对openSDK分享进行合法性校验。

#### **（1）根据 [苹果文档](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content) 配置你应用的Universal Links：**

快手对Universal Links要求：必须支持HTTPS，配置的paths不能带query参数，App配置的paths必须加上通配符/*。

示例:

```json
{ 
"appID": "8P7343TG54.com.kuaishou.game.SDKSample",    
"paths": ["/sdksample/*"]
}
```

#### **2）打开Associated Domains开关，将Universal Links域名加到配置上**

![image](https://user-images.githubusercontent.com/62368093/82444779-53554f00-9ad6-11ea-970a-46c4e3d55b68.png)
 


### 2.向快手注册您的应用id和universalLinks

详见https://docs.qq.com/doc/DRndDUmJldkNNQWNa

申请成功后，得到 AppId 和 AppSecret, 客户端接入只需要 AppId , 服务器同时需要 AppId 和 AppSecret。



### 3.搭建开发环境

#### 3.1静态库集成

##### (1)通过cocoapods集成

```ruby
pod 'KwaiSDK' ,'3.3.3'
```

##### (2)手动集成

1.在 XCode 中建立你的工程。

2.将 SDK 文件中 KwaiSDK.framework 文件添加到你所建的工程中。

3.开发者需要在工程中链接上:**WebKit.framework**。

4.在你的工程文件中选择 Build Setting，在"Other Linker Flags"中加入"-ObjC -all_load"。



#### 3.2设置scheme

在 Xcode 中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序 id（如下图所示）。

![image](https://user-images.githubusercontent.com/62368093/82444842-6405c500-9ad6-11ea-9aad-5cd0119ac671.png)

在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在 “info”标签栏的“LSApplicationQueriesSchemes“添加 **kwai kwaiAuth2 kwaiopenapi KwaiBundleToken kwai.clip.multi KwaiSDKMediaV2**

在实际开发中，需要把示例例中的 **ks685673047210945076** 替换成⾃己的 **appId**

#### 3.3 在代码中使用开发工具包

##### 1.要使你的程序启动后快手终端能响应你的程序，必须在代码中向快手终端注册你的 id。（如下图所示，在 AppDelegate 的 didFinishLaunchingWithOptions 函数中向快手注册 id）。

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //向快手注册
    [KSApi registerApp:APP_ID universalLink:UNIVERSAL_LINK delegate:YOUR_DELEGATE];
    return YES;
}
```



##### 2.重写 AppDelegate 的 handleOpenURL 和 openURL 方法：

```objc
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [KSApi handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [KSApi handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [KSApi handleOpenURL:url];
}
```



##### 3.重写AppDelegate或SceneDelegate的continueUserActivity方法。

**注意：适配了SceneDelegate的App，系统将会回调SceneDelegate的continueUserActivity方法，所以需要重写SceneDelegate的该方法。**

AppDelegate:

```objc
- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [KSApi handleOpenUniversalLink:userActivity];
}
```

SceneDelegate:

```objc
- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity {
    return [KSApi handleOpenUniversalLink:userActivity];
}
```



## 4.功能使用

#### 4.1 快手授权登陆



```objc
    KSAuthRequest *req = [[KSAuthRequest alloc] init];
    req.authType = @"code";
    req.scope = @"user_info,relation";
    req.h5AuthViewController = YOURE_VC;
    [KSApi sendRequest:req completion:nil];
```



| 参数                     | 是否可为空 | 解释                                                         |
| :----------------------- | :--------- | :----------------------------------------------------------- |
| **authType**             | 不可为空   | 目前仅支持code方式                                           |
| **scope**                | 不可为空   | 取决于你的app需要的快手用户权限，应当与注册到快手开放平台的权限匹配。 |
| **h5AuthViewController** | 可为空     | 是指当用户设备未安装快手终端的时候，会在这个传入的viewController上present出一个H5页面，可以让用户输入手机号&验证码方式登陆快手账号。如果为空并且用户设备未安装快手终端会回调error给delegate。 |



#### 4.2 分享H5卡片消息到快手

分为指定用户和非指定用户发送

指定用户发送：跳转主app后弹出一个卡片窗口，可增加H5卡片消息附言，确认后发送并跳转到单聊界面，仅双关用户可发送成功。

非指定用户发送：跳转主app后present出一个用户选择列表，有群组，可多选，可增加H5卡片消息附言，确认后发送并跳转到聊天session列表页面。

```objc
    KSShareWebPageObject *object = [[KSShareWebPageObject alloc] init];
    object.title = @"title";
    object.desc = @"desc";
    object.linkURL = @"url";
    object.thumbImage = UIImageJPEGRepresentation(YOURE_IMAGE, 1);

    KSShareMessageRequest *req = [[KSShareMessageRequest alloc] init];
    req.openID = [self selfOpenID];
    req.shareScene = KSShareScopeSession;
    req.shareObject = object;
    req.receiverOpenID = TARGET_OPEN_ID;
    [KSApi sendRequest:req completion:nil];
```

**KSShareWebPageObject**

| 参数       | 是否可为空 | 解释                  |
| :--------- | :--------- | :-------------------- |
| title      | 不可为空   | H5卡片消息的标题      |
| desc       | 不可为空   | H5卡片消息的描述      |
| linkURL    | 不可为空   | H5卡片消息点击跳转url |
| thumbImage | 可为空     | H5卡片消息的icon      |



**KSShareMessageRequest**

| 参数           | 是否可为空 | 解释                                                         |
| :------------- | :--------- | :----------------------------------------------------------- |
| openID         | 可为空     | 发送方的openId，如果指定receiverOpenID了，那么openID为空会报错，因为在指定接收用户的场景下，需要发送方的id去校验用户关系 |
| receiverOpenID | 可为空     | 接收方的openId，如果不指定，则跳转到快手终端后会展示用户列表，在快手终端中自行选择接收方。 |
| shareObject    | 不可为空   | 目前仅支持KSShareWebPageObject                               |
| shareScene     | 不可为空   | 目前仅支持KSShareScopeSession                                |



#### 4.3 跳转profile

跳转到主站用户profile



```objc
    KSShowProfileRequest *req = [[KSShowProfileRequest alloc] init];
    req.targetOpenID = [self targetOpenID];
    [KSApi sendRequest:req];
```

**KSShowProfileRequest**

| 参数         | 是否可为空 | 解释           |
| :----------- | :--------- | :------------- |
| targetOpenID | 不可为空   | 目标用户openID |



#### 4.4 视频编辑相关功能



```objc
KSShareMediaObject *object = [[KSShareMediaObject alloc] init];
//object 参数配置
KSShareMediaRequest *request = [[KSShareMediaRequest alloc] init];
request.mediaFeature = KSShareMediaFeature_Preprocess;
request.mediaObject = object;
```

目前mediaFeature支持了不同能生产页面跳转功能。

