//
//  ControllerChatMsg.m
//  IMeetU
//
//  Created by zhanghao on 16/3/20.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerChatMsg.h"
#import <YYKit/YYKit.h>
#import "UIColor+Plug.h"
#import "UIScreen+Plug.h"

#import "EaseEmoji.h"
#import "EaseEmotionManager.h"

#import "ControllerChatMsgLocation.h"
#import "DBCacheBiuContact.h"
#import "ModelContact.h"
#import "UserDefultAccount.h"
#import "ControllerMineMain.h"
#import "XMActionSheetChatMsg.h"
#import "XMHttpChat.h"
#import "MBProgressHUD+plug.h"
#import "ControllerMineMain.h"
#import "MLToast.h"
#import "XMHttpPersonal.h"
#import "ViewChatMsgImgBrowser.h"
#import "AppDelegateDelegate.h"
#import "UserDefultMsg.h"
#import <BQMM/BQMM.h>

#import "MMTextParser+ExtData.h"

#import "ControllerUserLoginOrRegister.h"

#define MESSAGE_ATTR_IS_BIG_EXPRESSION @"em_is_big_expression"
#define MESSAGE_ATTR_EXPRESSION_ID @"em_expression_id"

@interface ControllerChatMsg ()<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,EMClientDelegate, XMActionSheetChatMsgDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;

@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *navigationBtnBack;
@property (nonatomic, strong) UIButton *navigationBtnMore;
@property (nonatomic, strong) UILabel *navigationLabelTitle;
@property (nonatomic, strong) XMActionSheetChatMsg *actionSheetMore;

@property (nonatomic, copy) NSString *chatterCode;

@property (nonatomic, weak) UIViewController *backController;
@end

@implementation ControllerChatMsg

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationType:(EMConversationType)conversationType backController:(UIViewController *)controller{
    if (self = [super initWithConversationChatter:conversationChatter conversationType:conversationType]) {
        self.chatterCode = conversationChatter;
        self.backController = controller;
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化导航栏
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.navigationBtnBack];
    [self.navigationView addSubview:self.navigationBtnMore];
    [self.navigationView addSubview:self.navigationLabelTitle];
    ModelContact *contacter = [[DBCacheBiuContact shareDAO] selectContactWithUserCode:self.chatterCode];
    self.navigationLabelTitle.text = contacter.nameNick;
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    self.tableView.frame = CGRectMake(0, 64, [UIScreen screenWidth], [UIScreen screenHeight]-110);
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[UIImage imageNamed:@"chat_sender_bg"]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[UIImage imageNamed:@"chat_receiver_bg"]];
    
    
    NSArray *array = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"chat_sender_audio_playing_full"], [UIImage imageNamed:@"chat_sender_audio_playing_000"], [UIImage imageNamed:@"chat_sender_audio_playing_001"], [UIImage imageNamed:@"chat_sender_audio_playing_002"], [UIImage imageNamed:@"chat_sender_audio_playing_003"], nil];
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:array];
    NSArray * array1 = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"chat_receiver_audio_playing_full"],[UIImage imageNamed:@"chat_receiver_audio_playing000"], [UIImage imageNamed:@"chat_receiver_audio_playing001"], [UIImage imageNamed:@"chat_receiver_audio_playing002"], [UIImage imageNamed:@"chat_receiver_audio_playing003"],nil];
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:array1];
    
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];
    
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];
    
    //[self _setupBarButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    //通过会话管理者获取已收发消息
    [self tableViewDidTriggerHeaderRefresh];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

- (void)didReceiveMessages:(NSArray *)aMessages{
    [super didReceiveMessages:aMessages];
    
    //在AppDelegateDelegate里面每收到一条消息，未读数都加一，其中也包括本对话，因此本对话收到的消息要减掉
    [UserDefultMsg unreadMsgCountReduceWithCount:1];
}


#pragma mark - notification
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message]];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}


#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self _showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel{
    
    ControllerMineMain *controller = [ControllerMineMain controllerWithUserCode:messageModel.message.from getUserCodeFrom:MineMainGetUserCodeFromParam];
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
        didSelectMessageModel:(id<IMessageModel>)messageModel{
    EMMessage *message = messageModel.message;
    if(message.body.type == EMMessageBodyTypeLocation){
        ControllerChatMsgLocation *controller = [ControllerChatMsgLocation controllerWithLatitude:messageModel.latitude longitude:messageModel.longitude];
        [self.navigationController pushViewController:controller animated:YES];
        return YES;
    }else if (message.body.type == EMMessageBodyTypeImage){
        [self.view endEditing:YES];
        
        ViewChatMsgImgBrowser *viewChatMsgImgBrowser = [ViewChatMsgImgBrowser instanceViewWithAllMsgs:self.messsagesSource msg:messageModel];
        [viewChatMsgImgBrowser showInView:self.view];
        
        
        return YES;
    }
    return NO;
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    ModelContact *contacter = [[DBCacheBiuContact shareDAO] selectContactWithUserCode:message.from];
    if (contacter) {
        //别人
        model.avatarURLPath = contacter.profileUrl;
        model.nickname = contacter.nameNick;
    }else if([message.from isEqualToString:[UserDefultAccount userCode]]){
        //自己
        model.avatarURLPath = [UserDefultAccount userProfileUrlThumbnail];
        model.nickname = [UserDefultAccount userName];
    }
    model.failImageName = @"imageDownloadFail";
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}


