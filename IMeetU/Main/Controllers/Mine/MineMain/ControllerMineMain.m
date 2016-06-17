//
//  ControllerMineMain.m
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerMineMain.h"
#import <YYKit/YYKit.h>
#import "UINib+Plug.h"
#import "NSDate+plug.h"
#import "UIColor+Plug.h"
#import "UIStoryboard+Plug.h"
#import "XMNibStoryboardFilesName.h"

#import "ModelUser.h"
#import "EmptyController.h"

#import "CellMineMainProfileAndPhotos.h"
#import "CellMineMainPersonalIntroductions.h"
#import "CellMineMainBaseInfo.h"
#import "CellMineMainTags.h"
#import "CellMineMainTableViewHeader.h"
#import "CellMineMainFooter.h"

#import "ViewMineMainAlterProfile.h"

#import "ControllerMinePhotoBrowse.h"
#import "ControllerMineAlterName.h"
#import "ControllerMineAlterBirthday.h"
#import "ControllerMineAlterConstellation.h"
#import "ControllerMineAlterAboutMe.h"
#import "ControllerMineAlterAddress.h"
#import "ControllerMineAlterBodyHeightWeight.h"
#import "ControllerMineAlterIdentityProfession.h"
#import "ControllerMineAlterCompany.h"
#import "ControllerSelectSchool.h"
#import "ControllerMineAlterCharacter.h"
#import "ControllerMineAlterInterest.h"

#import "UserDefultAccount.h"

#import "AFNetworking.h"

#import "XMUrlHttp.h"
#import "ModelResponse.h"
#import "ModelResponseMine.h"
#import "ModelResponseMineHeader.h"
#import "ModelResponseOSSSecurityToke.h"
#import "ModelRequestMineInfoUpdate.h"

#import "XMOSS.h"

#import "ModelCharacher.h"
#import "ModelMineAlterInterest.h"

#import "ModelMinePhoto.h"

#import "MBProgressHUD+plug.h"
#import "XMActionSheetMineMainMore.h"

#import "XMHttpPersonal.h"

#import "ControllerUserIdentifierGuide.h"
#import "ControllerUserLoginOrRegister.h"

#import "AppDelegate.h"
#import "ControllerBiuBiu.h"
#import "ControllerBiuPayB.h"
#import "ControllerMatchSetting.h"

#import "ControllerUserLogin.h"
#import "ControllerUserRegisterThirdStep.h"

#import "ControllerTabBarMain.h"

#import "XMHttpCommunity.h"
#import "MLToast.h"
#import "ControllerChatMsg.h"
#import "ControllerSamePostList.h"

#import "UIColor+Plug.h"

@interface ControllerMineMain ()<UITableViewDataSource, UITableViewDelegate, CellMineMainPersonalIntroductionsDelegate, CellMineMainProfileAndPhotosDelegate, ControllerMineAlterCharacterDelegate, ControllerMineAlterInterestDelegate, ViewMineMainAlterProfileDelegate, ControllerMineAlterNameDelegate, ControllerMineAlterBirthdayDelegate, ControllerMineAlterConstellationDelegate, ControllerMineAlterAboutMeDelegate, ControllerMineAlterAddressDelegate, ControllerMineAlterBodyHeightWeightDelegate, ControllerMineAlterIdentityProfessionDelegate, ControllerMineAlterCompanyDelegate, ControllerSelectSchoolDelegate, ControllerMinePhotoBrowseDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XMActionSheetMineMainMoreDelegate>

@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) ModelResponseMine *mineInfo;
@property (nonatomic, strong) NSArray *interestModels;
@property (nonatomic, strong) UIImagePickerController *pickControllerImg;
@property (nonatomic, strong) UIImagePickerController *pickControllerProfile;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewHUD;

@property (nonatomic, strong) ViewMineMainAlterProfile *viewMineMainAlterProfile;

@property (weak, nonatomic) IBOutlet UIView *viewLoginRegister;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnUmi;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UILabel *labelNameNick;

/**
 *  是否正在加载个人信息
 */
@property (nonatomic, assign) BOOL userInfoIsLoading;
/**
 *  个人信息是否已加载完毕
 */
