//
//  ControllerCommunityNotifies.m
//  IMeetU
//
//  Created by zhanghao on 16/6/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerCommunityNotifies.h"
#import "ModelCommunityNotifies.h"
#import "ModelCommunityNotice.h"
#import "XMHttpCommunity.h"
#import "MBProgressHUD+plug.h"


#import "UINib+Plug.h"
#import "UIColor+Plug.h"
#import "UIStoryboard+Plug.h"

#import "CellCommunityNotifies.h"
#import "ControllerMineMain.h"
#import "ControllerReply.h"
#import "MJRefresh.h"

#import "UserDefultAppGlobalStatus.h"

#import "XMNetworkErr.h"

#define CellReuseIdentifier @"CellCommunityNotifies"

@interface ControllerCommunityNotifies ()<UITableViewDelegate, UITableViewDataSource, CellCommunityNotifiesDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UITableView *tableViewNotifies;
@property (weak, nonatomic) IBOutlet UIView *viewEmptyNotice;
@property (nonatomic, strong) ModelCommunityNotifies *notifies;

@end

@implementation ControllerCommunityNotifies

+ (instancetype)controller{
    ControllerCommunityNotifies *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerCommunityNotifies"];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //进行Icon的处理
    [UIApplication sharedApplication].applicationIconBadgeNumber -= [UserDefultAppGlobalStatus noticeCount];
    [UserDefultAppGlobalStatus resetNoticeCount];

    self.viewEmptyNotice.hidden = YES;
    
    [self.tableViewNotifies registerNib:[UINib xmNibFromMainBundleWithName:@"CellCommunityNotifies"] forCellReuseIdentifier:CellReuseIdentifier];
    self.tableViewNotifies.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewNotifies.delegate = self;
    self.tableViewNotifies.dataSource = self;
    
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"" animated:YES];
    [[XMHttpCommunity http] communityNitifiesWithTime:0 callback:^(NSInteger code, ModelCommunityNotifies *notifies, NSError *err) {
        if (code == 200) {
            self.notifies = notifies;
            [self.tableViewNotifies reloadData];
            
            if ([self.notifies numberOfRowsInSection] < 1) {
                self.viewEmptyNotice.hidden = NO;
            }
        }else{
            [hud xmSetCustomModeWithResult:NO label:@"加载失败"];
        }
        [hud hide:YES afterDelay:0.2];
    }];
    
    self.tableViewNotifies.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[XMHttpCommunity http] communityNitifiesWithTime:0 callback:^(NSInteger code, ModelCommunityNotifies *notifies, NSError *err) {
            if (code == 200) {
                self.notifies.hasNext = notifies.hasNext;
                [self.notifies additionalNoticeWithArr:notifies.notifies];
                [self.tableViewNotifies reloadData];
                if (!notifies.hasNext) {
                    [self.tableViewNotifies.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableViewNotifies.mj_footer endRefreshing];
                }
            }else{
                [self.tableViewNotifies.mj_footer endRefreshing];
            }
        }];
    }];
    
    self.tableViewNotifies.backgroundColor = [UIColor xmColorWithHexStrRGB:@"EEEEEE"];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.notifies numberOfRowsInSection];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.notifies heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellCommunityNotifies *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    [cell initWithModel:[self.notifies modelWithIndexPath:indexPath]];
    cell.delegateNotice = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelCommunityNotice *notice = [self.notifies modelWithIndexPath:indexPath];
    ControllerReply *controller = [ControllerReply shareControllerReply];
    
    controller.postId = (NSUInteger)notice.postId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClickBtnClean:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"清空通知消息" message:@"嗨，清空通知消息后将无法恢复哦" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"" animated:YES];
        [[XMHttpCommunity http] communityCleanNitifiesWithCallback:^(NSInteger code, NSError *err) {
            if (code == 200) {
                [hud xmSetCustomModeWithResult:YES label:@""];
                self.notifies = [[ModelCommunityNotifies alloc] init];
                [self.tableViewNotifies reloadData];
            }else{
                [hud xmSetCustomModeWithResult:NO label:@""];
            }
            [hud hide:YES afterDelay:0.3];
        }];
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cell:(CellCommunityNotifies *)cell userCode:(NSInteger)userCode{
    ControllerMineMain *controller = [ControllerMineMain controllerWithUserCode:[NSString stringWithFormat:@"%ld", (long)userCode] getUserCodeFrom:MineMainGetUserCodeFromParam];
    [self.navigationController pushViewController:controller animated:YES];
}

- (ModelCommunityNotifies *)notifies{
    if (!_notifies) {
        _notifies = [[ModelCommunityNotifies alloc] init];
    }
    return _notifies;
}

@end