#pragma mark - 表情MM修改
- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }else if(messageModel.mmExt != nil) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

#pragma mark - EaseMob

#pragma mark - EMClientDelegate

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], 64)];
        _navigationView.backgroundColor = [UIColor often_6CD1C9:1];
    }
    return _navigationView;
}

- (UILabel *)navigationLabelTitle{
    if (!_navigationLabelTitle) {
        _navigationLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(54, 20, [UIScreen screenWidth]-108, 44)];
        _navigationLabelTitle.font = [UIFont systemFontOfSize:18];
        _navigationLabelTitle.textColor = [UIColor whiteColor];
        _navigationLabelTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navigationLabelTitle;
}

- (UIButton *)navigationBtnBack{
    if (!_navigationBtnBack) {
        _navigationBtnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 54, 44)];
        [_navigationBtnBack setImage:[UIImage imageNamed:@"global_navigation_back_ffffff"] forState:UIControlStateNormal];
        [_navigationBtnBack addTarget:self action:@selector(onClickNavigationBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigationBtnBack;
}

- (UIButton*)navigationBtnMore{
    if (!_navigationBtnMore) {
        _navigationBtnMore = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen screenWidth]-54, 20, 54, 44)];
        [_navigationBtnMore setImage:[UIImage imageNamed:@"global_btn_more"] forState:UIControlStateNormal];
        [_navigationBtnMore addTarget:self action:@selector(onClickNavigationBtnMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigationBtnMore;
}

- (void)onClickNavigationBtnBack:(UIButton*)sender{
    [self.navigationController popToViewController:self.backController animated:YES];
    
}

#pragma mark - 更多
#pragma mark 点击更多按钮
- (void)onClickNavigationBtnMore:(UIButton*)sender{
    [self.actionSheetMore showInView:self.view];
}
#pragma mark 更多actionsheet
- (XMActionSheetChatMsg *)actionSheetMore{
    if (!_actionSheetMore) {
        _actionSheetMore = [XMActionSheetChatMsg actionSheet];
        _actionSheetMore.delegateActionSheet = self;
    }
    return _actionSheetMore;
}
#pragma mark 更多回调：查看个人主页
- (void)xmActionSheetChatMsgReadHisMine:(XMActionSheetChatMsg *)view{
    [view hiddenAndDestoryWithCompletion:^(BOOL finish) {
        ControllerMineMain *controller = [ControllerMineMain controllerWithUserCode:self.chatterCode getUserCodeFrom:MineMainGetUserCodeFromParam];
        [self.navigationController pushViewController:controller animated:YES];
    }];
}
#pragma mark 更多回调：清空聊天记录
- (void)xmActionSheetChatMsgCleanChatRecord:(XMActionSheetChatMsg *)view{
    [view hiddenAndDestory];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"清空聊天记录" message:@"真的要清空你们之间的聊天么" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL res = [self.conversation deleteAllMessages];
        if (res) {
            self.dataArray = nil;
            [self.tableView reloadData];
        }else{
            [[MLToast toastInView:self.view content:@"清空消息失败"] show];
        }
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark 更多回调：举报
- (void)xmActionSheetChatMsgToReport:(XMActionSheetChatMsg *)view{
    [view hiddenAndDestory];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"举报" message:@"举报后就交给小U来对付吧" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"举报..." animated:YES];
        [[XMHttpPersonal http] xmReportWithUserCode:self.chatterCode reason:@"" block:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                [hud xmSetCustomModeWithResult:YES label:@"举报成功"];
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"举报失败"];
            }
            [hud hide:YES afterDelay:0.5];
        }];
    }]];
    [self presentViewController:controller animated:YES completion:nil];

}
#pragma mark 更多回调：解除关系
- (void)xmActionSheetChatMsgUnfriendYou:(XMActionSheetChatMsg *)view{
    [view hiddenAndDestory];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"解除关系" message:@"真的要删除你们的聊天关系么" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"解除关系..." animated:YES];
        [[XMHttpChat http] xmUnfriendYouWithUserCode:self.chatterCode block:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                [hud xmSetCustomModeWithResult:YES label:@"已解除关系"];
                //删除缓存，并刷新
                [[DBCacheBiuContact shareDAO] deleteContacterWithUserCode:self.chatterCode];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"解除关系失败"];
            }
            [hud hide:YES afterDelay:0.5];
        }];
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)xmActionSheetChatMsgCancel:(XMActionSheetChatMsg *)view{
    [view hiddenAndDestory];
}

#pragma mark - private
- (void)_showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}


#pragma mark - action
- (void)deleteAllMessages:(id)sender{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}

#pragma mark - 表情MM修改
- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        
        if ([model.mmExt[@"txt_msgType"] isEqualToString:@"emojitype"]) {
            pasteboard.string = [MMTextParser stringWithExtData:model.mmExt[@"msg_data"]];
        }
        else {
            pasteboard.string = model.text;
        }
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - 表情MM代理回调方法
- (void)didSelectEmoji:(MMEmoji *)emoji{

}

- (void)didSendWithInput:(UIResponder<UITextInput> *)input{

}

@end
