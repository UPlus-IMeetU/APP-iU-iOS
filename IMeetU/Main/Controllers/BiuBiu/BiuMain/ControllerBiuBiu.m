//
//  ControllerBiuBiu.m
//  IMeetU
//
//  Created by zhanghao on 16/3/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerBiuBiu.h"
#import "XMBiuMainViewBG.h"
#import "XMBiuCenterView.h"
#import "XMBiuFaceStarCollection.h"
#import "XMBiuCircularTrajectory.h"

#import "UIColor+Plug.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"

#import "YYKit/YYKit.h"
#import <QuartzCore/QuartzCore.h>

#import "ControllerDrawer.h"
#import "AppDelegate.h"
#import "ControllerBiuBiuReceive.h"
#import "ControllerBiuBiuSend.h"

#import "AppDelegateDelegate.h"
#import "MBProgressHUD.h"

#import "XMUrlHttp.h"
#import "AFNetworking.h"
#import "UserDefultAccount.h"

#import "ModelResponse.h"
#import "ModelBiuMainRefreshData.h"
#import "ModelActivity.h"

#import "NSDate+plug.h"
#import "DBSchools.h"

#import "ControllerUserLoginOrRegister.h"

#import "ControllerChatMsg.h"
#import "ControllerBiuPayB.h"
#import "DBCacheBiuContact.h"

#import "MLToast.h"

#import "XMHttpPersonal.h"
#import "XMOSS.h"
#import "MBProgressHUD+plug.h"
#import "UserDefultMsg.h"
#import "EMSDK.h"
#import "XMHttpTools.h"

#import "UserDefultConfig.h"
#import "AdvertDetailController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ControllerMatchSetting.h"
#import "EmptyController.h"
#import "MobClick.h"

#import "XMHttpBiuBiu.h"
#import "MatchPeopleController.h"

#import "UserDefultAccount.h"

#import "DBCacheBiuBiu.h"
#import "ModelUserListMatch.h"
#import "MatchPeopleView.h"

#import "ControllerBiuBiuReceive.h"

@interface ControllerBiuBiu ()<XMBiuCenterButtonDelegate, AppDelegateRemoteNotificationDelegate, ControllerBiuBiuSendDelegate, XMBiuFaceStarCollectionDelegate, ControllerBiuBiuReceiveDelegate, ControllerBiuPayBDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray *trajectoryRadiusArr;
@property (nonatomic, assign) CGFloat navigationHeight;
@property (nonatomic, assign) CGFloat userInfoHeight;

@property (nonatomic, assign) CGSize viewBiuBiuSize;
@property (nonatomic, assign) CGPoint viewBiuBiuCenterPoint;
@property (weak, nonatomic) IBOutlet UIView *viewBiuBiu;
@property (weak, nonatomic) IBOutlet UIButton *btnBiuBi;
@property (weak, nonatomic) IBOutlet UIView *viewMatchUserInfo;

@property (weak, nonatomic) IBOutlet UILabel *labelNameNick;
@property (weak, nonatomic) IBOutlet UILabel *labelGender;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelConstellation;
@property (weak, nonatomic) IBOutlet UILabel *labelSchoolProfession;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintUserInfoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNavigationViewHeight;

//广告页面
@property (weak, nonatomic) IBOutlet UIView *advertView;
//广告图片
@property (weak, nonatomic) IBOutlet UIImageView *advertImageView;
//广告关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *advertCloseButton;
//广告按钮
@property (weak, nonatomic) IBOutlet UIButton *advertButton;
//筛选按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@property (nonatomic, strong) XMBiuMainViewBG *biuViewBG;
@property (nonatomic, strong) XMBiuCenterView *biuCenterButton;
@property (nonatomic, strong) XMBiuFaceStarCollection *biuFaceStarCollection;
@property (nonatomic, strong) XMBiuCircularTrajectory *biuCircularTrajectory;

@property (nonatomic, assign) BOOL isDisplayedInScreen;

@property (nonatomic, strong) CLLocationManager *locationManager;


@property (nonatomic, assign) NSInteger profileState;
@property (nonatomic, strong) UIImagePickerController *imgPickController;

@property (nonatomic,strong) ModelActivity *modelActivity;
@property (nonatomic, assign) NSInteger umiCount;
@property (nonatomic,strong) MatchPeopleView *matchPeopleView;

