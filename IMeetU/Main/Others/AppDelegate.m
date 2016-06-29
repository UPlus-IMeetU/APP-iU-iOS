//
//  AppDelegate.m
//  IMeetU
//
//  Created by zhanghao on 16/2/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

#import <AVOSCloud/AVOSCloud.h>
#import "ControllerFirstLaunch.h"

#import "ControllerDrawer.h"
#import "ControllerMineMain.h"
#import "ControllerDrawerRight.h"

#import "NSDate+plug.h"
#import "UIScreen+Plug.h"
#import "UserDefultAccount.h"

#import "AppDelegateDelegate.h"
#import <YYKit/YYKit.h>

#import "EMSDK.h"

#import "AFNetworking.h"
#import "XMUrlHttp.h"
#import "ModelResponse.h"

#import "BeeCloud.h"

#import "MobClick.h"
#import "UMSocialData.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsService.h"
#import "UMSocialQQHandler.h"

#import "ModelRequestMineInfoUpdate.h"

#import "UserDefultConfig.h"
#import "ControllerBiuBiu.h"
#import "ControllerChatMsg.h"
#import "FactotyLocalNotification.h"
#import <BQMM/BQMM.h>
#import <Bugly/Bugly.h>

#import "UserDefultAccount.h"

#import "ControllerTabBarMain.h"
#import "XMHttpGlobal.h"

#import "NSString+Plug.h"


#import "XGPush.h"
#import "XGSetting.h"

#import "UserDefultAppGlobalStatus.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic, strong) ControllerFirstLaunch *controllerFirstLaunch;
@property (nonatomic, assign) BOOL isEnterFromRemoteNotification;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置UITabBarItem的字体大小和字体的大小
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:174/255.0 green:177.0/255.0 blue:178.0/255.0 alpha:1],UITextAttributeFont:[UIFont boldSystemFontOfSize:11]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:245/255.0 green:244.0/255.0 blue:145.0/255.0 alpha:1],UITextAttributeFont:[UIFont boldSystemFontOfSize:11]} forState:UIControlStateSelected];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:notificationSettings];
        [application registerForRemoteNotifications];
    }else{
        
    }
    
    NSDictionary *remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        self.remoteNotificationUserInfo = [ModelRemoteNotification modelWithDictionary:remoteNotification];
    }
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //友盟统计
    [MobClick startWithAppkey:@"56f6b0c7e0f55a5a7c00146d" reportPolicy:BATCH channelId:nil];
    //友盟分享
    [UMSocialData setAppKey:@"56f6b0c7e0f55a5a7c00146d"];
    [UMSocialWechatHandler setWXAppId:@"wxc38cdfe5049cb17e" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.imeetu.cc/mobile/index.html"];
    [UMSocialQQHandler setQQWithAppId:@"1105300664" appKey:@"8JNlUhShRkfINnHp" url:@"http://www.imeetu.cc/mobile/index.html"];
    
    //支付
    [BeeCloud initWithAppID:@"3adc89a6-617f-4445-8f23-2b805df90fe4" andAppSecret:@"2f5add66-01cf-4024-9efe-e4c183f79205"];
    [BeeCloud initWeChatPay:@"wxc38cdfe5049cb17e"];
    //LeanCloud
    [AVOSCloud setApplicationId:@"tcd4rj3s3c54bdlkv1vfu5puvu9c2k96ur9kge3qvptqxp8p"
                      clientKey:@"8fpp7j815746jg9x26f0d3c5p76xqkyqm586v2onvx3m2k7a"];
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], [UIScreen screenHeight])];
    
    if ([UserDefultConfig isFirstLaunch]) {
        self.window.rootViewController = self.controllerFirstLaunch;
    }else{
        self.window.rootViewController = [ControllerTabBarMain shareController];
    }
    [self.window makeKeyAndVisible];
    
    //环信
    EMOptions *options = [EMOptions optionsWithAppkey:@"imeetu#meetu"];
    //options.apnsCertName = @"meetu_develop";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient] addDelegate:[AppDelegateDelegate shareAppDelegateDelegate] delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:[AppDelegateDelegate shareAppDelegateDelegate] delegateQueue:nil];
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        dispatch_queue_t queue = dispatch_queue_create("em.login", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            EMError *error = [[EMClient sharedClient] loginWithUsername:[UserDefultAccount imName] password:[UserDefultAccount imPasswork]];
            if (!error){
                [[EMClient sharedClient].options setIsAutoLogin:YES];
            }
        });
    }else{
        
    }
    
    //表情云
    [[MMEmotionCentre defaultCentre] setAppId:@"5ca457f4bf624e31ac2dbc1ba3bc398e" secret:@"eafc5215121a4075927f4317e6ab67d5"];
    
    //腾讯崩溃日志跟踪
    [Bugly startWithAppId:@"i1400009724"];
    //腾讯信鸽
    [[XGSetting getInstance] enableDebug:YES];
    [XGPush startApp:2200204436 appKey:@"IXMK2751PC1F"];
    [XGPush handleLaunching:launchOptions];
    [AppDelegate registerDeviceToken];
    
    //[[TIMManager sharedInstance] setMessageListener:nil];
    //[[TIMManager sharedInstance] setConnListener:nil];
    //[[TIMManager sharedInstance] initSdk:1400009724 accountType:@"5119"];
    
    
    [self changeForeOrBackGround:1];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    [self changeForeOrBackGround:0];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[AppDelegateDelegate shareAppDelegateDelegate] applicationWillEnterForeground:application];
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    self.isEnterFromRemoteNotification = YES;
    
    [self changeForeOrBackGround:1];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[XMHttpGlobal http] globalGetAppStatusWithCallback:nil];
    
    [AppDelegate registerDeviceToken];
    
    if ([UserDefultAppGlobalStatus noticeCount]) {
         [[ControllerTabBarMain shareController] showBadgeWithIndex:1];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.isEnterFromRemoteNotification = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [UserDefultAccount xgSetDeviceToken:[XGPush getDeviceToken:deviceToken]];
    
    if ([UserDefultAccount isLogin]) {
        [XGPush setAccount:[UserDefultAccount userCode]];
        [XGPush registerDevice:deviceToken successCallback:^{
            NSLog(@"registerDevice-------------suc");
        } errorCallback:^{
            NSLog(@"registerDevice-------------err");
        }];
    }
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

#pragma mark - 推送相关
#pragma mark 收到推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [XGPush handleReceiveNotification:userInfo];
    
    ModelRemoteNotification *model = [ModelRemoteNotification modelWithDictionary:userInfo];
    [[AppDelegateDelegate shareAppDelegateDelegate] appDelegate:self isEnterFromRemoteNotification:self.isEnterFromRemoteNotification remoteNotificationUserInfo:model];
    
    if (model.type == 201) {
        [UserDefultAccount setUserProfileStatus:model.profileStatusChange.profileStatus];
    }else if(model.type == 301){
        [UserDefultAppGlobalStatus setNoticeCount:model.noticeCount];
        [[ControllerTabBarMain shareController] showBadgeWithIndex:1];
    }else if(model.type == 103){
        [UserDefultAppGlobalStatus setComBiuCount:model.comBiuCount];
    }
}