@property (nonatomic, assign) BOOL userInfoIsLoaded;

@property (nonatomic, assign) MineMainGetUserCodeFrom getUserCodeFrom;
@property (nonatomic, strong) UIButton *biuButton;
@end

@implementation ControllerMineMain

+ (instancetype)controllerWithUserCode:(NSString *)userCode getUserCodeFrom:(MineMainGetUserCodeFrom)getUserCodeFrom{
    ControllerMineMain *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameMine indentity:@"ControllerMineMain"];
    
    controller.getUserCodeFrom = getUserCodeFrom;
    if (getUserCodeFrom == MineMainGetUserCodeFromParam) {
        controller.userCode = userCode;
        controller.isMine = [userCode isEqualToString:[UserDefultAccount userCode]];
    }else{
        controller.isMine = YES;
    }
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellMineMainProfileAndPhotos] forCellReuseIdentifier:NibXMCellMineMainProfileAndPhotos];
    [self.tableView registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellMineMainPersonalIntroductions] forCellReuseIdentifier:NibXMCellMineMainPersonalIntroductions];
    [self.tableView registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellMineMainBaseInfo] forCellReuseIdentifier:NibXMCellMineMainBaseInfo];
    [self.tableView registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellMineMainTags] forCellReuseIdentifier:NibXMCellMineMainTags];
    [self.tableView registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellMineMainTableViewHeader] forCellReuseIdentifier:NibXMCellMineMainTableViewHeader];
    [self.tableView registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellMineMainFooter] forCellReuseIdentifier:NibXMCellMineMainFooter];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.btnBack.hidden = !(self.getUserCodeFrom == MineMainGetUserCodeFromParam);
    self.btnUmi.hidden = (self.getUserCodeFrom == MineMainGetUserCodeFromParam);
    self.btnMore.hidden = self.isMine;
    self.btnSetting.hidden = !self.isMine;
    
    [self.labelNameNick setText:@""];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!_isMine) {
        if (self.tabBarController.tabBar.hidden) {
            [self.view addSubview:self.biuButton];
        }
    }
}

