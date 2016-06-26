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

#import "UserDefultAccount.h"

#import "DBCacheBiuBiu.h"
#import "ModelUserMatch.h"
#import "ModelUserListMatch.h"
#import "MatchPeopleView.h"

#import "ControllerBiuBiuReceive.h"

#import "XMStitchingImage.h"

#import "UserDefultBiu.h"

#import "ControllerBiuAccept.h"

#import "ModelAdvert.h"

#import "MLToast.h"
#import "ModelMatchSetting.h"
#import "UserDefultSetting.h"

@interface ControllerBiuBiu ()<XMBiuCenterButtonDelegate, AppDelegateRemoteNotificationDelegate, ControllerBiuBiuSendDelegate, XMBiuFaceStarCollectionDelegate, ControllerBiuBiuReceiveDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray *trajectoryRadiusArr;
@property (nonatomic, assign) CGFloat navigationHeight;
@property (nonatomic, assign) CGFloat userInfoHeight;

@property (nonatomic, assign) CGSize viewBiuBiuSize;
@property (nonatomic, assign) CGPoint viewBiuBiuCenterPoint;
@property (weak, nonatomic) IBOutlet UIView *viewBiuBiu;
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
//Match按钮
@property (weak, nonatomic) IBOutlet UIButton *matchButton;

@property (nonatomic, strong) XMBiuMainViewBG *biuViewBG;
@property (nonatomic, strong) XMBiuCenterView *biuCenterButton;
@property (nonatomic, strong) XMBiuFaceStarCollection *biuFaceStarCollection;
@property (nonatomic, strong) XMBiuCircularTrajectory *biuCircularTrajectory;

@property (nonatomic, assign) BOOL isDisplayedInScreen;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UIImagePickerController *imgPickController;

@property (nonatomic,strong) ModelActivity *modelActivity;
@property (nonatomic,strong) MatchPeopleView *matchPeopleView;

@property (weak, nonatomic) IBOutlet UIView *backTitleBgView;

