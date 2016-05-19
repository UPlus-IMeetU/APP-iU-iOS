//
//  ControllerDrawerLeft.m
//  IMeetU
//
//  Created by zhanghao on 16/3/3.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerDrawerLeft.h"
#import "ControllerDrawer.h"
#import "ControllerBiuBiu.h"
#import "CellDrawerLeft.h"

#import "ControllerMineMain.h"
#import "ControllerMatchSetting.h"
#import "ControllerUserLoginOrRegister.h"
#import "ControllerNavigationBiuBiu.h"
#import "AppDelegate.h"

#import "UINib+Plug.h"
#import "UIColor+Plug.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"

#import "UserDefultAccount.h"
#import <YYKit/YYKit.h>

#import "UMSocial.h"
#import "ControllerAboutIU.h"
#import "ViewNewComerGuide.h"

#define CellReusableIdentifier @"CellDrawerLeft"

@interface ControllerDrawerLeft ()<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imgViewUserProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelRighsterLoginOrName;
@property (nonatomic, assign) CGFloat btnUserProfileWH;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constarintViewHeightFooter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewHeightHeader;


@end
@implementation ControllerDrawerLeft

+ (instancetype)controller{
    ControllerDrawerLeft *controller = [UIStoryboard xmControllerWithName:@"Mine" indentity:@"ControllerDrawerLeft"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib xmNibFromMainBundleWithName:@"CellDrawerLeft"] forCellReuseIdentifier:CellReusableIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationController.navigationBarHidden = YES;
    
    self.imgViewUserProfile.layer.cornerRadius = self.btnUserProfileWH/2;
    self.imgViewUserProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgViewUserProfile.layer.borderWidth = 2;
    
    self.constraintViewHeightHeader.constant = [self viewHeightHeader];
    self.constarintViewHeightFooter.constant = [self viewHeightFooter];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([UserDefultAccount isLogin]) {
        [self.labelRighsterLoginOrName setText:[UserDefultAccount userName]];
        [self.imgViewUserProfile setImageWithURL:[NSURL URLWithString:[UserDefultAccount userProfileUrlThumbnail]] placeholder:[UIImage imageNamed:@"global_profile_defult"]];
    }else{
        
        [self.labelRighsterLoginOrName setText:@"点击登录/注册"];
        [self.imgViewUserProfile setImage:[UIImage imageNamed:@"global_profile_defult"]];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidDisappear:(BOOL)animated{
    if (self.tableView.indexPathForSelectedRow) {
        //[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
    
    [[ControllerDrawer shareControllerDrawer] setCenterViewController:[ControllerNavigationBiuBiu shareControllerNavigationBiuBiu] withCloseAnimation:YES completion:^(BOOL finished) {}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellDrawerLeft *cell = [tableView dequeueReusableCellWithIdentifier:CellReusableIdentifier forIndexPath:indexPath];
    [cell initWithIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        [[ControllerDrawer shareControllerDrawer] setCenterViewController:[ControllerNavigationBiuBiu shareControllerNavigationBiuBiu] withCloseAnimation:YES completion:^(BOOL finished) {}];
        //[AppDelegate shareAppDelegate].tabBarController.selectedIndex = 1;
    }else if (indexPath.row == 1){
        if ([UserDefultAccount isLogin]){
            [[ControllerDrawer shareControllerDrawer] setCenterViewController:[ControllerNavigationBiuBiu shareControllerNavigationBiuBiu] withCloseAnimation:YES completion:^(BOOL finished) {
                [[ControllerDrawer shareControllerDrawer] openDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
                    
                }];
            }];
        }else{
            [[ControllerDrawer shareControllerDrawer] setCenterViewController:[ControllerNavigationBiuBiu shareControllerNavigationBiuBiu] withCloseAnimation:YES completion:^(BOOL finished) {
                ControllerUserLoginOrRegister *controller = [ControllerUserLoginOrRegister shareController];
                [self.navigationController pushViewController:controller animated:YES];
            }];
        }
    }else if (indexPath.row == 2){
        if ([UserDefultAccount isLogin]){
            ControllerMatchSetting *controller = [ControllerMatchSetting controller];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            ControllerUserLoginOrRegister *controller = [ControllerUserLoginOrRegister shareController];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (indexPath.row == 3){
        [[ViewNewComerGuide view] showInView:[ControllerDrawer shareControllerDrawer].view completion:^(BOOL finished) {
            [[ControllerDrawer shareControllerDrawer] setCenterViewController:[ControllerNavigationBiuBiu shareControllerNavigationBiuBiu] withCloseAnimation:YES completion:^(BOOL finished) {}];
        }];
    }else if (indexPath.row == 4){
        //zcx
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"iU—青春恋爱成长平台";
        [UMSocialData defaultData].extConfig.qqData.title = @"iU—青春恋爱成长平台";
        
        [UMSocialSnsService presentSnsIconSheetView:[ControllerDrawer shareControllerDrawer]
                                             appKey:nil
                                          shareText:@"星星发亮，是为了让每一个人都能找到属于自己的星星。而从我到你，只有一个iU的距离。"
                                         shareImage:[UIImage imageNamed:@"global_icon_108"]
                                    shareToSnsNames:@[UMShareToSina,UMShareToWechatSession, UMShareToWechatTimeline,UMShareToQQ]
                                           delegate:nil];
    }
    
}
- (IBAction)onClickBtnLoginOrRegister:(id)sender {
    if ([UserDefultAccount isLogin]){
        
    }else{
        
    }
}

- (IBAction)onClickBtnAboutBiuBiu:(id)sender {
    ControllerAboutIU *controller = [ControllerAboutIU controller];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)btnUserProfileWH{
    return 80;
}

- (CGFloat)viewHeightHeader{
    if ([UIScreen is35Screen]) {
        return 150;
    }
    return 230;
}

- (CGFloat)viewHeightFooter{
    if ([UIScreen is35Screen]) {
        return 100;
    }else if ([UIScreen is40Screen]) {
        return 110;
    }
    return 150;
}

@end