- (void)biuButtonClick:(UIButton *)button{
    //建立关系
    if (button.tag == 10001) {
        [[XMHttpCommunity http] grabCommBiuWithUserCode:[_userCode integerValue]  withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                [[MLToast toastInView:self.view content:@"biu成功啦,等待对方确认"] show];
            }else{
                [[MLToast toastInView:self.view content:@"biu失败了~"] show];
            }
        }];
    }
    //进入聊天页面
    else if(button.tag == 10002){
        ControllerChatMsg *controllerChat = [[ControllerChatMsg alloc] initWithConversationChatter:_userCode    conversationType:EMConversationTypeChat backController:self];
        [controllerChat setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controllerChat animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = YES;
    
    //当未登录时显示登录注册视图
    self.viewLoginRegister.hidden = [UserDefultAccount isLogin];
    
    if ([UserDefultAccount isLogin]) {
        if (!self.userInfoIsLoaded) {
            //已登录而且还未加载时，加载个人信息
            [self loadUserInfo:self.userCode];
        }
    }else{
        self.userInfoIsLoaded = NO;
        self.mineInfo = nil;
    }
    
    if (self.navigationController.viewControllers.count != 1) {
        self.tabBarController.tabBar.hidden = YES;
    }

}

- (void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)loadUserInfo:(NSString *)userCode{
    if (!self.userInfoIsLoading){
        self.userInfoIsLoading = YES;
        
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"code":userCode, @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewHUD label:@"" animated:YES];
        
        [httpManager POST:[XMUrlHttp xmMineInfo] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.userInfoIsLoading = NO;
            self.userInfoIsLoaded = YES;
            
            ModelResponse *response = [ModelResponse responselWithObject:responseObject];
            if (response.state == 200) {
                ModelResponseMineHeader *mineHeader = [ModelResponseMineHeader modelWithJSON:response.data];
                self.mineInfo = [ModelResponseMine modelWithJSON:mineHeader.userinfo];
                [UserDefultAccount setUserProfileStatus:self.mineInfo.profileStatus];
                
                self.mineInfo.profileCircle = self.mineInfo.profileOrigin;
                [self.labelNameNick setText:self.mineInfo.nameNick];
                //进行状态的判定
                NSInteger biuCode = self.mineInfo.biuCode;
                if (biuCode == 0 || biuCode == 1) {
                    [_biuButton setTitle:@"biu一下" forState:UIControlStateNormal];
                    _biuButton.tag = 10001;
                }else if(biuCode == 2){
                    [_biuButton setTitle:@"和TA聊聊" forState:UIControlStateNormal];
                    _biuButton.tag = 10002;
                }
                [self.tableView reloadData];
                
                if ((!self.mineInfo.school || self.mineInfo.school.length==0) && self.isMine){
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"完善资料" message:@"完善学校信息，遇见更好的TA" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        ControllerSelectSchool *controller = [ControllerSelectSchool controllerViewSelectSchool];
                        controller.delegateSelegateSchool = self;
                        [self.navigationController pushViewController:controller animated:YES];
                    }]];
                    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:controller animated:YES completion:nil];
                }
            }else{
                
            }
            [hud hide:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.userInfoIsLoading = NO;
            [hud hide:YES];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 8;
    }else if (section == 3){
        return 3;
    }else if (section == 4){
        return 2;
    }else if (section == 5){
        return 2;
    }else if (section == 6){
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [CellMineMainProfileAndPhotos viewHeight];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 35;
        }else if (indexPath.row == 1){
            return [CellMineMainPersonalIntroductions viewHeightWithContent:self.mineInfo.aboutMe isOpen:self.isOpen isMine:self.isMine];
        }else if (indexPath.row == 2){
            return [CellMineMainBaseInfo viewHeight];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 35;
        }
        return [CellMineMainBaseInfo viewHeight];
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            return 35;
        }
        return [CellMineMainBaseInfo viewHeight];
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            return 35;
        }
        return [CellMineMainTags viewHeightWithTagCount:self.mineInfo.characters.count];
    }else if (indexPath.section == 5){
        if (indexPath.row == 0) {
            return 35;
        }
        return [CellMineMainTags viewHeightWithTagCount:self.mineInfo.interests.count];
    }else if (indexPath.section == 6){
        return 130;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        CellMineMainProfileAndPhotos *cellProfileAndPhotos = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainProfileAndPhotos forIndexPath:indexPath];
        [cellProfileAndPhotos initWithMine:self.mineInfo isMine:self.isMine isShowBtnBack:(self.getUserCodeFrom == MineMainGetUserCodeFromParam)];
        cellProfileAndPhotos.delegateCell = self;
        cell = cellProfileAndPhotos;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            CellMineMainTableViewHeader *cellHeader = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainTableViewHeader forIndexPath:indexPath];
            [cellHeader initWithSection:indexPath.section];
            cell = cellHeader;
        }else if(indexPath.row == 1){
            CellMineMainPersonalIntroductions *cellPersonalIntroductions = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainPersonalIntroductions forIndexPath:indexPath];
            [cellPersonalIntroductions initWithContent:self.mineInfo.aboutMe isOpen:self.isOpen isMine:self.isMine];
            cellPersonalIntroductions.delegateCell = self;
            cell = cellPersonalIntroductions;
        }else if (indexPath.row == 2){
            CellMineMainBaseInfo *cellBaseInfo = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainBaseInfo forIndexPath:indexPath];
            [cellBaseInfo initWithIsMine:self.isMine indexPath:indexPath mineInfo:nil];
            cell = cellBaseInfo;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            CellMineMainTableViewHeader *cellHeader = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainTableViewHeader forIndexPath:indexPath];
            [cellHeader initWithSection:indexPath.section];
            cell = cellHeader;
        }else{
            CellMineMainBaseInfo *cellBaseInfo = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainBaseInfo forIndexPath:indexPath];
            cell = cellBaseInfo;
            [cellBaseInfo initWithIsMine:self.isMine indexPath:indexPath mineInfo:self.mineInfo];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            CellMineMainTableViewHeader *cellHeader = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainTableViewHeader forIndexPath:indexPath];
            [cellHeader initWithSection:indexPath.section];
            cell = cellHeader;
        }else{
            CellMineMainBaseInfo *cellBaseInfo = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainBaseInfo forIndexPath:indexPath];
            cell = cellBaseInfo;
            [cellBaseInfo initWithIsMine:self.isMine indexPath:indexPath mineInfo:self.mineInfo];
        }
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            CellMineMainTableViewHeader *cellHeader = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainTableViewHeader forIndexPath:indexPath];
            [cellHeader initWithSection:indexPath.section];
            cell = cellHeader;
        }else{
            CellMineMainTags *cellTags = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainTags forIndexPath:indexPath];
            [cellTags initWithCharacters:self.mineInfo.characters indexPath:indexPath isMine:self.isMine];
            cell = cellTags;
        }
    }else if (indexPath.section == 5){
        if (indexPath.row == 0) {
            CellMineMainTableViewHeader *cellHeader = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainTableViewHeader forIndexPath:indexPath];
            [cellHeader initWithSection:indexPath.section];
            cell = cellHeader;
        }else{
            CellMineMainTags *cellTags = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainTags forIndexPath:indexPath];
            [cellTags initWithInterests:self.mineInfo.interests indexPath:indexPath isMine:self.isMine];
            cell = cellTags;
        }
    }else if (indexPath.section == 6){
        CellMineMainFooter *cellFooter = [tableView dequeueReusableCellWithIdentifier:NibXMCellMineMainFooter forIndexPath:indexPath];
        cell = cellFooter;
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    if (!self.isMine) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - tableView选中代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     if (indexPath.section==1 && indexPath.row==2) {
        //进入个人动态
        ControllerSamePostList *controllerSamePostList = [ControllerSamePostList controllerSamePostList];
        controllerSamePostList.isMyPostList = YES;
        controllerSamePostList.userCode = [self.userCode integerValue];
        controllerSamePostList.titleName = _isMine ? @"个人动态":@"TA的动态";
        [self.navigationController pushViewController:controllerSamePostList animated:YES];
     }
    if (!self.isMine) {
        return;
    }
    if (indexPath.section==1 && indexPath.row==1) {
        ControllerMineAlterAboutMe *controller = [ControllerMineAlterAboutMe controllerMineAlterAboutMe:self.mineInfo.aboutMe];
        controller.delegateAlterAboutMe = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==2 && indexPath.row==1) {
        ControllerMineAlterName *controller = [ControllerMineAlterName controllerMyAlterName:self.mineInfo.nameNick];
        controller.delegateAlterName = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==2 && indexPath.row==3) {
        ControllerMineAlterBirthday *controller = [ControllerMineAlterBirthday controllerMyAlterBirthdayWithDate:self.mineInfo.birthday];
        controller.delegateAlterBirthday = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==2 && indexPath.row==4) {
        ControllerMineAlterConstellation *controller = [ControllerMineAlterConstellation controllerMineAlterConstellation:self.mineInfo.constellation birthday:self.mineInfo.birthday];
        controller.delegateAlterConstellation = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==2 && indexPath.row==5) {
        ControllerMineAlterAddress *controller = [ControllerMineAlterAddress controllerMyAlterAddress:self.mineInfo.city operateStr:@"City"];
        controller.delegateAlterAddress = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==2 && indexPath.row==6) {
        ControllerMineAlterAddress *controller = [ControllerMineAlterAddress controllerMyAlterAddress:self.mineInfo.homeTown operateStr:@"HomeTown"];
        controller.delegateAlterAddress = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==2 && indexPath.row==7) {
        ControllerMineAlterBodyHeightWeight *controller = [ControllerMineAlterBodyHeightWeight controllerWithHeight:self.mineInfo.bodyHeight weight:self.mineInfo.bodyWeight];
        controller.delegateAlterBodyHeightWeight = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==3 && indexPath.row==1) {
        ControllerMineAlterIdentityProfession *controller = [ControllerMineAlterIdentityProfession controllerWithProfession:self.mineInfo.profession isGraduated:self.mineInfo.isGraduated];
        controller.previousController = self;
        controller.delegateAlterIdentityProfession = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==3 && indexPath.row==2) {
        ControllerSelectSchool *controller = [ControllerSelectSchool controllerViewSelectSchool];
        controller.delegateSelegateSchool = self;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==4 && indexPath.row==1) {
        ControllerMineAlterCharacter *controller = [ControllerMineAlterCharacter controllerWithCharacters:self.mineInfo.characters gender:self.mineInfo.gender];
        controller.delegateAlterCharacter = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==5 && indexPath.row==1){
        ControllerMineAlterInterest *controller = [ControllerMineAlterInterest controllerWithInterests:self.mineInfo.interests];
        controller.delegateAlterInterest = self;
        //[controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 个人介绍：展开关闭按钮回调
- (void)cellMineMainPersonalIntroductions:(CellMineMainPersonalIntroductions *)cell isOpen:(BOOL)isOpen{
    self.isOpen = isOpen;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -进入主页购买U币
-(void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos *)cell onClickBuyUMi:(UIButton *)btn{
    //获取U币，进行相关的操作
    [self goToRecharge];
}

- (void)goToRecharge{
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [httpManager POST:[XMUrlHttp xmGetUMi] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            NSInteger UMiCount = [response.data[@"virtual_currency"] integerValue];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - 点击头像：打开头像预览界面
- (void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos *)cell onClickBtnProfile:(UIButton *)btn{
    self.viewMineMainAlterProfile = [ViewMineMainAlterProfile viewMineMainAlterProfileWithIsMine:self.isMine];
    self.viewMineMainAlterProfile.delegateProfile = self;
    [self.viewMineMainAlterProfile showWithUrl:self.mineInfo.profileOrigin superView:self.view];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)xmActionSheetMineMainMoreReport:(XMActionSheetMineMainMore *)view{
    [view hiddenAndDestory];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"举报" message:@"举报后就交给小U来对付吧" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewHUD label:@"举报" animated:YES];
        [[XMHttpPersonal http] xmReportWithUserCode:self.userCode reason:@"" block:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                [hud xmSetCustomModeWithResult:YES label:@"已举报"];
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"举报失败"];
            }
            [hud hide:YES afterDelay:0.5];
        }];
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark 特殊身份标识
- (void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos *)cell onClickBtnUserIdentifier:(UIButton *)btn{
    ControllerUserIdentifierGuide *controller = [ControllerUserIdentifierGuide controller];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)xmActionSheetMineMainMoreCancel:(XMActionSheetMineMainMore *)view{
    [view hiddenAndDestory];
}

#pragma mark - 照片墙
#pragma mark 照片墙：添加照片
- (void)cellMineMainProfileAndPhotosAddPhotos:(CellMineMainProfileAndPhotos *)cell{
    [self presentViewController:self.pickControllerImg animated:YES completion:^{
    }];
}

#pragma mark 照片墙：浏览大图
- (void)cellMineMainProfileAndPhotos:(CellMineMainProfileAndPhotos *)cell photoIndexPath:(NSIndexPath *)indexPath{
    ControllerMinePhotoBrowse *controller = [ControllerMinePhotoBrowse controllerWithPhotos:self.mineInfo.photos startIndex:indexPath.row isMine:self.isMine];
    controller.delegatePhotoBrowse = self;
    //[controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 照片墙：删除照片回调
- (void)controllerMinePhotoBrowse:(ControllerMinePhotoBrowse *)controller deletePhotos:(NSArray *)photoss{
    self.mineInfo.photos = [NSMutableArray arrayWithArray:photoss];
    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 照片选择器代理方法:更新头像，增加照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewHUD animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"正在上传...";
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
            UIImage *imgPick;
            NSString *prefix;
            if (self.pickControllerProfile == picker) {
                prefix = @"profile";
                imgPick = [info objectForKey:UIImagePickerControllerEditedImage];
            }else if (self.pickControllerImg == picker){
                prefix = @"photos";
                imgPick = [info objectForKey:UIImagePickerControllerOriginalImage];
            }
            
            [XMOSS uploadFileWithImg:imgPick prefix:prefix progress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                hud.progress = totalByteSent/1.0/totalBytesExpectedToSend*1.0;
            } finish:^id(OSSTask *task, NSString *fileName) {
                
                if (!task.error) {
                    NSString *postUrl;
                    NSDictionary *parameters;
                    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
                    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
                    
                    if (self.pickControllerProfile == picker) {
                        postUrl = [XMUrlHttp xmUpdateProfile];
                        parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"icon_url":fileName};
                    }else if (self.pickControllerImg == picker){
                        postUrl = [XMUrlHttp xmPhotoAdd];
                        parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"photo":fileName};
                    }
                    
                    [httpManager POST:postUrl parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                        if (response.state == 200) {
                            NSDictionary *dicRes = response.data;
                            
                            if (self.pickControllerProfile == picker) {
                                self.mineInfo.profileCircle = dicRes[@"icon_thumbnailUrl"];
                                self.mineInfo.profileOrigin = dicRes[@"icon_url"];
                                [UserDefultAccount setUserProfileUrlThumbnail:dicRes[@"icon_thumbnailUrl"]];
                                [UserDefultAccount setUserProfileStatus:1];
                            }else if (self.pickControllerImg == picker){
                                ModelMinePhoto *photo = [[ModelMinePhoto alloc] init];
                                photo.photoName = dicRes[@"photo_name"];
                                photo.photoCode = dicRes[@"photo_code"];
                                photo.photoUrlOrigin = dicRes[@"photo_url"];
                                photo.photoUrlThumbnail = dicRes[@"photo_thumbnailUrl"];
                                [self.mineInfo.photos addObject:photo];
                            }
                            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                            [hud hide:YES];
                        }else{
                            [hud hide:YES];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [hud hide:YES];
                    }];
                    
                    
                }else{
                    [hud hide:YES];
                }
                return nil;
            }];
        }else{
            [hud hide:YES];
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 更改昵称
- (void)controllerMineAlterName:(ControllerMineAlterName *)controller nameNick:(NSString *)nameNick{
    ModelRequestMineInfoUpdate *model = [[ModelRequestMineInfoUpdate alloc] init];
    model.nameNick = nameNick;
    model.parameters = ModelRequestMineInfoUpdateNameNick;
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.nameNick = nameNick;
            [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadRow:1 inSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            
        }
    }];
    
}

