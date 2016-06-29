//
//  ControllerDrawerRight.m
//  IMeetU
//
//  Created by zhanghao on 16/3/3.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerDrawerRight.h"

#import "UIColor+Plug.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"

#import "ControllerChatMsg.h"

#import "ControllerChatMsgLocation.h"
#import "UserDefultAccount.h"
#import "MLToast.h"
#import "ControllerBiuContact.h"
#import "AppDelegate.h"

#import "ModelContact.h"
#import "UserDefultAccount.h"

#import "DBCacheBiuContact.h"
#import "UserDefultMsg.h"
#import "UIColor+plug.h"

#import "ControllerUserLogin.h"
#import "ControllerUserRegisterThirdStep.h"

#import "ViewDrawerRightLoginRegister.h"

#import "ControllerBiuBiu.h"
#import "MBProgressHUD+plug.h"
#import "XMOSS.h"
#import "AFHTTPSessionManager.h"
#import "XMUrlHttp.h"
#import <YYKit/YYKit.h>
#import "ModelResponse.h"
#import "EmptyController.h"
#import "ControllerTabBarMain.h"

#import "ViewChatMsgBtnBiu.h"
#import "UserDefultAppGlobalStatus.h"

#import "ControllerBiuMe.h"

@interface ControllerDrawerRight ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource, ViewDrawerRightLoginRegisterDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UILabel *navigationTitle;
@property (nonatomic, strong) UIButton *navigationBtn;

@property (nonatomic, strong) ViewChatMsgBtnBiu *viewBtnBiu;

@property (nonatomic, strong) ViewDrawerRightLoginRegister *viewLoginRegister;

@property (nonatomic, strong) UIImagePickerController *imgPickController;

@property (nonatomic, assign) NSInteger test;
@end

@implementation ControllerDrawerRight

+ (instancetype)controller{
    ControllerDrawerRight *controller = [[ControllerDrawerRight alloc] init];
    
    return controller;
}

- (instancetype)init{
    if (self = [super init]) {
        return self;
    }
    return nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.navigationTitle];
    [self.navigationView addSubview:self.navigationBtn];
    self.navigationController.navigationBarHidden = YES;
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    [self tableViewDidTriggerHeaderRefresh];
    self.tableView.frame = CGRectMake(0, 64, [UIScreen screenWidth], [UIScreen screenHeight]);
    [self networkStateView];
    
    [self removeEmptyConversationsFromDB];
    
    self.viewLoginRegister = [ViewDrawerRightLoginRegister view];
    self.viewLoginRegister.delegateLoginRegister = self;
    self.viewLoginRegister.frame = CGRectMake(0, 64, [UIScreen screenWidth], [UIScreen screenHeight]-64);
    [self.view addSubview:self.viewLoginRegister];
    
    self.viewBtnBiu.frame = CGRectMake(0, 20, 60, 44);
    [self.navigationView addSubview:self.viewBtnBiu];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 66, 0);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.viewLoginRegister.hidden = [UserDefultAccount isLogin];
    if ([UserDefultAccount isLogin]){
        self.tableView.hidden = NO;
        [self asyncConversationFromDB];
        [self refresh];
    }
    
    [[DBCacheBiuContact shareDAO] updateFromNetworkWithIsForced:NO block:^(BOOL result, ModelContacts *contacts) {
        if (result) {
            [self.tableView reloadData];
        }
    }];
    [self tableViewDidTriggerHeaderRefresh];
    
    //设置TabBarItem未读消息数
    [ControllerTabBarMain setBadgeMsgWithCount:[UserDefultMsg unreadMsgCount]];
    
    [self.viewBtnBiu setNumber:[UserDefultAppGlobalStatus comBiuCount]];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self setHidesBottomBarWhenPushed:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([UserDefultAccount userProfileStatus] != 5) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
        for (int i=0; i<self.dataArray.count; i++) {
            id<IConversationModel> model = [self.dataArray objectAtIndex:i];
            if (model.conversation.unreadMessagesCount > 0 && i!=indexPath.row){
                break;
            }
            
            if (i+1 == self.dataArray.count) {
                [UserDefultMsg unreadMsgCountReset];
            }
        }
        
        id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
        [UserDefultMsg unreadMsgCountReduceWithCount:model.conversation.unreadMessagesCount];
    
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"头像审核未通过" message:@"你的头像审核不通过，请上传能体现个人的真实头像哦" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [controller addAction:[UIAlertAction actionWithTitle:@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:self.imgPickController animated:YES completion:nil];
        }]];
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    
}

