//
//  ControllerBiuContact.m
//  IMeetU
//
//  Created by zhanghao on 16/3/28.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerBiuContact.h"

#import "UINib+Plug.h"
#import "UIStoryboard+Plug.h"

#import "CellBiuContact.h"
#import "XMAlertDialogUnfriendYou.h"

#import "DBCacheBiuContact.h"
#import "ModelContact.h"
#import "ModelContacts.h"
#import "ControllerChatMsg.h"
#import "ControllerMineMain.h"
#import "AFNetworking.h"
#import "UserDefultAccount.h"
#import <YYKit/YYKit.h>
#import "XMUrlHttp.h"
#import "ModelResponse.h"
#import "MBProgressHUD+plug.h"

#import "XMHttpChat.h"

#define CellReuseIdentifier @"CellBiuContact"

@interface ControllerBiuContact ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, XMAlertDialogUnfriendYouDelegate, CellBiuContactDelegate>

@property (nonatomic, strong) XMAlertDialogUnfriendYou *alertViewUnfriendYou;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UITableView *tableViewContact;
@property (weak, nonatomic) IBOutlet UIView *viewEmptyNotice;
@property (nonatomic, strong) ModelContacts *contacts;
@property (nonatomic, weak) UIViewController *superController;
@end

@implementation ControllerBiuContact

+ (instancetype)controllerWithSuperController:(UIViewController *)superController{
    ControllerBiuContact *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"ControllerBiuContact"];
    controller.superController = superController;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewEmptyNotice.hidden = YES;
    
    [self.tableViewContact registerNib:[UINib xmNibFromMainBundleWithName:CellReuseIdentifier] forCellReuseIdentifier:CellReuseIdentifier];
    self.tableViewContact.dataSource = self;
    self.tableViewContact.delegate = self;
    self.tableViewContact.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setHidesBottomBarWhenPushed:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[DBCacheBiuContact shareDAO] updateFromNetworkWithIsForced:NO block:^(BOOL result, ModelContacts *contacts) {
        if (result) {
            self.contacts = contacts;
            [self.tableViewContact reloadData];
            if ([contacts numberOfRowsInSection:0]<1) {
                self.viewEmptyNotice.hidden = NO;
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contacts numberOfRowsInSection:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellBiuContact *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    
    [cell initWithModel:[self.contacts contactForRowAtIndexPath:indexPath]];
    cell.delegateCell = self;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"解除关系";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        XMAlertDialogUnfriendYou *alertView = [XMAlertDialogUnfriendYou alertDialogWithIndexPath:indexPath];
        alertView.delegateAlertDialog = self;
        [alertView showWithSuperView:self.viewMain];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelContact *model = [self.contacts contactForRowAtIndexPath:indexPath];
    ControllerChatMsg *controllerChat = [[ControllerChatMsg alloc] initWithConversationChatter:model.userCode conversationType:EMConversationTypeChat backController:self.superController];
    //ControllerChatMsg.title = conversationModel.title;
    [self.navigationController pushViewController:controllerChat animated:YES];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)xmAlertDialogUnfriendYouOn:(XMAlertDialogUnfriendYou *)view indexPath:(NSIndexPath *)indexPath{
    NSString *userCode = [self.contacts contactForRowAtIndexPath:indexPath].userCode;
    
    [view hiddenAndRemove];
    
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"解除关系..." animated:YES];
    
    [[XMHttpChat http] xmUnfriendYouWithUserCode:userCode block:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            [hud xmSetCustomModeWithResult:YES label:@"已解除关系"];
            //删除缓存，并刷新
            [[DBCacheBiuContact shareDAO] deleteContacterWithUserCode:userCode];
            self.contacts = [ModelContacts modelWithContacts:[[DBCacheBiuContact shareDAO] selectAllContact]];
        }else{
            [hud xmSetCustomModeWithResult:NO label:@"解除关系失败"];
        }
        [self.tableViewContact reloadData];
        [hud hide:YES afterDelay:0.5];
    }];
}

- (void)xmAlertDialogUnfriendYouCancel:(XMAlertDialogUnfriendYou *)view indexPath:(NSIndexPath *)indexPath{
    [view hiddenAndRemove];
    
    [self.tableViewContact reloadData];
}

- (void)cellBiuContact:(CellBiuContact *)cell onClickProfile:(ModelContact *)contact{
    ControllerMineMain *controller = [ControllerMineMain controllerWithUserCode:contact.userCode getUserCodeFrom:MineMainGetUserCodeFromParam];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (ModelContacts *)contacts{
    if (!_contacts) {
        _contacts = [ModelContacts modelWithContacts:[[DBCacheBiuContact shareDAO] selectAllContact]];
    }
    return _contacts;
}
@end
