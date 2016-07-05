//
//  ControllerIMChatMsg.m
//  IMeetU
//
//  Created by zhanghao on 16/6/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerIMChatMsg.h"
#import "UIStoryboard+Plug.h"
#import "UserDefultAccount.h"

#import <ImSDK/ImSDK.h>

@interface ControllerIMChatMsg ()<UITableViewDelegate, UITableViewDataSource, TIMMessageListener>

@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldContext;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *msgs;

@end

@implementation ControllerIMChatMsg

+ (instancetype)controller{
    ControllerIMChatMsg *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameMessage indentity:@"ControllerIMChatMsg"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TIMManager *manager = [TIMManager sharedInstance];
    
    [manager setMessageListener:self];
    
    [manager initSdk:1400009724 accountType:@"5119"];
    
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    login_param.accountType = @"5119";
    login_param.identifier = [UserDefultAccount userCode];
    login_param.userSig = @"usersig";
    login_param.appidAt3rd = @"1400009724";
    
    login_param.sdkAppId = 1400009724;
    [manager login:nil succ:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellWithIdentifier"];
    }
    cell.textLabel.text = self.msgs[indexPath.row];
    
    return cell;
}

- (IBAction)onTouchUpInsideBtnSend:(id)sender {
    TIMTextElem * text_elem = [[TIMTextElem alloc] init];
    [text_elem setText:self.textFieldContext.text];
    
    TIMMessage * msg = [[TIMMessage alloc] init];
    [msg addElem:text_elem];
    
    TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:self.textFieldPhone.text];
    [conversation sendMessage:msg succ:^(){
        NSLog(@"SendMsg Succ");
    }fail:^(int code, NSString * err) {
        NSLog(@"SendMsg Failed:%d->%@", code, err);
    }];
}

- (IBAction)onTouchUpInsideBtnBack:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)msgs{
    if (!_msgs) {
        _msgs = [NSMutableArray array];
    }
    return _msgs;
}

- (void)onNewMessage:(NSArray *)msgs{
    for (int i=0; i<msgs.count; i++) {
        TIMMessage *msg = msgs[i];
        
        for (int j=0; j<msg.elemCount; j++) {
            TIMElem *elem = [msg getElem:j];
            if ([elem isKindOfClass:[TIMTextElem class]]) {
                TIMTextElem *elemTxt = (TIMTextElem*)elem;
                
                [self.msgs addObject:elemTxt.text];
                [self.tableView reloadData];
            }
        }
    }
}


@end
