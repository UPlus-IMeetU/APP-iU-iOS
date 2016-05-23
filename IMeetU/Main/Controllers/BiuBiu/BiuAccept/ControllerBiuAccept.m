//
//  ControllerBiuAccept.m
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerBiuAccept.h"
#import "UIStoryboard+Plug.h"
#import "ModelBiuAccept.h"
#import "ModelBiuAccepts.h"
#import <YYKit/YYKit.h>
#import "XMHttpBiuBiu.h"
#import "UserDefultBiu.h"
#import "UINib+Plug.h"
#import "CellBiuAccept.h"
#import "ControllerMineMain.h"
#import "MBProgressHUD+plug.h"
#import "EmptyController.h"
#import "ControllerChatMsg.h"

#define ReuseIdentifierCellBiuAccept @"CellBiuAccept"

@interface ControllerBiuAccept ()<UITableViewDelegate, UITableViewDataSource, CellBiuAcceptDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewAcceptList;

@property (nonatomic, strong) NSArray *users;

@end

@implementation ControllerBiuAccept

+ (instancetype)controller{
    ControllerBiuAccept *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"ControllerBiuAccept"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"加载中..." animated:YES];
    
    [self.tableViewAcceptList registerNib:[UINib xmNibFromMainBundleWithName:@"CellBiuAccept"] forCellReuseIdentifier:ReuseIdentifierCellBiuAccept];
    self.tableViewAcceptList.delegate = self;
    self.tableViewAcceptList.dataSource = self;
    self.tableViewAcceptList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[XMHttpBiuBiu http] loadGrabBiuListWithCallback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            ModelBiuAccepts *models = [ModelBiuAccepts modelWithJSON:response];
            if (models.message) {
                [UserDefultBiu setBiuInMatch:YES];
                self.users = models.users;
                
                if (self.users.count > 0) {
                    ModelBiuAccept *model = self.users[0];
                    [UserDefultBiu setBiuUserProfileOfGrab:model.urlProfile];
                }
                [hud hide:YES];
            }else{
                [UserDefultBiu setBiuInMatch:NO];
                [UserDefultBiu setBiuUserProfileOfGrab:@""];
                [hud xmSetCustomModeWithResult:YES label:@"biu已结束"];
                [hud hide:YES afterDelay:1];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
            [self.tableViewAcceptList reloadData];
        }else{
            [hud xmSetCustomModeWithResult:NO label:@"加载失败"];
            [hud hide:YES afterDelay:1];
        }
    }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellBiuAccept *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifierCellBiuAccept];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithModel:self.users[indexPath.row]];
    cell.delegateCellAccept = self;
    
    return cell;
}

- (void)cellBiuAccept:(CellBiuAccept *)cell onClickBtnProfile:(NSInteger)userCode{
    ControllerMineMain *controller = [ControllerMineMain controllerWithUserCode:[NSString stringWithFormat:@"%lu", userCode] getUserCodeFrom:MineMainGetUserCodeFromParam];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)cellBiuAccept:(CellBiuAccept *)cell onClickBtnAccept:(NSInteger)userCode{
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"接受中..." animated:YES];
    
    [[XMHttpBiuBiu http] acceptUserWithCode:userCode callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            if ([response[@"message"] integerValue] == 1) {
                [cell setAlreadyAccept];
                [hud xmSetCustomModeWithResult:YES label:@"接受成功"];
                
                dispatch_after(NSEC_PER_SEC * 1, dispatch_get_main_queue(), ^{
                   
                    UIGraphicsBeginImageContext(self.view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
                    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
                    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
                    UIGraphicsEndImageContext();
                    
                    
                    EmptyController *emptyController = [[EmptyController alloc] init];
                    emptyController.backgroundImage = viewImage;
                    
                    
                    ControllerChatMsg *controllerChat = [[ControllerChatMsg alloc] initWithConversationChatter:[NSString stringWithFormat:@"%lu", (long)userCode] conversationType:EMConversationTypeChat];
                    
                    [self.navigationController pushViewController:emptyController animated:NO];
                    [self.navigationController pushViewController:controllerChat animated:YES];
                    
                });
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"接受失败"];
            }
        }else{
            [hud xmSetCustomModeWithResult:NO label:@"接受失败"];
        }
        [hud hide:YES afterDelay:1];
    }];
}

- (IBAction)onClickBtnShutdownBiu:(id)sender {
    UIAlertController *controllerAlertShutdownBiu = [UIAlertController alertControllerWithTitle:@"结束本次biubiu" message:@"结束后，本次biubiu将失效，也可以重新发biu哦" preferredStyle:UIAlertControllerStyleAlert];
    [controllerAlertShutdownBiu addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controllerAlertShutdownBiu addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"正在结束..." animated:YES];
        [[XMHttpBiuBiu http] shutdownBiuWithCallback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                if ([response[@"message"] integerValue] == 1) {
                    [UserDefultBiu setBiuInMatch:NO];
                    [UserDefultBiu setBiuUserProfileOfGrab:@""];
                    [hud xmSetCustomModeWithResult:YES label:@"结束成功"];
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }else{
                    [hud xmSetCustomModeWithResult:NO label:@"结束失败"];
                }
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"结束失败"];
            }
            
            [hud hide:YES afterDelay:1];
        }];
    }]];
    [self presentViewController:controllerAlertShutdownBiu animated:YES completion:nil];
    
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}


@end
