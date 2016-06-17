//
//  ControllerMatchSetting.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerMatchSetting.h"
#import <YYKit/YYKit.h>
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"
#import "ControllerMineAlterCharacter.h"
#import "ModelMatchSetting.h"
#import "ModelMatchSettingUpdate.h"

#import "CellCollectionMatchSettingCharacter.h"
#import "ReusableViewMatchSettingHeader.h"
#import "ReusableViewMatchSettingFooter.h"

#import "AFNetworking.h"
#import "XMUrlHttp.h"
#import "ModelResponse.h"

#import "UserDefultAccount.h"
#import "ModelCharacher.h"

#import "EMSDK.h"

#import "ControllerMineAlterCharacter.h"
#import "ModelRequestMineInfoUpdate.h"

#import "MLToast.h"
#import "UserDefultSetting.h"
#import "AppDelegate.h"

#import "UMSocial.h"
#import "ControllerAboutIU.h"
#import "ViewNewComerGuide.h"
#import "ControllerTabBarMain.h"

#import "DBCacheBiuBiu.h"
#import "ControllerTabBarMain.h"

#define CellCollectionMatchSettingCharacterIdentifier @"CellCollectionMatchSettingCharacter"
#define ReusableViewMatchSettingHeaderIdentifier @"ReusableViewMatchSettingHeader"
#define ReusableViewMatchSettingFooterIdentifier @"ReusableViewMatchSettingFooter"

@interface ControllerMatchSetting ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ControllerMineAlterCharacterDelegate, ReusableViewMatchSettingHeaderDelegate, ReusableViewMatchSettingFooterDelegate, ControllerMineAlterCharacterDelegate>

@property (nonatomic, strong) ModelMatchSetting *modelMatchSetting;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewSettting;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

/**
 *  更新自己或匹配个性标签：1-自己，2-匹配
 */
@property (nonatomic, assign) NSInteger updateCharterMineOrMacth;
@end

@implementation ControllerMatchSetting

+ (instancetype)controller{
    ControllerMatchSetting *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameSetting indentity:@"ControllerMatchSetting"];
    
    return controller;
}

- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelMatchSetting = nil;
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [httpManager POST:[XMUrlHttp xmMatchSetting] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        if (response.state == 200) {
            self.modelMatchSetting = [ModelMatchSetting modelWithDictionary:response.data];
            
            [self.collectionViewSettting reloadData];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [self.collectionViewSettting registerNib:[UINib xmNibFromMainBundleWithName:CellCollectionMatchSettingCharacterIdentifier] forCellWithReuseIdentifier:CellCollectionMatchSettingCharacterIdentifier];
    [self.collectionViewSettting registerNib:[UINib xmNibFromMainBundleWithName:ReusableViewMatchSettingHeaderIdentifier] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewMatchSettingHeaderIdentifier];
    [self.collectionViewSettting registerNib:[UINib xmNibFromMainBundleWithName:ReusableViewMatchSettingFooterIdentifier] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewMatchSettingFooterIdentifier];
    self.collectionViewSettting.backgroundColor = [UIColor whiteColor];
    self.collectionViewSettting.collectionViewLayout = layout;
    self.collectionViewSettting.dataSource = self;
    self.collectionViewSettting.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(ControllerTypeSetUp == _controllerType){
        return 0;
    }
    return self.modelMatchSetting.characters.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellCollectionMatchSettingCharacter *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellCollectionMatchSettingCharacterIdentifier forIndexPath:indexPath];
    [cell initWithModel:self.modelMatchSetting.characters[indexPath.row]];
    
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
            ReusableViewMatchSettingHeader *reusableViewHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewMatchSettingHeaderIdentifier forIndexPath:indexPath];
            [reusableViewHeader initWithModel:self.modelMatchSetting];
            
            reusableViewHeader.delegateReusableView = self;
            reusableView = reusableViewHeader;
    }else if(kind == UICollectionElementKindSectionFooter){
            ReusableViewMatchSettingFooter *reusableViewFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewMatchSettingFooterIdentifier forIndexPath:indexPath];
            [reusableViewFooter initWithModel:self.modelMatchSetting];
            
            reusableViewFooter.delegateMatchSetting = self;
            reusableView = reusableViewFooter;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(53, 25);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.controllerType == ControllerTypeFilter) {
        self.titleName.text = @"筛选";
       return CGSizeMake([UIScreen screenWidth], 332);
    }
    self.titleName.text = @"设置";
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if(self.controllerType == ControllerTypeSetUp){
        return CGSizeMake([UIScreen screenWidth], [UIScreen screenHeight]);
    }
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat margin = ([UIScreen screenWidth]-53*4-28*3)/2-1;
    if (self.modelMatchSetting.characters.count == 0 || self.controllerType == ControllerTypeSetUp) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(13, margin, 14, margin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 28;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 13;
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reusableViewMatchSettingHeader:(ReusableViewMatchSettingHeader *)reusableView alterGender:(NSInteger)gender{
    ModelMatchSettingUpdate *model = [ModelMatchSettingUpdate model];
    model.gender = gender;
    model.characters = @"";
    model.parameters = ModelMatchSettingGender;
    
    [self updateWithModel:model result:^(BOOL successed) {
        if (successed) {
            self.modelMatchSetting.gender = gender;
            self.modelMatchSetting.characters = nil;
            //清空本地数据库
            [[DBCacheBiuBiu shareInstance] cleanDB];
        }
        [self.collectionViewSettting reloadData];
    }];
}

- (void)reusableViewMatchSettingHeader:(ReusableViewMatchSettingHeader *)reusableView alterAreaRange:(NSInteger)areaRange{
    ModelMatchSettingUpdate *model = [ModelMatchSettingUpdate model];
    model.areaRange = areaRange;
    model.parameters = ModelMatchSettingAreaRange;
    
    [self updateWithModel:model result:^(BOOL successed) {
        if (successed) {
            self.modelMatchSetting.areaRange = areaRange;
        }else{
            [self.collectionViewSettting reloadData];
        }
    }];
}

- (void)reusableViewMatchSettingHeader:(ReusableViewMatchSettingHeader *)reusableView alterAgeFloor:(NSInteger)ageFloor{
    ModelMatchSettingUpdate *model = [ModelMatchSettingUpdate model];
    model.ageFloor = ageFloor;
    model.parameters = ModelMatchSettingAgeFloor;
    
    [self updateWithModel:model result:^(BOOL successed) {
        if (successed) {
            self.modelMatchSetting.ageFloor = ageFloor;
        }else{
            [self.collectionViewSettting reloadData];
        }
    }];
}

- (void)reusableViewMatchSettingHeader:(ReusableViewMatchSettingHeader *)reusableView alterAgeCeiling:(NSInteger)ageCeiling{
    ModelMatchSettingUpdate *model = [ModelMatchSettingUpdate model];
    model.ageCeiling = ageCeiling;
    model.parameters = ModelMatchSettingAgeCeiling;
    
    [self updateWithModel:model result:^(BOOL successed) {
        if (successed) {
            self.modelMatchSetting.ageCeiling = ageCeiling;
        }else{
            [self.collectionViewSettting reloadData];
        }
    }];
}

- (void)reusableViewMatchSettingHeaderAlterCharacter:(ReusableViewMatchSettingHeader *)view{
    if (self.modelMatchSetting.userCharcterCount>0) {
        self.updateCharterMineOrMacth = 2;
        ControllerMineAlterCharacter *controller = [ControllerMineAlterCharacter controllerWithCharacters:self.modelMatchSetting.characters gender:self.modelMatchSetting.gender];
        controller.delegateAlterCharacter = self;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIAlertController *controllerAlert = [UIAlertController alertControllerWithTitle:@"完善个性标签" message:@"想让iU的真爱公式发挥作用么要先完善自己的个性标签哦" preferredStyle:UIAlertControllerStyleAlert];
        [controllerAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [controllerAlert addAction:[UIAlertAction actionWithTitle:@"完善个性标签" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.updateCharterMineOrMacth = 1;
            ControllerMineAlterCharacter *controller = [ControllerMineAlterCharacter controllerWithCharacters:@[] gender:self.modelMatchSetting.userGender];
            controller.delegateAlterCharacter = self;
            [self.navigationController pushViewController:controller animated:YES];
        }]];
        [self presentViewController:controllerAlert animated:YES completion:nil];
    }
    
}


- (void)controllerMineAlterCharacter:(ControllerMineAlterCharacter *)controller selecteds:(NSMutableArray *)selecteds{
    
    if (self.updateCharterMineOrMacth == 1) {
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
        
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [httpManager POST:[XMUrlHttp xmUpdateMineInfo] parameters:@{@"data":[model modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ModelResponse *response = [ModelResponse responselWithObject:responseObject];
            if (response.state == 200) {
                self.modelMatchSetting.userCharcterCount = selecteds.count;
            }else{
                [[MLToast toastInView:self.view content:@"更新个性标签失败"] show];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[MLToast toastInView:self.view content:@"更新个性标签失败"] show];
        }];
    }else if (self.updateCharterMineOrMacth == 2){
        ModelMatchSettingUpdate *model = [ModelMatchSettingUpdate model];
        model.parameters = ModelMatchSettingCharacters;
        
        NSMutableString *characterIds = [NSMutableString string];
        for (int i=0; i<selecteds.count; i++) {
            ModelCharacher *character = selecteds[i];
            if (i==0) {
                [characterIds appendString:character.code];
            }else{
                [characterIds appendFormat:@",%@", character.code];
            }
        }
        model.characters = characterIds;
        
        [self updateWithModel:model result:^(BOOL successed) {
            if (successed) {
                self.modelMatchSetting.characters = selecteds;
                [self.collectionViewSettting reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }else{
                
            }
        }];
    }
    
    self.updateCharterMineOrMacth = 0;
}

- (void)reusableViewMatchSettingFooter:(ReusableViewMatchSettingFooter *)reusableView switchRes:(ModelMatchSetting *)switchRes{
    ModelMatchSettingUpdate *model = [ModelMatchSettingUpdate model];
    model.pushNewMsg = switchRes.pushNewMsg;
    model.pushSound = switchRes.pushSound;
    model.pushVibration = switchRes.pushVibration;
    model.parameters = ModelMatchSettingMsg;
    
    [self updateWithModel:model result:^(BOOL successed) {
        if (successed) {
            self.modelMatchSetting.pushNewMsg = model.pushNewMsg;
            self.modelMatchSetting.pushSound = model.pushSound;
            self.modelMatchSetting.pushVibration = model.pushVibration;
        }else{
            [self.collectionViewSettting reloadData];
        }
        //本地设置
        [UserDefultSetting msgNotification:self.modelMatchSetting.pushNewMsg];
        [UserDefultSetting msgNotificationIsSound:self.modelMatchSetting.pushSound];
        [UserDefultSetting msgNotificationVibration:self.modelMatchSetting.pushVibration];
    }];
}


- (void)reusableViewMatchSettingFooter:(ReusableViewMatchSettingFooter *)reusableView setBtnClick:(UIButton *)btn{
    //关于iu
    if (btn.tag == 101) {
        ControllerAboutIU *controller = [ControllerAboutIU controller];
        [self.navigationController pushViewController:controller animated:YES];
    //新手引导
    }else if(btn.tag == 102){
  
    //分享给好友
    }else if(btn.tag == 103){
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"iU—青春恋爱成长平台";
        [UMSocialData defaultData].extConfig.qqData.title = @"iU—青春恋爱成长平台";
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:@"星星发亮，是为了让每一个人都能找到属于自己的星星。而从我到你，只有一个iU的距离。"
                                         shareImage:[UIImage imageNamed:@"global_icon_108"]
                                    shareToSnsNames:@[UMShareToSina,UMShareToWechatSession, UMShareToWechatTimeline,UMShareToQQ]
                                           delegate:nil];

        
    }
    
}
- (void)reusableViewMatchSettingFooter:(ReusableViewMatchSettingFooter *)reusableView onLogout:(UIButton *)btnLogout{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出当前账号？" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"user_code":[UserDefultAccount userCode], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
        [httpManager POST:[XMUrlHttp xmLogout] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        //退出环信
        dispatch_queue_t queue = dispatch_queue_create("em.logout.setting", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            EMError *logoutErr = [[EMClient sharedClient] logout:YES];
            if (logoutErr) {
                
            }
        });
        
        //进行UserDefaultAccount数据的清除
        [UserDefultAccount cleanAccountCache];
        [self.navigationController popViewControllerAnimated:YES];
        
        //清空未读消息数
        [ControllerTabBarMain setBadgeMsgWithCount:0];
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)updateWithModel:(ModelMatchSettingUpdate*)model result:(void(^)(BOOL successed))result{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    model.token = [UserDefultAccount token];
    model.deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    [httpManager POST:[XMUrlHttp xmMatchSettingUpdate] parameters:@{@"data":[model modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            NSDictionary *resDic = response.data;
            result(YES);
        }else{
            result(NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        result(NO);
    }];
}

- (ModelMatchSetting *)modelMatchSetting{
    if (!_modelMatchSetting){
        _modelMatchSetting = [[ModelMatchSetting alloc] init];
    }
    return _modelMatchSetting;
}

@end