#pragma mark - 更改关于我
- (void)controllerMineAlterAboutMe:(ControllerMineAlterAboutMe *)controller aboutMe:(NSString *)aboutMe{
    ModelRequestMineInfoUpdate *model = [[ModelRequestMineInfoUpdate alloc] init];
    model.aboutMe = aboutMe;
    model.parameters = ModelRequestMineInfoUpdateAboutMe;
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.aboutMe = aboutMe;
            [self.tableView reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            
        }
    }];
    
}

#pragma mark - 更改生日
- (void)controllerMineAlterBirthday:(ControllerMineAlterBirthday *)controller birthday:(NSDate *)birthday{
    
    ModelRequestMineInfoUpdate *model = [[ModelRequestMineInfoUpdate alloc] init];
    model.birthday = [NSDate timeDateFormatYMD:birthday];
    model.parameters = ModelRequestMineInfoUpdateBirthday;
    
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.birthday = birthday;
            [self.tableView reloadRow:3 inSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
        
        }
    }];
}

#pragma mark - 更改星座
- (void)controllerMineAlterConstellation:(ControllerMineAlterConstellation *)controller constellation:(NSString *)constellation{
    ModelRequestMineInfoUpdate *model = [[ModelRequestMineInfoUpdate alloc] init];
    model.constellation = constellation;
    model.parameters = ModelRequestMineInfoUpdateConstellation;
    
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.constellation = constellation;
            [self.tableView reloadRow:4 inSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
        
        }
    }];
}

