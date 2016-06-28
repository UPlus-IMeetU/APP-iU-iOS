//
//  ControllerBiuMe.m
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerBiuMe.h"
#import "CellBiuMe.h"
#import "ModelBiuMe.h"
#import "ModelsBiuMe.h"

#import "UINib+Plug.h"
#import "UIStoryboard+Plug.h"
#import "MJRefresh.h"

#import "XMHttpChat.h"
#import "MBProgressHUD+plug.h"
#import "ControllerMineMain.h"
#import "UserDefultAppGlobalStatus.h"

#define CellReuseIdentifier @"CellBiuMe"

@interface ControllerBiuMe ()<UITableViewDelegate, UITableViewDataSource, CellBiuMeDelegate>

@property (nonatomic, strong) ModelsBiuMe *models;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UITableView *tableViewBiuMe;
@property (weak, nonatomic) IBOutlet UIView *viewEmptyNotice;

@end

@implementation ControllerBiuMe

+ (instancetype)controller{
    ControllerBiuMe *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameChatMsg indentity:@"ControllerBiuMe"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //进行Icon的处理
    [UIApplication sharedApplication].applicationIconBadgeNumber -= [UserDefultAppGlobalStatus comBiuCount];
    [UserDefultAppGlobalStatus resetComBiuCount];
    
    [self.tableViewBiuMe registerNib:[UINib xmNibFromMainBundleWithName:@"CellBiuMe"] forCellReuseIdentifier:CellReuseIdentifier];
    self.tableViewBiuMe.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewBiuMe.delegate = self;
    self.tableViewBiuMe.dataSource = self;
    
    self.viewEmptyNotice.hidden = YES;
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"" animated:YES];
    [[XMHttpChat http] getBiuMeListWithTime:0 callback:^(NSInteger code, ModelsBiuMe *models, NSError *err) {
        if (code == 200) {
            self.models = models;
            [self.tableViewBiuMe reloadData];
            //如果内容为空显示提示
            if ([models numberOfRowsInSection:0] == 0) {
                self.viewEmptyNotice.hidden = NO;
            }
        }else{
            [hud xmSetCustomModeWithResult:NO label:@""];
        }
        [hud hide:YES afterDelay:0.3];
    }];
    
    self.tableViewBiuMe.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[XMHttpChat http] getBiuMeListWithTime:0 callback:^(NSInteger code, ModelsBiuMe *models, NSError *err) {
            if (code == 200) {
                self.models.time = models.time;
                self.models.hasNext = models.hasNext;
                [self.models additionalBiuMe:models.biuList];
                if (models.hasNext) {
                    [self.tableViewBiuMe.mj_footer endRefreshing];
                }else{
                    [self.tableViewBiuMe.mj_footer endRefreshingWithNoMoreData];
                }
                [self.tableViewBiuMe reloadData];
            }
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.models numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellBiuMe *cell = [self.tableViewBiuMe dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    [cell initWithModel:[self.models modelForRowAtIndexPath:indexPath]];
    cell.delegateBiuMe = self;
    
    return cell;
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnClean:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"清空biu我的人" message:@"嗨，清空biu我的人后将无法恢复哦" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"" animated:YES];
        [[XMHttpChat http] cleanBiuMeWithCallback:^(NSInteger code, NSString *token, NSError *err) {
            if (code == 200) {
                self.models = [[ModelsBiuMe alloc] init];
                [self.tableViewBiuMe reloadData];
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"清空失败"];
            }
            [hud hide:YES afterDelay:0.3];
        }];
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)cell:(CellBiuMe *)cell onClickBtnProfile:(ModelBiuMe *)model{
    ControllerMineMain *controller = [ControllerMineMain controllerWithUserCode:[NSString stringWithFormat:@"%ld", model.userCode] getUserCodeFrom:MineMainGetUserCodeFromParam];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)cell:(CellBiuMe *)cell onClickBtnAccept:(ModelBiuMe *)model{
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"" animated:YES];
    [[XMHttpChat http] acceptBiuMeWithCode:model.userCode callback:^(NSInteger code, NSString *token, NSError *err) {
        if (code == 200) {
            model.isAccept = YES;
            [self.tableViewBiuMe reloadData];
        }else{
            [hud xmSetCustomModeWithResult:NO label:@"接收失败"];
        }
        [hud hide:YES afterDelay:0.3];
    }];
}

- (ModelsBiuMe *)models{
    if (!_models) {
        _models = [[ModelsBiuMe alloc] init];
    }
    return _models;
}
@end
