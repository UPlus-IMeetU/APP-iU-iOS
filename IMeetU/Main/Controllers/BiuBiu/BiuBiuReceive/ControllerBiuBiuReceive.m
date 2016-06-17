//
//  ControllerBiuBiuReceive.m
//  IMeetU
//
//  Created by zhanghao on 16/3/4.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerBiuBiuReceive.h"
#import "UINib+Plug.h"
#import "UIColor+Plug.h"
#import "UIScreen+Plug.h"
#import "ReusableViewBiuReceiveFooterBiuB.h"

#import "CellBiuReceive.h"
#import "ReusableViewBiuReceiveHeader.h"
#import "ReusableViewBiuReceiveSection.h"
#import "ReusableViewBiuReceiveFooter.h"
#import "ReusableViewBiuReceiveFooterBiuB.h"

#import "UserDefultAccount.h"
#import "ControllerUserLoginOrRegister.h"
#import "UIStoryboard+Plug.h"

#import "ModelBiuFaceStar.h"

#import <YYKit/YYKit.h>
#import "XMUrlHttp.h"
#import "AFNetworking.h"
#import "ModelResponse.h"
#import "ModelBiuReceive.h"
#import "UserDefultAccount.h"

#import "MBProgressHUD+plug.h"

#import "ControllerBiuBiuSend.h"

#import "ControllerChatMsg.h"

#import "ControllerBiuPayB.h"

#import "DBCacheBiuContact.h"
#import "XMOSS.h"

#import "ControllerUserIdentifierGuide.h"

#import "MobClick.h"

#define CellBiuReceiveReuseIdentifier @"CellBiuReceive"
#define ReusableViewBiuReceiveHeaderIdentifier @"ReusableViewBiuReceiveHeader"
#define ReusableViewBiuReceiveFooterIdentifier @"ReusableViewBiuReceiveFooter"
#define ReusableViewBiuReceiveFooterIdentifierBiuB @"ReusableViewBiuReceiveFooterBiuB"
#define ReusableViewBiuReceiveSectionIdentifier @"ReusableViewBiuReceiveSection"
#define Recharge 10001
#define Consumption 10002

@interface ControllerBiuBiuReceive ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ReusableViewBiuReceiveFooterBiuBDelegate, ReusableViewBiuReceiveFooterDelegate, ControllerBiuPayBDelegate, ReusableViewBiuReceiveHeaderDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) CGFloat collectionFooterHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMain;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (nonatomic, strong) ModelBiuFaceStar *modelFaceStar;
@property (nonatomic, strong) ModelBiuReceive *modelBiuReceive;
//网络请求是否成功
@property (nonatomic, assign) BOOL modelBiuReceiveIsRequest;

@property (nonatomic, strong) UIImagePickerController *imgPickController;
@property (nonatomic, assign) NSInteger profileState;
@property (nonatomic, assign) BOOL isDropDown;
//抢Biu需要的UMi数量，同时也是状态位置，在每次开始的时候都都应该为0
@property (nonatomic, assign) NSInteger countUMi;
@property (nonatomic, strong) UIButton  *statusButton;
@property (nonatomic, strong) MBProgressHUD *hub;

@property (nonatomic, weak) id<ControllerBiuBiuReceiveDelegate,UIAlertViewDelegate> delegateReceiveBiu;
@end

@implementation ControllerBiuBiuReceive