#pragma mark - getter
- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations deleteMessages:YES];
    }
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
//            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
//                RobotChatViewController *chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
//                [self.navigationController pushViewController:chatController animated:YES];
//            } else {
//                ControllerChatMsg *controllerChat = [[ControllerChatMsg alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//         
//                //ControllerChatMsg.title = conversationModel.title;
//                [self.navigationController pushViewController:controllerChat animated:YES];
//            }
            UIGraphicsBeginImageContext(self.view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
            UIGraphicsEndImageContext();

            
            EmptyController *emptyController = [[EmptyController alloc] init];
            emptyController.backgroundImage = viewImage;
            
            
            ControllerChatMsg *controllerChat = [[ControllerChatMsg alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type backController:self];
            
            [self.navigationController pushViewController:emptyController animated:NO];
            [self.navigationController pushViewController:controllerChat animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        //对方userCode
        NSString *userCode = @"";
        if ([conversation.latestMessage.from isEqualToString:[UserDefultAccount userCode]]) {
            userCode = conversation.latestMessage.to;
        }else{
            userCode = conversation.latestMessage.from;
        }
        //到数据库查询对方详细信息
        ModelContact *contact = [ModelContact modelWithUserCode:userCode];
        
        //返回给UI
        model.title = contact.nameNick;
        model.avatarURLPath = contact.profileUrl;
        
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        model.title = [conversation.ext objectForKey:@"subject"];
        imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    
    return latestMessageTitle;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    
    return latestMessageTime;
}


- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen screenWidth], 64)];
        _navigationView.backgroundColor = [UIColor often_6CD1C9:1];
    }
    return _navigationView;
}

- (UILabel *)navigationTitle{
    if (!_navigationTitle) {
        _navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [UIScreen screenWidth], 44)];
        _navigationTitle.textAlignment = NSTextAlignmentCenter;
        _navigationTitle.text = @"biubiu消息";
        _navigationTitle.font = [UIFont systemFontOfSize:18];
        _navigationTitle.textColor = [UIColor whiteColor];
    }
    return _navigationTitle;
}

- (UIButton *)navigationBtn{
    if (!_navigationBtn) {
        _navigationBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen screenWidth]-62, 20, 64, 44)];
        [_navigationBtn setImage:[UIImage imageNamed:@"msg_btn_contacter"] forState:UIControlStateNormal];
        [_navigationBtn addTarget:self action:@selector(onClickNavigationBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigationBtn;
}


#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}



- (void)asyncConversationFromDB
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId deleteMessages:NO];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshDataSource];
        });
    });
}

#pragma mark - target
- (void)onClickNavigationBtn:(UIButton*)sender{
    if([UserDefultAccount isLogin]){
        if ([UserDefultAccount userProfileStatus] != 5) {
            ControllerBiuContact *controller = [ControllerBiuContact controllerWithSuperController:self];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"头像审核未通过" message:@"你的头像审核不通过，请上传能体现个人的真实头像哦" preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [controller addAction:[UIAlertAction actionWithTitle:@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self presentViewController:self.imgPickController animated:YES completion:nil];
            }]];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }else{
        [[MLToast toastInView:self.view content:@"请先登录..."] show];
    }
}

- (void)viewDrawerRightLogin:(ViewDrawerRightLoginRegister *)view{
    ControllerUserLogin *controller = [ControllerUserLogin controller];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDrawerRightRegister:(ViewDrawerRightLoginRegister *)view{
    ControllerUserRegisterThirdStep *controller = [ControllerUserRegisterThirdStep controller];
    [self.navigationController pushViewController:controller animated:YES];
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
                            
                            [UserDefultAccount setUserProfileStatus:1];
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

- (ViewChatMsgBtnBiu *)viewBtnBiu{
    if (!_viewBtnBiu) {
        self.test = 9;
        _viewBtnBiu = [ViewChatMsgBtnBiu viewWithCallback:^{
            [_viewBtnBiu setNumber:0];
            [UserDefultAppGlobalStatus setComBiuCount:0];
            ControllerBiuMe *controller = [ControllerBiuMe controller];
            [self.navigationController pushViewController:controller animated:YES];
        }];
    }
    return _viewBtnBiu;
}

@end