#pragma mark - 修改地址：城市/家乡
- (void)controllerMineAlterAddress:(ControllerMineAlterAddress *)controller address:(NSString *)address addressId:(NSString *)addressId cityNum:(NSString *)cityNum operateStr:(NSString *)operateStr{
    ModelRequestMineInfoUpdate *model = [[ModelRequestMineInfoUpdate alloc] init];
    if ([@"City" isEqualToString:operateStr]) {
        model.city = addressId;
        model.cityNum = cityNum;
        model.parameters = ModelRequestMineInfoUpdateCity;
    }else if ([@"HomeTown" isEqualToString:operateStr]){
        model.homeTown = addressId;
        model.parameters = ModelRequestMineInfoUpdateHometown;
    }

    
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            if ([@"City" isEqualToString:operateStr]) {
                self.mineInfo.city = addressId;
                [self.tableView reloadRow:5 inSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
            }else if ([@"HomeTown" isEqualToString:operateStr]){
                self.mineInfo.homeTown = addressId;
                [self.tableView reloadRow:6 inSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }else{
        
        }
    }];
}

#pragma mark - 修改身高体重
- (void)controllerMineAlterBodyHeightWeight:(ControllerMineAlterBodyHeightWeight *)controller height:(NSInteger)height weight:(NSInteger)weight{
    ModelRequestMineInfoUpdate *model = [[ModelRequestMineInfoUpdate alloc] init];
    model.bodyHeight = height;
    model.bodyWeight = weight;
    model.parameters = ModelRequestMineInfoUpdateHeightWeight;
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.bodyHeight = height;
            self.mineInfo.bodyWeight = weight;
            [self.tableView reloadRow:7 inSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
        
        }
    }];
}