@end

@implementation ControllerBiuBiu

/**
 *  单例对象
 *
 *  @return 单例
 */
+ (instancetype)shareControllerBiuBiu{
    static ControllerBiuBiu *controller;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"ControllerBiuBiu"];
    });
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.viewMatchUserInfo.alpha = 0;
    
    [self.locationManager startUpdatingLocation];
    
    self.biuViewBG = [XMBiuMainViewBG view];
    self.biuViewBG.frame = self.view.bounds;
    self.biuViewBG.frame = CGRectMake(0, 0, [UIScreen screenWidth], [UIScreen screenHeight]);
    [self.view insertSubview:self.biuViewBG atIndex:0];
    
    [self.viewBiuBiu addSubview:self.biuCircularTrajectory];
    
    [self.viewBiuBiu addSubview:self.biuFaceStarCollection];
    self.biuFaceStarCollection.delegateFaceStarCollection = self;
    
    [self.viewBiuBiu addSubview:self.biuCenterButton];
    self.biuCenterButton.delegateBiuCenter = self;
    
    self.constraintUserInfoHeight.constant = self.userInfoHeight;
    self.constraintNavigationViewHeight.constant = self.navigationHeight;
    
    self.advertView.hidden = YES;
    //刷新biubiu主页信息
    if ([UserDefultAccount isLogin]) {
        [self refreshBiuMainInfo];
    }else{
        [self refreshBiuMainInfoNotLogin];
    }
    //对于广告页进行相关的处理
    _matchPeopleView = [[MatchPeopleView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen screenWidth], [UIScreen screenHeight] - 64 - 49)];
    [self.view addSubview:_matchPeopleView];
    _matchPeopleView.hidden = YES;

    self.advertView.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.5];
    self.advertImageView.layer.cornerRadius = 5;
    self.advertImageView.clipsToBounds = YES;
    [self.view bringSubviewToFront:self.advertView];
    
    //追加
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [AppDelegateDelegate shareAppDelegateDelegate].delegateAppDelegate = self;
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.biuViewBG.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.biuViewBG.alpha = 1;
    }];
    
    //U米按钮为隐藏状态、客户端为登录状态，说明此次是登录后首次进入主页面，需要刷新
    if (!self.chooseButton.enabled && [UserDefultAccount isLogin]) {
        [self refreshBiuMainInfo];
    }
    
    //判断是否有新的消息,如果有，图标应该带点
    if([UserDefultAccount haveToView] == 0){
        [self.advertButton setImage: [UIImage imageNamed:@"biu_btn_activity_light"] forState:UIControlStateNormal] ;
    }else{
        [self.advertButton setImage:[UIImage imageNamed:@"biu_btn_activity_nor"] forState:UIControlStateNormal];
    }
    
    self.chooseButton.hidden = ![UserDefultAccount isLogin];
    
    if ([UserDefultAccount isLogin]) {
        
    }else{
        [self updateUmiCount:0];
        self.btnBiuBi.hidden = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    self.isDisplayedInScreen = YES;
    [self.biuFaceStarCollection superViewDidAppear:animated];
    //开启
    //[[ControllerDrawer shareControllerDrawer] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    if ([AppDelegate shareAppDelegate].remoteNotificationUserInfo) {
        
        ModelBiuFaceStar *faceStar = [ModelBiuFaceStar modelWithRemoteNiti:[AppDelegate shareAppDelegate].remoteNotificationUserInfo];
        ControllerBiuBiuReceive *controller = [ControllerBiuBiuReceive controllerWithFaceStar:faceStar delegate:self];
//        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
        [AppDelegate shareAppDelegate].remoteNotificationUserInfo = nil;
        
    }
    
    if (!self.biuViewBG.isAnimation) {
        dispatch_after(NSEC_PER_SEC*1, dispatch_get_main_queue(), ^{
            [self.biuViewBG launchAnimation];
        });
        self.biuViewBG.isAnimation = YES;
    }
    
    if ([UserDefultAccount isLogin]) {
        [_matchPeopleView initDataWithTime:0 withType:Refresh];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    self.isDisplayedInScreen = NO;
    [self.biuFaceStarCollection superViewDidDisappear:animated];
}