+ (ControllerBiuBiuReceive *)controllerWithFaceStar:(ModelBiuFaceStar *)model delegate:(id<ControllerBiuBiuReceiveDelegate>)delegate{
    ControllerBiuBiuReceive *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"ControllerBiuBiuReceive"];
    controller.modelFaceStar = model;
    controller.delegateReceiveBiu = delegate;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionFooterHeight = 160;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [self.collectionViewMain registerNib:[UINib xmNibFromMainBundleWithName:CellBiuReceiveReuseIdentifier] forCellWithReuseIdentifier:CellBiuReceiveReuseIdentifier];
    [self.collectionViewMain registerNib:[UINib xmNibFromMainBundleWithName:ReusableViewBiuReceiveHeaderIdentifier] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewBiuReceiveHeaderIdentifier];
    [self.collectionViewMain registerNib:[UINib xmNibFromMainBundleWithName:ReusableViewBiuReceiveSectionIdentifier] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewBiuReceiveSectionIdentifier];
    [self.collectionViewMain registerNib:[UINib xmNibFromMainBundleWithName:ReusableViewBiuReceiveFooterIdentifier] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewBiuReceiveFooterIdentifier];
    [self.collectionViewMain registerNib:[UINib xmNibFromMainBundleWithName:ReusableViewBiuReceiveFooterIdentifierBiuB] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewBiuReceiveFooterIdentifierBiuB];
    self.collectionViewMain.collectionViewLayout = layout;
    self.collectionViewMain.dataSource = self;
    self.collectionViewMain.delegate = self;
    self.collectionViewMain.showsVerticalScrollIndicator = NO;
    self.collectionViewMain.backgroundColor = [UIColor whiteColor];
    self.collectionViewMain.layer.cornerRadius = 10;
    self.collectionViewMain.clipsToBounds = YES;
    
    self.modelBiuReceiveIsRequest = NO;
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"" animated:YES];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"user_code":self.modelFaceStar.userCode};
    [httpManager POST:[XMUrlHttp xmReceiveBiuDetails] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            [hud hide:YES];
            self.modelBiuReceive = [ModelBiuReceive modelWithDictionary:response.data];
            
            self.modelBiuReceiveIsRequest = YES;
            [self.collectionViewMain reloadData];
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.collectionViewMain.contentSize.height < [UIScreen screenHeight]-64) {
        self.collectionFooterHeight += ([UIScreen screenHeight] - 64 - self.collectionViewMain.contentSize.height);
        [self.collectionViewMain reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [self setHidesBottomBarWhenPushed:NO];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        if (!_isDropDown) {
            return self.modelBiuReceive.characters.count;
        }
        return 0;
        
    }else if (section == 2){
        if (_isDropDown) {
            return self.modelBiuReceive.interests.count;
        }
        return 0;
    }
    
    return 0;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            ReusableViewBiuReceiveHeader *viewHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewBiuReceiveHeaderIdentifier forIndexPath:indexPath];
            viewHeader.delegateReusableView = self;
            [viewHeader initWithModel:self.modelBiuReceive];
            reusableView = viewHeader;
        }else if (indexPath.section == 1){
            ReusableViewBiuReceiveSection *viewSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewBiuReceiveSectionIdentifier forIndexPath:indexPath];
            [viewSection initWithSection:indexPath.section count:self.modelBiuReceive.characters.count];
            reusableView = viewSection;
        }else if (indexPath.section == 2){
            ReusableViewBiuReceiveSection *viewSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewBiuReceiveSectionIdentifier forIndexPath:indexPath];
            [viewSection initWithSection:indexPath.section count:self.modelBiuReceive.interests.count];
            reusableView = viewSection;
        }
    }else if (kind == UICollectionElementKindSectionFooter){
        // 网络请求完成之前，或网络请求成功后且biubiu币足够
        //        if ((!self.modelBiuReceiveIsRequest) || (self.modelBiuReceive.biuAllCount > self.modelBiuReceive.biuUsedCountOnce)) {
        ReusableViewBiuReceiveFooter *viewSection = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewBiuReceiveFooterIdentifier forIndexPath:indexPath];
        viewSection.delegateFooter = self;
        [viewSection initWithMessage:self.modelBiuReceive.message];
        
        reusableView = viewSection;
        //        }else{
        //            ReusableViewBiuReceiveFooterBiuB *reusableFooterBiuB = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewBiuReceiveFooterIdentifierBiuB forIndexPath:indexPath];
        //            reusableFooterBiuB.delegateFooter = self;
        //            return reusableFooterBiuB;
        //        }
    }
    
    return reusableView;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellBiuReceive *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellBiuReceiveReuseIdentifier forIndexPath:indexPath];
    if (indexPath.section == 1) {
        [cell initWithCharacter:[self.modelBiuReceive modelCharaterOfIndex:indexPath.row]];
    }else if (indexPath.section == 2){
        [cell initWithInterest:[self.modelBiuReceive modelInterestOfIndex:indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(53, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(section == 0 ){
        return UIEdgeInsetsZero;
    }else if(section == 1){
        if (self.modelBiuReceive.characters.count == 0) {
            return  UIEdgeInsetsZero;
        }
        return UIEdgeInsetsMake(15, 20, 15, 20);
    }else if(section == 2){
        if (self.modelBiuReceive.interests.count == 0 || !_isDropDown) {
            return UIEdgeInsetsMake(0, 0, 15, 0);
        }
        return UIEdgeInsetsMake(15, 20, 15, 20);
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake([UIScreen screenWidth],440);
    }else if (section == 1){
        if (_isDropDown) {
            return CGSizeMake([UIScreen screenWidth], 20);
        }
        return CGSizeZero;
    }else if (section == 2){
        if (_isDropDown) {
            return CGSizeMake([UIScreen screenWidth], 20);
        }
        return CGSizeZero;
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 2){
        return CGSizeMake([UIScreen screenWidth], self.collectionFooterHeight);
    }
    return CGSizeZero;
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - biu币不足时，兑换、发biu回调
- (void)reusableViewBiuReceiveFooterBiuBPay:(ReusableViewBiuReceiveFooterBiuB *)reusableView{
    ControllerBiuPayB *controller = [ControllerBiuPayB controllerWithUmiCount:0];
    controller.delegatePayUmi = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)reusableViewBiuReceiveFooterBiuBSend:(ReusableViewBiuReceiveFooterBiuB *)reusableView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 抢biu回调
- (void)reusableViewBiuReceiveFooterGrabBiu:(ReusableViewBiuReceiveFooter *)reusableView WithButton:(UIButton *)button{
    [self grabBiu:0 WithButton:button];
    self.statusButton = button;
}

#pragma mark 抢Biu的方法
- (void)grabBiu:(NSInteger )UMi WithButton:(UIButton *)button{
    if (self.profileState == 1 || self.profileState == 3){
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"收biu中..." animated:YES];
        
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"send_user_code":self.modelFaceStar.userCode,@"virtual_currency":[NSNumber numberWithInteger:UMi]};
        [httpManager POST:[XMUrlHttp xmReceiveBiuGrabBiu] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ModelResponse *response = [ModelResponse responselWithObject:responseObject];
            if (response.state == 200) {
                NSInteger status = [response.data[@"message"] integerValue];
                _countUMi = [response.data[@"virtual_currency"] integerValue];
                //0.要抢的biu已结束
                if (status == 0) {
                    button.enabled = NO;
                    [button setTitle:@"本次biubiu已结束" forState:UIControlStateNormal];
                    [hud xmSetCustomModeWithResult:NO label:@"biu已结束"];
                    //3.已经被接受
                }else if(status == 3){
                    button.enabled = NO;
                    [button setTitle:@"对方已接受" forState:UIControlStateNormal];
                    [hud xmSetCustomModeWithResult:YES label:@"对方已接受"];
                    //1.已经进入抢biu列表
                }else if(status == 1){
                    [hud xmSetCustomModeWithResult:YES label:@"已经抢啦，等待对方确认"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else if(status == 2){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"U米不足" message:@"U米不够啦，先去U米中心兑换吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"兑换U米", nil];
                    alertView.tag = Recharge;
                    [alertView show];
                }else if(status == 4){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收biu" message:[NSString stringWithFormat:@"已经有%ld个人收了TA的biubiu继续收TA的将消耗%ldU米",_countUMi * 10,_countUMi] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alertView.tag = Consumption;
                    [alertView show];
                }
                [hud hide:YES afterDelay:1.5];
                //                if (status == 0) {
                //                    //biu币不足
                //                    [hud xmSetCustomModeWithResult:NO label:@"biu币不足"];
                //                    [hud hide:YES afterDelay:1];
                //                }else if (status == 1){
                //                    //抢biubiu成功
                //                    [hud xmSetCustomModeWithResult:YES label:@"抢biu成功"];
                //                    //将按钮置为不可抢状态
                //                    self.modelBiuReceive.isGrabbbed = YES;
                //                    [self.collectionViewMain reloadSections:[NSIndexSet indexSetWithIndex:2]];
                //                    //抢biu成功后，消耗biu币
                //                    self.modelBiuReceive.biuAllCount -= self.modelBiuReceive.biuUsedCountOnce;
                //                    //强制更新联系人列表
                //                    [[DBCacheBiuContact shareDAO] updateFromNetworkWithIsForced:YES block:nil];
                //
                //                    if (self.delegateReceiveBiu) {
                //                        if ([self.delegateReceiveBiu respondsToSelector:@selector(controllerBiuBiuReceive:grabBiu:umiCount:)]) {
                //                            [self.delegateReceiveBiu controllerBiuBiuReceive:self grabBiu:self.modelFaceStar umiCount:self.modelBiuReceive.biuAllCount];
                //                        }
                //                    }
                //
                //                    [MobClick event:@"biu_grab"];
                //
                //                    self.modelBiuReceive.isGrabbbed = YES;
                //                    [self.collectionViewMain reloadData];
                //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                //                        //跳转聊天界面
                //                        ControllerChatMsg *controllerChat = [[ControllerChatMsg alloc] initWithConversationChatter:self.modelBiuReceive.userCode conversationType:EMConversationTypeChat];
                //                        [self setHidesBottomBarWhenPushed:YES];
                //                        [self.navigationController pushViewController:controllerChat animated:YES];
                //                        [hud hide:YES];
                //                    });
                //                }else if (status == 2){
                //                    //biubiu已被抢
                //                    self.modelBiuReceive.isGrabbbed = YES;
                //                    [self.collectionViewMain reloadData];
                //                    [hud xmSetCustomModeWithResult:NO label:@"biu已被抢"];
                //                    [hud hide:YES afterDelay:1];
                //                }else{
                //                    //未知错误
                //                    [hud xmSetCustomModeWithResult:NO label:@""];
                //                    [hud hide:YES afterDelay:1];
                //                }
                
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"没收到biu"];
                [hud hide:YES afterDelay:1];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud xmSetCustomModeWithResult:NO label:@"没收到biu"];
            [hud hide:YES afterDelay:1];
        }];
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"头像审核未通过" message:@"你的头像审核不通过，请上传能体现个人的真实头像哦" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [controller addAction:[UIAlertAction actionWithTitle:@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:self.imgPickController animated:YES completion:nil];
        }]];
        [self presentViewController:controller animated:YES completion:nil];
    }
}
#pragma mark UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [alertView setHidden:YES];
    }else if(buttonIndex == 1){
        if ((alertView.tag == Recharge)) {
            //进行充值操作
            [self goToRecharge];
        }else if(alertView.tag == Consumption){
            //进行消费,再调用接口
            [self grabBiu:_countUMi WithButton:self.statusButton];
        }
    }
}