#pragma mark - 修改身份
- (void)controllerMineAlterIdentityProfession:(ControllerMineAlterIdentityProfession *)controller isGraduated:(NSInteger)isGraduated profession:(NSString *)profession schoolId:(NSString *)schoolId schoolName:(NSString *)schoolName{
    ModelRequestMineInfoUpdate *model = [[ModelRequestMineInfoUpdate alloc] init];
    model.isGraduated = isGraduated;
    if (isGraduated==1) {
        model.profession = @"学生党";
    }else if(isGraduated==2){
        model.profession = @"毕业族";
    }
    model.parameters = ModelRequestMineInfoUpdateIsStudentProfession;
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.isGraduated = isGraduated;
            self.mineInfo.profession = profession;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
        
        }
    }];
}

#pragma mark - 修改公司
- (void)controllerMineAlterCompany:(ControllerMineAlterCompany *)controller company:(NSString *)company{
    ModelRequestMineInfoUpdate *model = [ModelRequestMineInfoUpdate model];
    model.company = company;
    model.parameters = ModelRequestMineInfoUpdateCompany;
    
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.company = company;
            [self.tableView reloadRow:2 inSection:3 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
        
        }
    }];
}

#pragma mark - 修改学校
- (void)controllerSelectSchool:(ControllerSelectSchool *)controller schoolName:(NSString *)schoolName schoolId:(NSString *)schoolId{
    [controller.navigationController popViewControllerAnimated:YES];
    
    ModelRequestMineInfoUpdate *model = [ModelRequestMineInfoUpdate model];
    model.school = schoolId;
    model.parameters = ModelRequestMineInfoUpdateSchool;
    
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.school = schoolId;
            [self.tableView reloadRow:2 inSection:3 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
        
        }
    }];
    
}