#pragma mark - 充值代理方法
- (void)controllerBiuPayB:(ControllerBiuPayB *)controller payRes:(BOOL)res umiCount:(NSInteger)count{
    if (res) {
        self.umiCount = count;
        //进行更新
        [self updateUmiCount:count];
    }
}

#pragma mark - 中心视图代理方法
#pragma mark 发送Biu
- (void)biuCenterButton:(XMBiuCenterView *)biuCenterButton onClickBtnSenderBiu:(UIButton *)btn isTimeout:(BOOL)timeout{
    if ([UserDefultAccount isLogin]) {
        if (timeout) {
            if (self.profileState == 1 || self.profileState == 2 || self.profileState == 3 || self.profileState == 0){
                ControllerBiuBiuSend *controller = [ControllerBiuBiuSend shareController];
                controller.delegateBiuSender = self;
//                [controller setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:controller animated:YES];
                
            }else{
                [self showAlertProfileState];
            }
        }else{
            [[MLToast toastInView:self.view content:@"距离上次发biu还不到90s"] show];
        }
        
    }else{
        ControllerUserLoginOrRegister *controller = [ControllerUserLoginOrRegister shareController];
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark 点击抢到我发出的biu的用户头像
- (void)biuCenterButton:(XMBiuCenterView *)biuCenterButton onClickBtnSuccessfulMatches:(UIButton *)btn model:(ModelBiuFaceStar *)model{
    
//    ControllerChatMsg *controllerChat = [[ControllerChatMsg alloc] initWithConversationChatter:model.userCode conversationType:EMConversationTypeChat];
//    
//    //[controllerChat setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:controllerChat animated:YES];
    //用辅助类进行页面的跳转
#warning 临解决tabBar隐藏后有空余的空间 后续需要进行修改
    EmptyController *emptyController = [EmptyController new];
    emptyController.conversationId = model.userCode;
    emptyController.type = EMConversationTypeChat;
    [self.navigationController pushViewController:emptyController animated:NO];
    
    //更新抢到我的biu的用户的状态（已读）
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"chat_id":model.biuID};
    [httpManager POST:[XMUrlHttp xmUpdateBiuMatchUserStatus] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
        }else{
            NSLog(@"%@", responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - AppDelegate回调
#pragma mark 远程通知回
- (void)appDelegate:(AppDelegate *)appDelegate isEnterFromRemoteNotification:(BOOL)isEnterFromRemoteNotification remoteNotificationUserInfo:(ModelRemoteNotification *)userInfo{
    if (userInfo.typeNotifi == 0) {
        //检查超时，只有在不超时的情况下才会跳转页面
        if (userInfo.biuMatchTime > [NSDate currentTimeMillis]-3600*1000) {
            ModelBiuFaceStar *faceStar = [ModelBiuFaceStar modelWithRemoteNiti:userInfo];
            if (isEnterFromRemoteNotification) {
                ControllerBiuBiuReceive *controller = [ControllerBiuBiuReceive controllerWithFaceStar:faceStar delegate:self];
                //[controller setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:controller animated:YES];
                [AppDelegate shareAppDelegate].remoteNotificationUserInfo = nil;
            }else{
                [self.biuFaceStarCollection  addNewFaceStarWithModel:faceStar];
                //强制更新联系人列表
                [[DBCacheBiuContact shareDAO] updateFromNetworkWithIsForced:YES block:nil];
                if (self.isDisplayedInScreen) {
                    //如果在主页，闪烁个人详细信息
                    [self blinkMatchUserInfoWithModel:userInfo];
                }
            }
        }else{
            [[MLToast toastInView:self.view content:@"biu已经消失..."] show];
        }
    }
    
    //只有在首先显示在当前屏幕上时才处理第一第二种通知
    if (self.isDisplayedInScreen) {
        if (userInfo.typeNotifi == 1){
            ModelBiuFaceStar *faceStar = [ModelBiuFaceStar modelWithRemoteNiti:userInfo];
            [self.biuCenterButton receiveMatcheUserWithModel:faceStar animation:YES];
        }else if (userInfo.typeNotifi == 2){
            ModelBiuFaceStar *faceStar = [ModelBiuFaceStar modelWithRemoteNiti:userInfo];
            [self.biuFaceStarCollection removeFaceStarWithModel:faceStar];
        }
    }
}

#pragma mark 程序即将进入前台回调
- (void)applicationWillEnterForeground:(UIApplication *)application{
    if ([UserDefultAccount isLogin]) {
        [self refreshBiuMainInfo];
        
        [self testDBMatchUser];
    }else{
        [self refreshBiuMainInfoNotLogin];
    }
}

#pragma mark - 发送biubiu回调
#pragma mark 发送biubiu完成
- (void)controllerBiuBiuSend:(ControllerBiuBiuSend *)controller sendResult:(BOOL)result virtualCurrency:(NSInteger)virtualCurrency{
    if (result) {
        [self.biuCenterButton timerCountdownStart];
        [self updateUmiCount:virtualCurrency];
        //更新U米个数
        self.umiCount = virtualCurrency;
    }else{
        
    }
}

#pragma mark - 抢biu回调
#pragma mark 抢biu成功
- (void)controllerBiuBiuReceive:(ControllerBiuBiuReceive *)controller grabBiu:(ModelBiuFaceStar *)biu umiCount:(NSInteger)umiCount{
    [self.biuFaceStarCollection removeFaceStarWithModel:biu];
    //更新U米个数
    [self updateUmiCount:umiCount];
    self.umiCount = umiCount;
}

#pragma mark 充值成功
- (void)controllerBiuBiuReceive:(ControllerBiuBiuReceive *)controller umiCount:(NSInteger)umiCount{
    [self updateUmiCount:umiCount];
    //更新U米个数
    self.umiCount = umiCount;
}

- (void)controllerBiuBiuReceive:(ControllerBiuBiuReceive *)controller alreadyGrabBiu:(ModelBiuFaceStar *)biu{
    [self.biuFaceStarCollection removeFaceStarWithModel:biu];
}

#pragma mark - 点击头像集合视图回调
#pragma mark 点击头像回调
- (void)xmBiuFaceStarCollection:(XMBiuFaceStarCollection *)view onClickProfileWithModel:(ModelBiuFaceStar *)model{
    if ([UserDefultAccount isLogin]) {
        ControllerBiuBiuReceive *controller = [ControllerBiuBiuReceive controllerWithFaceStar:model delegate:self];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        ControllerUserLoginOrRegister *controller = [ControllerUserLoginOrRegister shareController];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - 位置管理者回调
#pragma mark 更新位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations[0];
    if (location) {
        CLLocationCoordinate2D coordinate = location.coordinate;
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"dimension":[NSNumber numberWithDouble:coordinate.latitude], @"longitude":[NSNumber numberWithDouble:coordinate.longitude]};
        [httpManager POST:[XMUrlHttp xmUpdateLocation] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ModelResponse *response = [ModelResponse responselWithObject:responseObject];
            if (response.state == 200) {
            }else{
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
}

#pragma mark - 功能函数
#pragma mark 刷新主页信息（已登录）
- (void)refreshBiuMainInfo{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [httpManager POST:[XMUrlHttp xmUpdateBiuMainInfo] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        //更新token
        [UserDefultAccount updateToken:response.data[@"token"]];
        if (response.state == 200) {
            //登陆成功的情况下，可以进行点击的操作
            ModelBiuMainRefreshData *biuData = [ModelBiuMainRefreshData modelWithDictionary:response.data];
            [self updateUmiCount:biuData.virtualCurrency];
            self.btnBiuBi.hidden = NO;
            
            self.umiCount = biuData.virtualCurrency;
            self.profileState = biuData.profileState;
            
            [self showAlertProfileState];
            
            if (biuData.matchUser) {
                [self.biuCenterButton receiveMatcheUserWithModel:biuData.matchUser animation:NO];
            }else{
                [self.biuCenterButton noReceiveMatchUser];
            }
        }else{
            [self.biuCenterButton noReceiveMatchUser];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.biuCenterButton noReceiveMatchUser];
    }];
    
    [self getAdvertInfo];
}

#pragma mark 刷新主页信息（未登陆）
- (void)refreshBiuMainInfoNotLogin{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{};
    [httpManager POST:[XMUrlHttp xmUpdateBiuMainInfoUnlogin] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            ModelBiuMainRefreshData *biuData = [ModelBiuMainRefreshData modelWithDictionary:response.data];
            [self updateUmiCount:biuData.virtualCurrency];
            
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    [self.biuCenterButton noReceiveMatchUser];
}

#pragma mark 获取广告信息
- (void)getAdvertInfo{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    NSDictionary *parameters = @{};
    [httpManager POST:[XMUrlHttp xmGetActivity] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            _modelActivity = [ModelActivity modelWithJSON:response.data[@"activity"]];
            
            //1.首先判断status的值，如果为0隐藏广告按钮，如果为1进一步判断
            self.advertButton.hidden = (_modelActivity.status == 0);
            if(_modelActivity.status == 1){
                //2.检查缓存中updateAt是否与请求中的updateAt一致
                //如果不一致更新缓存中的updateAt并设置haveToView为0，显示小红点。
                if(_modelActivity.updateAt != [UserDefultAccount updateAt]){
                    [UserDefultAccount setUpdateAt:_modelActivity.updateAt];
                    [self.advertButton setImage:[UIImage imageNamed:@"biu_btn_activity_light"] forState:UIControlStateNormal];
                    //设置haveToView为0
                    [UserDefultAccount setHaveToView:0];
                    //如果一致，继续检查haveToView是否为1
                }else{
                    if (0 == [UserDefultAccount haveToView]) {
                        [self.advertButton setImage:[UIImage imageNamed:@"biu_btn_activity_light"] forState:UIControlStateNormal];
                    }
                }
                
                //检查缓存中dialogURL是否与请求中的一致：如果一致，不进行任何操作。如果不一致，更新dialogURL，并弹出弹窗。
                
                if (![[UserDefultAccount dialoyURL] isEqualToString:_modelActivity.dialog.url]) {
                    NSLog(@"UserDefault dialoyURL is %@",[UserDefultAccount dialoyURL]);
                    NSLog(@"modle dialoyURL is %@",_modelActivity.dialog.url);
                    [UserDefultAccount setDialoyURL:_modelActivity.dialog.url];
                    NSLog(@"update after UserDefault dialoyURL is %@",_modelActivity.dialog.url);
                    [self prepareAdvert];
                }
            }
            
            
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)prepareAdvert{
    //活动弹窗，弹出次数
    [MobClick event:@"acty_dialog_pop"];
    NSURL *urlString = [NSURL URLWithString:_modelActivity.dialog.cover];
    [self.advertImageView setImageWithURL:urlString placeholder:[UIImage imageNamed:@"biu_banner"] options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        self.advertView.hidden = NO;
        [UIView animateWithDuration:0.15 animations:^{
            self.advertImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.advertImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }];
    //给图片添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intoAdvert:)];
    [self.advertImageView addGestureRecognizer:tapGestureRecognizer];
    self.advertImageView.userInteractionEnabled = YES;
    
}
#pragma mark 跳转到相应的页面
- (void)intoAdvert:(UITapGestureRecognizer *)tapGesutre{
    //活动弹窗，点开次数
    [MobClick event:@"acty_dialog_open"];
    AdvertDetailController *advertDetailController = [AdvertDetailController shareControllerAdvert];
    advertDetailController.advertUrl = _modelActivity.dialog.url;
    //[advertDetailController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:advertDetailController animated:YES];
    //点击结束以后消失
    [UIView animateWithDuration:0.2 animations:^{
        self.advertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.advertView removeFromSuperview];
    }];
}

- (void)blinkMatchUserInfoWithModel:(ModelRemoteNotification*)model{
    [self.labelNameNick setText:model.biuUserName];
    self.labelGender.text = model.biuUserGender==1?@"男生":@"女生";
    self.labelAge.text = [NSString stringWithFormat:@"%lu", model.biuUserAge];
    self.labelConstellation.text = model.biuUserConstellation;
    
    if (model.biuIsGraduated==1) {
        self.labelSchoolProfession.text = [[DBSchools shareInstance] schoolNameWithID:[model.biuUserSchool integerValue]];
    }else if(model.biuIsGraduated==2){
        self.labelSchoolProfession.text = model.biuUserProfession;
    }
    
    self.viewMatchUserInfo.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewMatchUserInfo.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.viewMatchUserInfo.alpha = 0;
        } completion:nil];
    }];
}

#pragma mark - 基础数据
#pragma mark 顶栏（导航栏）高度
- (CGFloat)navigationHeight{
    if ([UIScreen is35Screen]) {
        return 54;
    }else if ([UIScreen is40Screen]){
        return 56;
    }else if ([UIScreen is47Screen]){
        return 58;
    }else if ([UIScreen is55Screen]){
        return 64;
    }
    return 0;
}

#pragma mark 底栏高度
- (CGFloat)userInfoHeight{
    if ([UIScreen is35Screen]) {
        return 120;
    }else if ([UIScreen is40Screen]){
        return 142;
    }else if ([UIScreen is47Screen]){
        return 169;
    }else if ([UIScreen is55Screen]){
        return 225;
    }
    return 0;
}

#pragma mark 轨道半径
- (NSArray *)trajectoryRadiusArr{
    if ([UIScreen is35Screen]) {
        return @[@90, @130, @170];
    }else if ([UIScreen is40Screen]){
        return @[@97, @142, @172];
    }else if ([UIScreen is47Screen]){
        return @[@111, @169.5, @201];
    }else if ([UIScreen is55Screen]){
        return @[@124, @182, @214];
    }
    return @[];
}

#pragma mark 轨道所在视图的尺寸
- (CGSize)viewBiuBiuSize{
    return CGSizeMake([UIScreen screenWidth], [UIScreen screenHeight]-self.userInfoHeight-self.navigationHeight);
}

#pragma mark 中心视图的尺寸
- (CGPoint)viewBiuBiuCenterPoint{
    return CGPointMake(self.viewBiuBiuSize.width/2, self.viewBiuBiuSize.height/2);
}

#pragma mark - 懒加载对象
#pragma mark 中心视图
- (XMBiuCenterView *)biuCenterButton{
    if (!_biuCenterButton) {
        _biuCenterButton = [XMBiuCenterView biuCenterButtonWithOrigin:CGPointMake([UIScreen screenWidth]/2, ([UIScreen screenHeight]-self.userInfoHeight-self.navigationHeight)/2)];
    }
    return _biuCenterButton;
}

#pragma mark 收到的biubiu集合视图
- (XMBiuFaceStarCollection *)biuFaceStarCollection{
    if (!_biuFaceStarCollection) {
        _biuFaceStarCollection = [XMBiuFaceStarCollection biuFaceStarCollectionWithSuperViewSize:self.viewBiuBiuSize trajectoryRadiusArr:self.trajectoryRadiusArr];
    }
    return _biuFaceStarCollection;
}

#pragma mark 轨道视图
- (XMBiuCircularTrajectory *)biuCircularTrajectory{
    if (!_biuCircularTrajectory) {
        _biuCircularTrajectory = [XMBiuCircularTrajectory biuCircularTrajectoryWithSize:self.viewBiuBiuSize trajectoryRadiusArr:self.trajectoryRadiusArr];
    }
    return _biuCircularTrajectory;
}

#pragma mark 位置管理者
- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 50;
        [_locationManager requestWhenInUseAuthorization];
        
        //        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        //            _locationManager.allowsBackgroundLocationUpdates = YES;
        //        }
    }
    return _locationManager;
}

- (void)showAlertProfileState{
    UIAlertController *controller;
    
    if (self.profileState == 2) {
        controller = [UIAlertController alertControllerWithTitle:@"头像审核通过" message:@"你的头像审核通过啦，可以愉快的玩耍了" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self profileStateReaded];
        }]];
    }else if (self.profileState == 4){
        controller = [UIAlertController alertControllerWithTitle:@"头像审核未通过" message:@"你的头像审核不通过，请上传能体现个人的真实头像哦" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self profileStateReaded];
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:self.imgPickController animated:YES completion:nil];
        }]];
    }else if (self.profileState == 5){
        controller = [UIAlertController alertControllerWithTitle:@"头像审核未通过" message:@"你的头像审核不通过，请上传能体现个人的真实头像哦" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [controller addAction:[UIAlertAction actionWithTitle:@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:self.imgPickController animated:YES completion:nil];
        }]];
    }else if(self.profileState == 6){
        controller = [UIAlertController alertControllerWithTitle:@"头像审核未通过" message:@"你修改的头像审核未通过，将恢复原头像，点击重新上传更换头像" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self profileStateReaded];
        }]];
        [controller addAction:[UIAlertAction actionWithTitle:@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:self.imgPickController animated:YES completion:nil];
        }]];
    }
    
    if (self.profileState==2 || self.profileState==4 || self.profileState==5 || self.profileState==6) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
            UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
            
            MBProgressHUD *hud = [MBProgressHUD xmShowHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.labelText = @"上传中...";
            
            [XMOSS uploadFileWithImg:img prefix:@"profile" progress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                hud.progress = totalByteSent/1.0/totalBytesExpectedToSend*1.0;
            } finish:^id(OSSTask *task, NSString *fileName) {
                
                if (!task.error) {
                    NSString *postUrl;
                    NSDictionary *parameters;
                    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
                    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
                    
                    postUrl = [XMUrlHttp xmUpdateProfile];
                    parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"icon_url":fileName};
                    
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.labelText = @"更新...";
                    [httpManager POST:postUrl parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                        if (response.state == 200) {
                            NSDictionary *dicRes = response.data;
                            
                            [UserDefultAccount setUserProfileUrlThumbnail:dicRes[@"icon_thumbnailUrl"]];
                            
                            self.profileState = 1;
                            [hud xmSetCustomModeWithResult:YES label:@"上传成功"];
                        }else{
                            [hud xmSetCustomModeWithResult:NO label:@"上传失败"];
                        }
                        [hud hide:YES afterDelay:1];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [hud xmSetCustomModeWithResult:NO label:@"上传失败"];
                        [hud hide:YES afterDelay:1];
                    }];
                    
                }else{
                    [hud xmSetCustomModeWithResult:NO label:@"上传失败"];
                    [hud hide:YES afterDelay:1];
                }
                return nil;
            }];
            
        }else{
            
        }
    }];
}