#pragma mark 本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    if ([FactotyLocalNotification notificationTypeWithNotification:notification] == FactoryLocalNotificationTypeIMReceiveMsg) {
        if (self.isEnterFromRemoteNotification) {
            NSString *userCode = notification.userInfo[@"userCode"];
            if (userCode) {
                //ControllerChatMsg *controllerChat = [[ControllerChatMsg alloc] initWithConversationChatter:userCode conversationType:EMConversationTypeChat];
            }
        }
    }
}

//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

//iOS9之后apple官方建议使用此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([BeeCloud handleOpenUrl:url]) {
        return YES;
    }
    if ([UMSocialSnsService handleOpenURL:url]) {
        return YES;
    }
    
    return YES;
}

- (ControllerFirstLaunch *)controllerFirstLaunch{
    if (!_controllerFirstLaunch) {
        _controllerFirstLaunch = [ControllerFirstLaunch controller];
    }
    return _controllerFirstLaunch;
}


#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    return;
}
/**
 *  程序切换前后台时更新最后活跃时间、前后台状态
 *
 *  @param foreOrBack 0-后台；1-前台；
 */
- (void)changeForeOrBackGround:(NSInteger)foreOrBack{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    ModelRequestMineInfoUpdate *model = [[ModelRequestMineInfoUpdate alloc] init];
    model.finalActyTime = [NSDate currentTimeMillis];
    model.ForeOrBackGround = foreOrBack;
    model.parameters = ModelRequestMineInfoUpdateFinalActyTimeForeOrBackGround;
    model.token = [UserDefultAccount token];
    model.deviceCode = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [httpManager POST:[XMUrlHttp xmUpdateMineInfo] parameters:@{@"data":[model modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


+ (void)registerDeviceToken{
    if ([UserDefultAccount isLogin] && [UserDefultAccount xgHaveDeviceToken]) {
        [XGPush setAccount:[UserDefultAccount userCode]];
        [XGPush registerDeviceStr:[UserDefultAccount xgDeviceToken]];
    }
}

+ (instancetype)shareAppDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

+ (void)launchFirst{
    AppDelegate *appDelegate = [AppDelegate shareAppDelegate];
    appDelegate.window.rootViewController = [ControllerTabBarMain shareController];
}



@end