#pragma mark - 修改个性标签
- (void)controllerMineAlterCharacter:(ControllerMineAlterCharacter *)controller selecteds:(NSArray *)selecteds{
    ModelRequestMineInfoUpdate *model = [ModelRequestMineInfoUpdate model];
    model.parameters = ModelRequestMineInfoUpdateCharacter;
    NSMutableString *characterIds = [NSMutableString string];
    for (int i=0; i<selecteds.count; i++) {
        ModelCharacher *character = selecteds[i];
        if (i != 0) {
            [characterIds appendString:@","];
        }
        [characterIds appendString:character.code];
    }
    model.characters = characterIds;
    
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.characters = selecteds;
            [self.tableView reloadSection:4 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            NSLog(@"----------->failed");
        }
    }];
}

#pragma mark - 修改兴趣标签
- (void)controllerMineAlterInterest:(ControllerMineAlterInterest *)controller selecteds:(NSArray *)selecteds{
    ModelRequestMineInfoUpdate *model = [ModelRequestMineInfoUpdate model];
    model.parameters = ModelRequestMineInfoUpdateInterests;
    NSMutableString *interestIds = [NSMutableString string];
    for (int i=0; i<selecteds.count; i++) {
        ModelMineAlterInterest *interest = selecteds[i];
        if (i != 0) {
            [interestIds appendString:@","];
        }
        [interestIds appendString:interest.interestCode];
    }
    model.interests = interestIds;
    
    [self updateWithModel:model result:^(bool successed) {
        if (successed) {
            self.mineInfo.interests = selecteds;
            [self.tableView reloadSection:5 withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            
        }
    }];
    
}

#pragma mark - 更新头像：打开照片选择器
- (void)viewMineMainAlterProfileAfterReadingDialog:(ViewMineMainAlterProfile *)view{    
    [self presentViewController:self.pickControllerProfile animated:YES completion:^{
        [self.viewMineMainAlterProfile hiddenAndRemove];
    }];
    
    if (self.getUserCodeFrom == MineMainGetUserCodeFromUserDefult) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)viewMineMainAlterProfileClose:(ViewMineMainAlterProfile *)view{
    if (self.getUserCodeFrom == MineMainGetUserCodeFromUserDefult) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (UIImagePickerController *)pickControllerImg{
    if (!_pickControllerImg) {
        _pickControllerImg = [[UIImagePickerController alloc] init];
        _pickControllerImg.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickControllerImg.delegate = self;
        _pickControllerImg.allowsEditing = NO;
    }
    return _pickControllerImg;
}

- (UIImagePickerController *)pickControllerProfile{
    if (!_pickControllerProfile) {
        _pickControllerProfile = [[UIImagePickerController alloc] init];
        _pickControllerProfile.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickControllerProfile.delegate = self;
        _pickControllerProfile.allowsEditing = YES;
    }
    return _pickControllerProfile;
}

- (void)updateWithModel:(ModelRequestMineInfoUpdate*)model result:(void(^)(bool successed))result{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    model.token = [UserDefultAccount token];
    model.deviceCode = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [httpManager POST:[XMUrlHttp xmUpdateMineInfo] parameters:@{@"data":[model modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            [UserDefultAccount updateUserName:model.nameNick];
            result(YES);
        }else{
            result(NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        result(NO);
    }];
}


#pragma mark - 登录、注册
- (IBAction)onClickBtnRegister:(id)sender {
    ControllerUserRegisterThirdStep *controller = [ControllerUserRegisterThirdStep controller];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClickBtnLogin:(id)sender {
    ControllerUserLogin *controller = [ControllerUserLogin controller];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnUmi:(id)sender {
    ControllerBiuPayB *controller = [ControllerBiuPayB controllerWithUmiCount:0];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClickBtnSetting:(id)sender {
    ControllerMatchSetting *matchSettingController = [ControllerMatchSetting controller];
    matchSettingController.controllerType = ControllerTypeSetUp;
    [self.navigationController pushViewController:matchSettingController animated:YES];
}

- (IBAction)onClickBtnMore:(id)sender {
    XMActionSheetMineMainMore *actionSheet = [XMActionSheetMineMainMore actionSheet];
    actionSheet.delegateActionSheet = self;
    [actionSheet showInView:self.view];
}

//当个人主页是由tabbarController创建时，userCode从缓存中取
- (NSString *)userCode{
    if (self.getUserCodeFrom == MineMainGetUserCodeFromUserDefult) {
        _userCode = [UserDefultAccount userCode];
    }
    return _userCode;
}


- (UIButton *)biuButton{
    if (!_biuButton) {
        _biuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _biuButton.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
        [_biuButton setBackgroundColor:[UIColor often_6CD1C9:1]];
        [_biuButton setTitle:@"抢biu" forState:UIControlStateNormal];
        [_biuButton setTintColor:[UIColor whiteColor]];
        [_biuButton addTarget:self action:@selector(biuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_biuButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _biuButton;
}
@end