#pragma mark 获取UMI的数量
- (void)goToRecharge{
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [httpManager POST:[XMUrlHttp xmGetUMi] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            NSInteger UMiCount = [response.data[@"virtual_currency"] integerValue];
            ControllerBiuPayB *controller = [ControllerBiuPayB controllerWithUmiCount:UMiCount];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - 屏蔽用户
- (void)reusableViewBiuReceiveFooterUnreceiveTA:(ReusableViewBiuReceiveFooter *)reusableView {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定屏蔽他/她？" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"" animated:YES];
        
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"user_code":self.modelFaceStar.userCode};
        [httpManager POST:[XMUrlHttp xmReceiveBiuUnreceiveTA] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ModelResponse *response = [ModelResponse modelWithJSON:responseObject];
            if (response.state == 200) {
                NSDictionary *data = response.data;
                
                [hud xmSetCustomModeWithResult:YES label:@"屏蔽成功"];
                [hud hide:YES afterDelay:3];
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"屏蔽失败"];
                [hud hide:YES afterDelay:3];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud xmSetCustomModeWithResult:NO label:@"屏蔽失败"];
            [hud hide:YES afterDelay:3];
        }];
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)reusableViewBiuReceiveHeader:(ReusableViewBiuReceiveHeader *)reusableView onClickBtnUserIdentifier:(UIButton *)btn{
    ControllerUserIdentifierGuide *controller = [ControllerUserIdentifierGuide controller];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)resuableViewBiuReceiveHeader:(ReusableViewBiuReceiveHeader*)reusableView
                     onClickDropDown:(UIButton *)btn{
    _isDropDown = !_isDropDown;
    [self rotate:btn];
    
    
}