@property (nonatomic, strong) NSTimer *timerRefresh;
@property (nonatomic, assign) NSInteger refreshTheCountdown;
@property (nonatomic, assign) NSInteger refreshMaxInterval;
@property (nonatomic, assign) NSInteger refreshMinInterval;
@property (nonatomic, assign) int matchHasNext;
@property (nonatomic, assign) BOOL isLoadingBiu;
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
    self.matchButton.hidden = ![UserDefultAccount isLogin];
    self.chooseButton.hidden = ![UserDefultAccount isLogin];
    self.advertButton.hidden = YES;
    if ([UserDefultAccount isLogin]) {
        [self refreshBiuMainInfo];
    }else{
        [self refreshBiuMainInfoNotLogin];
    }
    //对于广告页进行相关的处理
    _matchPeopleView = [[MatchPeopleView alloc] initWithFrame:CGRectMake(0, 55, [UIScreen screenWidth], [UIScreen screenHeight] - 55 - 49)];
    _matchPeopleView.hidden = YES;
    [self.view addSubview:_matchPeopleView];

    __weak typeof(self) weakSelf = self;
    _matchPeopleView.RecieveBiuBiuSelectBlock = ^(ModelBiuFaceStar *modelBiuFaceStar){
        //进行页面的跳转
        ControllerBiuBiuReceive *controllerBiuBiuReceive = [ControllerBiuBiuReceive controllerWithFaceStar:modelBiuFaceStar delegate:weakSelf];
        [weakSelf.navigationController pushViewController:controllerBiuBiuReceive animated:YES];
        
    };

    self.advertView.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.5];
    self.advertImageView.layer.cornerRadius = 5;
    self.advertImageView.clipsToBounds = YES;
    [self.view bringSubviewToFront:self.advertView];
    
    [_matchPeopleView initDataWithTime:0 withType:Refresh];
    //清空数据库
    DBCacheBiuBiu *cache = [DBCacheBiuBiu shareInstance];
    [cache cleanDB];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:self.matchPeopleView.hidden];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [AppDelegateDelegate shareAppDelegateDelegate].delegateAppDelegate = self;
    self.navigationController.navigationBarHidden = YES;
    
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
    self.matchButton.hidden = ![UserDefultAccount isLogin];
    if (![UserDefultAccount isLogin]) {
        self.matchPeopleView.hidden = YES;
        self.backTitleBgView.backgroundColor = [UIColor often_6CD1C9:0];
    }
    if ([UserDefultAccount isLogin]) {
        [self timerRefreshLaunch];
    }else{
        //[self updateUmiCount:0];
    }
    
    //当biubiu未结束时......
    if ([UserDefultBiu biuInMatch] && [UserDefultAccount isLogin]) {
        [self.biuCenterButton receiveMatcheUserWithImageUrl:[UserDefultBiu biuUserProfileOfGrab]];
    }else{
        [self.biuCenterButton noReceiveMatchUser];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    self.isDisplayedInScreen = YES;
    [self.biuFaceStarCollection superViewDidAppear:animated];
    //开启
    
    if ([AppDelegate shareAppDelegate].remoteNotificationUserInfo) {
        
        ModelBiuFaceStar *faceStar = [ModelBiuFaceStar modelWithRemoteNiti:[AppDelegate shareAppDelegate].remoteNotificationUserInfo];
        ControllerBiuBiuReceive *controller = [ControllerBiuBiuReceive controllerWithFaceStar:faceStar delegate:self];

        [self.navigationController pushViewController:controller animated:YES];
        [AppDelegate shareAppDelegate].remoteNotificationUserInfo = nil;
    }
    
    if (!self.biuViewBG.isAnimation) {
        dispatch_after(NSEC_PER_SEC*1, dispatch_get_main_queue(), ^{
            [self.biuViewBG launchAnimation];
        });
        self.biuViewBG.isAnimation = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    self.isDisplayedInScreen = NO;
    [self.biuFaceStarCollection superViewDidDisappear:animated];
    
    [self timerRefreshShutdown];
}

#pragma mark - 中心视图代理方法
#pragma mark 发送Biu
- (void)biuCenterButton:(XMBiuCenterView *)biuCenterButton onClickBtnSenderBiu:(UIButton *)btn isTimeout:(BOOL)timeout{
    if ([UserDefultAccount isLogin]) {
        if ([UserDefultAccount userProfileStatus] == 5){
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"头像审核未通过" message:@"你的头像审核不通过，请上传能体现个人的真实头像哦" preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [controller addAction:[UIAlertAction actionWithTitle:@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self presentViewController:self.imgPickController animated:YES completion:nil];
            }]];
            
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            ControllerBiuBiuSend *controller = [ControllerBiuBiuSend shareController];
            controller.delegateBiuSender = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
        ControllerUserLoginOrRegister *controller = [ControllerUserLoginOrRegister shareController];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark 点击抢到我发出的biu的用户头像
- (void)biuCenterButton:(XMBiuCenterView *)biuCenterButton onClickBtnSuccessfulMatches:(UIButton *)btn model:(ModelBiuFaceStar *)model{
    if ([UserDefultAccount isLogin]) {
        ControllerBiuAccept *controller = [ControllerBiuAccept controller];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        ControllerUserLoginOrRegister *controller = [ControllerUserLoginOrRegister shareController];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark 倒计时结束
- (void)biuCenterButtonCountdownEnd:(XMBiuCenterView *)biuCenterButton{
    if (![UserDefultBiu biuUserProfileOfGrab] || [UserDefultBiu biuUserProfileOfGrab].length<1) {
        [[MLToast toastInView:self.view content:@"你的biubiu暂时无人接收呢"] show];
    }
}

#pragma mark - AppDelegate回调
#pragma mark 远程通知回
- (void)appDelegate:(AppDelegate *)appDelegate isEnterFromRemoteNotification:(BOOL)isEnterFromRemoteNotification remoteNotificationUserInfo:(ModelRemoteNotification *)userInfo{
    if (userInfo.type == 101) {
        //检查超时，只有在不超时的情况下才会跳转页面
        ModelBiuFaceStar *faceStar = [ModelBiuFaceStar modelWithRemoteNiti:userInfo];
        
        if (userInfo.biuSend.biuMatchTime > [NSDate currentTimeMillis]-3600*1000) {
            if (isEnterFromRemoteNotification) {
                ControllerBiuBiuReceive *controller = [ControllerBiuBiuReceive controllerWithFaceStar:faceStar delegate:self];
                [self.navigationController pushViewController:controller animated:YES];
                [AppDelegate shareAppDelegate].remoteNotificationUserInfo = nil;
            }else{
                //强制更新联系人列表
                [[DBCacheBiuContact shareDAO] updateFromNetworkWithIsForced:YES block:nil];
            }
        }
        
        [[DBCacheBiuBiu shareInstance] insertWithModelUserMatch:[faceStar getModelUserMatch]];
    }
    
    if (userInfo.type == 102){
        ModelBiuFaceStar *faceStar = [ModelBiuFaceStar modelWithRemoteNiti:userInfo];
        [UserDefultBiu setBiuUserProfileOfGrab:faceStar.userProfile];
        //更新最新头像缓存
        [UserDefultBiu setBiuUserProfileOfGrab:faceStar.userProfile];
        
        //首页显示在当前屏幕上时切换中心按钮状态
        if (self.isDisplayedInScreen) {
            [self.biuCenterButton receiveMatcheUserWithImageUrl:faceStar.userProfile];
        }
    }
}

#pragma mark 程序即将进入前台回调
- (void)applicationWillEnterForeground:(UIApplication *)application{
    if ([UserDefultAccount isLogin]) {
        [self refreshBiuMainInfo];
        //清空原有头像
        [self.biuFaceStarCollection refresh];
        
        [self loadSetting];
    }else{
        [self refreshBiuMainInfoNotLogin];
    }
}

#pragma mark - 发送biubiu回调
#pragma mark 发送biubiu完成
- (void)controllerBiuBiuSend:(ControllerBiuBiuSend *)controller sendResult:(BOOL)result virtualCurrency:(NSInteger)virtualCurrency{
    if (result) {
        [self.biuCenterButton timerCountdownStart];
    }else{
        
    }
}

#pragma mark - 抢biu回调
#pragma mark 抢biu成功
- (void)controllerBiuBiuReceive:(ControllerBiuBiuReceive *)controller grabBiu:(ModelBiuFaceStar *)biu umiCount:(NSInteger)umiCount{
    [self.biuFaceStarCollection removeFaceStarWithModel:biu];
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
            
            [UserDefultAccount setUserProfileStatus:biuData.profileState];
            if (biuData.isBiuEnd) {
                [UserDefultBiu setBiuInMatch:NO];
                [UserDefultBiu setBiuUserProfileOfGrab:@""];
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
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    [self.biuCenterButton noReceiveMatchUser];
    [self getAdvertInfo];
}

#pragma mark 获取广告信息
- (void)getAdvertInfo{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    NSDictionary *parameters =  @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
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
    AdvertDetailController *advertDetailController = [AdvertDetailController shareControllerAdvertWithModel:_modelActivity.dialog];
    [self.navigationController pushViewController:advertDetailController animated:YES];
    //点击结束以后消失
    [UIView animateWithDuration:0.2 animations:^{
        self.advertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.advertView removeFromSuperview];
    }];
}

- (void)blinkMatchUserInfoWithModel:(ModelBiuFaceStar*)model{
    self.viewMatchUserInfo.alpha = 0;
    
    [self.labelNameNick setText:model.userName];
    self.labelGender.text = model.userGender==1?@"男生":@"女生";
    self.labelAge.text = [NSString stringWithFormat:@"%lu", (long)model.userAge];
    self.labelConstellation.text = model.userConstellation;
    
    self.labelSchoolProfession.text = [[DBSchools shareInstance] schoolNameWithID:[model.schoolId integerValue]];
    
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
    CGFloat height = 0;
    if ([UIScreen is35Screen]) {
        height = 120;
    }else if ([UIScreen is40Screen]){
        height = 142;
    }else if ([UIScreen is47Screen]){
        height = 169;
    }else if ([UIScreen is55Screen]){
        height = 225;
    }
    height -= 48;
    return height;
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
    return CGSizeMake([UIScreen screenWidth], [UIScreen screenHeight]-self.userInfoHeight-self.navigationHeight-48);
}

#pragma mark 中心视图的尺寸
- (CGPoint)viewBiuBiuCenterPoint{
    return CGPointMake(self.viewBiuBiuSize.width/2, self.viewBiuBiuSize.height/2);
}

#pragma mark - 懒加载对象
#pragma mark 中心视图
- (XMBiuCenterView *)biuCenterButton{
    if (!_biuCenterButton) {
        _biuCenterButton = [XMBiuCenterView biuCenterButtonWithOrigin:self.viewBiuBiuCenterPoint];
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
                            
                            [UserDefultAccount setUserProfileStatus:1];
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

//- (void)profileStateReaded{
//    if (self.profileState == 2 || self.profileState == 6) {
//        self.profileState = 3;
//    }else if (self.profileState == 4){
//        self.profileState = 5;
//    }
//    
//    [[XMHttpPersonal http] xmChangeProfileStateReadWithUserCode:[UserDefultAccount userCode] block:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
//    }];
//}

- (UIImagePickerController *)imgPickController{
    if (!_imgPickController) {
        _imgPickController = [[UIImagePickerController alloc] init];
        _imgPickController.delegate = self;
        _imgPickController.allowsEditing = YES;
        _imgPickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return _imgPickController;
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
    [_matchPeopleView initDataWithTime:0 withType:Refresh];
   
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_matchPeopleView cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    [self rotate:_matchButton];
      self.matchPeopleView.hidden = !self.matchPeopleView.hidden;
    [[UIApplication sharedApplication] setStatusBarHidden:self.matchPeopleView.hidden];
}


- (void)rotate:(UIButton *)sender {
        [UIView animateWithDuration:1 animations:^{
          
            if (self.matchPeopleView.hidden) {
                sender.transform = CGAffineTransformMakeRotation(M_PI);
                self.backTitleBgView.backgroundColor = [UIColor often_6CD1C9:1];
            }else{
                sender.transform = CGAffineTransformMakeRotation(0);
                self.backTitleBgView.backgroundColor = [UIColor often_6CD1C9:0];
            }
        } completion:^(BOOL finished) {
            
        }];
}

#pragma mark进入筛选页面
- (IBAction)ChooseBtnClick:(id)sender {
    ControllerMatchSetting *matchSettingController = [ControllerMatchSetting controller];
    matchSettingController.controllerType = ControllerTypeFilter;
    //[matchSettingController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:matchSettingController animated:YES];
}

- (void)timerRefreshLaunch{
    if (self.timerRefresh) {
        [self.timerRefresh invalidate];
        self.timerRefresh = nil;
    }
    
    self.matchHasNext = 1;
    self.timerRefresh = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshFaceStarCollectionView:) userInfo:nil repeats:YES];
}

- (void)timerRefreshShutdown{
    [self.timerRefresh invalidate];
    self.timerRefresh = nil;
}

- (void)refreshFaceStarCollectionView:(id)sender{
    if (self.refreshTheCountdown < 1){
        if (self.refreshMaxInterval) {
            self.refreshTheCountdown = arc4random()%(self.refreshMaxInterval-self.refreshMinInterval) + self.refreshMinInterval;
        }else{
            self.refreshTheCountdown = 0;
        }
        
        DBCacheBiuBiu *cache = [DBCacheBiuBiu shareInstance];
        ModelUserMatch *model = [cache selectLatestAndUnShow];
        
        if (model) {
            [cache updateHaveBeenShownWithUserCode:model.userCode];
            
            ModelBiuFaceStar *modelBiuFaceStar = [ModelBiuFaceStar modelWithModelUserMatch:model];
            [self.biuFaceStarCollection addNewFaceStarWithModel:modelBiuFaceStar];
            [self blinkMatchUserInfoWithModel:modelBiuFaceStar];
        }else{
            self.refreshTheCountdown = 0;
        }
        
        if ([cache selectCountOfUnShow] < 3) {
            [self loadMatchUser];
        }
    }
    
    self.refreshTheCountdown --;
}

- (void)loadMatchUser{
    if (!self.isLoadingBiu) {
        self.isLoadingBiu = YES;
        
        DBCacheBiuBiu *cache = [DBCacheBiuBiu shareInstance];
        ModelUserMatch *model = [cache selectLastBiu];
        NSInteger timestamp = 0;
        if (model) {
            timestamp = model.timeSendBiu;
        }
        [[XMHttpBiuBiu http] loadMatchUserWithCount:10 timestamp:timestamp callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            self.isLoadingBiu = NO;
            ModelUserListMatch *models = [ModelUserListMatch modelWithJSON:response];
            self.refreshMaxInterval = models.showIntervalMax;
            self.refreshMinInterval = models.showIntervalMin;
            
            if (!models.hasNext){
                if ([cache selectCountOfUnShow] < 1){
                    [cache cleanDB];
                }
            }
            
            DBCacheBiuBiu *cache = [DBCacheBiuBiu shareInstance];
            [cache insertWithArrModelUserMatch:models.users];
        }];
    }
}

- (void)loadSetting{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [httpManager POST:[XMUrlHttp xmMatchSetting] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        if (response.state == 200) {
            ModelMatchSetting *modelMatchSetting = [ModelMatchSetting modelWithDictionary:response.data];
            [UserDefultSetting msgNotification:modelMatchSetting.pushNewMsg];
            [UserDefultSetting msgNotificationIsSound:modelMatchSetting.pushSound];
            [UserDefultSetting msgNotificationVibration:modelMatchSetting.pushVibration];
            
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