- (void)profileStateReaded{
    if (self.profileState == 2 || self.profileState == 6) {
        self.profileState = 3;
    }else if (self.profileState == 4){
        self.profileState = 5;
    }
    
    [[XMHttpPersonal http] xmChangeProfileStateReadWithUserCode:[UserDefultAccount userCode] block:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (UIImagePickerController *)imgPickController{
    if (!_imgPickController) {
        _imgPickController = [[UIImagePickerController alloc] init];
        _imgPickController.delegate = self;
        _imgPickController.allowsEditing = YES;
        _imgPickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return _imgPickController;
}

- (void)setProfileStateOne{
    self.profileState = 1;
}

- (void)updateUmiCount:(NSInteger)umiCount{
    [self.btnBiuBi setTitle:[NSString stringWithFormat:@" %zi", umiCount] forState:UIControlStateNormal];
    [UserDefultAccount setCountUmi:umiCount];
}

#pragma mark广告相关的操作
- (IBAction)AdvertCloseButtonClick:(id)sender {
    //弹框关闭的次数
    [MobClick event:@"acty_dialog_close"];
    [UIView animateWithDuration:0.5 animations:^{
        self.advertImageView.center = self.advertButton.center;
        self.advertImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.advertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.advertView removeFromSuperview];
        self.advertButton.hidden = NO;
    }];
}

#pragma mark 进入匹配列表
- (IBAction)IntoMatchPeople:(id)sender {
//    MatchPeopleController *matchPeople = [[MatchPeopleController alloc] init];
//    [self.navigationController pushViewController:matchPeople animated:YES];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [UIView beginAnimations:nil context:context];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_matchPeopleView cache:YES];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(stop:)];
//    [UIView commitAnimations];
//    self.matchPeopleView.hidden = !self.matchPeopleView.hidden;
#warning 进入收BiuBiu页面
    ControllerBiuBiuReceive *controllerBiuBiuReceive = [ControllerBiuBiuReceive controllerWithFaceStar:nil delegate:self];
    [self.navigationController pushViewController:controllerBiuBiuReceive animated:YES];
    
}

- (void)stop:(id)sender{
    NSLog(@"结束");
}
#pragma mark进入筛选页面
- (IBAction)ChooseBtnClick:(id)sender {
    ControllerMatchSetting *matchSettingController = [ControllerMatchSetting controller];
    matchSettingController.controllerType = ControllerTypeFilter;
    //[matchSettingController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:matchSettingController animated:YES];
}

- (NSInteger)userProfileState{
    return self.profileState;
}

- (void)testDBMatchUser{
    DBCacheBiuBiu *cache = [DBCacheBiuBiu shareInstance];
    
    [[XMHttpBiuBiu http] loadMatchUserWithCount:10 timestamp:0 callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"----->%@", response);
        [cache insertWithArrModelUserMatch:[ModelUserListMatch modelWithJSON:response].users];
    }];
}

@end