- (void)rotate:(UIButton *)sender {
    if (_isDropDown) {
        [UIView animateWithDuration:0.5 animations:^{
            sender.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            [self.collectionViewMain reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
        }];
    }
    else {
        [UIView animateWithDuration:0.5 animations:^{
            sender.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            [self.collectionViewMain reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
        }];
    }
}

- (void)controllerBiuPayB:(ControllerBiuPayB *)controller payRes:(BOOL)res umiCount:(NSInteger)count{
    if (res) {
        self.modelBiuReceive.biuAllCount = count;
        [self.collectionViewMain reloadData];
        
        if (self.delegateReceiveBiu) {
            if ([self.delegateReceiveBiu respondsToSelector:@selector(controllerBiuBiuReceive:umiCount:)]) {
                [self.delegateReceiveBiu controllerBiuBiuReceive:self umiCount:count];
            }
        }
    }
}

- (void)reusableViewBiuReceiveHeader:(ReusableViewBiuReceiveHeader *)reusableView profileUrl:(NSString *)url{
    UIImageView *imgViewProfile = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen screenWidth]/2, [UIScreen screenHeight]/2, 0, 0)];
    imgViewProfile.alpha = 0;
    imgViewProfile.contentMode = UIViewContentModeScaleAspectFit;
    imgViewProfile.backgroundColor = [UIColor blackColor];
    [imgViewProfile setImageWithURL:[NSURL URLWithString:url] placeholder:nil];
    imgViewProfile.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.3 animations:^{
            imgViewProfile.alpha = 0;
        } completion:^(BOOL finished) {
            [imgViewProfile removeFromSuperview];
        }];
    }];
    [imgViewProfile addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:imgViewProfile];
    [UIView animateWithDuration:0.5 animations:^{
        imgViewProfile.frame = CGRectMake(0, 0, [UIScreen screenWidth], [UIScreen screenHeight]);
        imgViewProfile.alpha = 1;
    }];
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

- (UIImagePickerController *)imgPickController{
    if (!_imgPickController) {
        _imgPickController = [[UIImagePickerController alloc] init];
        _imgPickController.delegate = self;
        _imgPickController.allowsEditing = YES;
        _imgPickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return _imgPickController;
}

- (NSInteger)profileState{
    return 3;
}

@end
