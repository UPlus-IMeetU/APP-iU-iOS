 //
//  ControllerBiuBiuSend.m
//  IMeetU
//
//  Created by zhanghao on 16/3/4.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerBiuBiuSend.h"
#import <YYKit/YYKit.h>
#import <YYKeyboardManager/YYKeyboardManager.h>

#import "UINib+Plug.h"
#import "UIStoryboard+Plug.h"

#import "CellBiuBiuSend.h"
#import "UserDefultAccount.h"
#import "ControllerMineMain.h"

#import "AFNetworking.h"
#import "XMUrlHttp.h"
#import "ModelResponse.h"
#import "ModelBiuSendChatTopic.h"
#import "ModelBiuSendChatTopics.h"
#import "CellBiuBiuSend.h"
#import "MBProgressHUD+plug.h"
#import "UIScreen+plug.h"
#import "UIColor+plug.h"

#import "MobClick.h"

#import "UICollectionViewAlignRightLayout.h"

#import "UserDefultBiu.h"
#import "UserDefultAccount.h"


#define CellReuseIdentifier @"CellBiuBiuSend"

@interface ControllerBiuBiuSend ()<YYKeyboardObserver,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIView *viewCard;
@property (weak, nonatomic) IBOutlet UILabel *labelCodeCount;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UITextView *textViewTopic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constarintViewEndEditBottom;
@property (weak, nonatomic) IBOutlet UIView *viewEndEdit;
@property (weak, nonatomic) IBOutlet UIView *viewEndEditSuper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewEndEditSuperHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnSendBiu;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewCardWrapTop;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (nonatomic, strong) ModelBiuSendChatTopics *modelBiuSendChatTopics;
@property (weak, nonatomic) IBOutlet UIView *topicView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewTopicViewTop;

@property (nonatomic, assign) BOOL chatTopicsLoadResult;
@end

@implementation ControllerBiuBiuSend

+ (instancetype)shareController{
    static ControllerBiuBiuSend *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"ControllerBiuBiuSend"];
    });
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateViewCardWrapConstraint];
    
    self.constarintViewEndEditBottom.constant = -40;
    
    self.btnProfile.layer.cornerRadius = 38;
    self.btnProfile.layer.masksToBounds = YES;
    
    self.viewCard.layer.cornerRadius = 5;
    self.viewCard.layer.masksToBounds = YES;
    
    self.textViewTopic.delegate = self;
    [self.view endEditing:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    [self.viewMain addGestureRecognizer:tapGestureRecognizer];
    
    [self.btnProfile setBackgroundImageWithURL:[NSURL URLWithString:[UserDefultAccount userProfileUrlThumbnail]] forState:UIControlStateNormal placeholder:nil];
    
    [self getModelBiuSendChatTopics];
    
    YYKeyboardManager *keyboardManager = [YYKeyboardManager defaultManager];
    [keyboardManager addObserver:self];
    
    self.topicView.layer.cornerRadius = 10;
    self.topicView.layer.borderWidth = 1;
    self.topicView.layer.borderColor = [UIColor often_6CD1C9:1].CGColor;
    self.topicView.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //如果加载失败，重新加载
    if (!self.chatTopicsLoadResult) {
        [self getModelBiuSendChatTopics];
    }
    if ([UserDefultAccount topic]) {
        self.textViewTopic.text = [UserDefultAccount topic];
        self.labelCodeCount.text = [NSString stringWithFormat:@"%lu/50", (unsigned long)self.textViewTopic.text.length];
        self.btnSendBiu.enabled = self.textViewTopic.text.length>0;
    }
    self.placeholderLabel.hidden = self.textViewTopic.text.length != 0 ? YES : NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [UserDefultAccount setTopic:self.textViewTopic.text];
    [self.view endEditing:YES];
    [self.modelBiuSendChatTopics selectItemOfIndex:NSIntegerMax];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
        if (textView.text.length > 50) {
            textView.text = [textView.text substringToIndex:50];
        }
    }
    self.btnSendBiu.enabled = self.textViewTopic.text.length>0;
    self.labelCodeCount.text = [NSString stringWithFormat:@"%lu/50", (unsigned long)self.textViewTopic.text.length];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.modelBiuSendChatTopics contentSizeOfIndex:indexPath.row];
}

- (IBAction)onBtnProfile:(id)sender {
    ControllerMineMain *controller = [ControllerMineMain controllerWithUserCode:[UserDefultAccount userCode] getUserCodeFrom:MineMainGetUserCodeFromParam];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnSendFinish:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"发送中" animated:YES];
    
    if (self.textViewTopic.text && self.textViewTopic.text.length>0) {
        if (self.delegateBiuSender){
            if ([self.delegateBiuSender respondsToSelector:@selector(controllerBiuBiuSend:sendResult:virtualCurrency:)]) {
                
                AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
                httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
                httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
                
                NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"chat_tags":self.textViewTopic.text};
                __weak typeof (self) weakSelf = self;
                [httpManager POST:[XMUrlHttp xmBiuSend] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                    if (response.state == 200) {
                        if ([response.data[@"message"] integerValue] == 1){
                            NSInteger virtualCurrency = [response.data[@"virtual_currency"] integerValue];
                            //首页回调
                            [weakSelf.delegateBiuSender controllerBiuBiuSend:self sendResult:YES virtualCurrency:virtualCurrency];
                            //更改提示框
                            [hud xmSetCustomModeWithResult:YES label:@"发送成功"];
                            
                            [UserDefultBiu setBiuUserProfileOfGrab:@""];
                            [UserDefultBiu setBiuSendTime];
                            [MobClick event:@"biu_send"];
                            //关闭提示框、跳回主页
                        }else{
                            [hud xmSetCustomModeWithResult:YES label:@"biu还未结束"];
                        }
                        
                        [UserDefultBiu setBiuInMatch:YES];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [hud hide:YES];
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        });
                    }else{
                        
                        [UserDefultBiu setBiuInMatch:NO];
                        [hud xmSetCustomModeWithResult:YES label:@"发送失败"];
                        [hud hide:YES afterDelay:1.5];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [UserDefultBiu setBiuInMatch:NO];
                    [hud xmSetCustomModeWithResult:NO label:@"发送失败"];
                    [hud hide:YES afterDelay:1.5];
                }];
            }
        }
        
    }else{
    }
}

- (IBAction)onClickBtnEndEdit:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition{
    CGFloat constraintHeight;
    if (transition.toVisible) {
        constraintHeight = transition.toFrame.size.height;
    }else{
        constraintHeight = -40;
    }
    
    [UIView animateWithDuration:transition.animationDuration animations:^{
        self.constarintViewEndEditBottom.constant = constraintHeight;
        self.constraintViewEndEditSuperHeight.constant = constraintHeight+40;
        [self.view layoutIfNeeded]; //修改约束时需要添加此句
    }];
}

- (void)getModelBiuSendChatTopics{
    if (!self.chatTopicsLoadResult) {
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"type":@"chat", @"token":[UserDefultAccount token]};
        __weak typeof (self) weakSelf = self;
        [httpManager POST:[XMUrlHttp xmAllCharactersInterestChatTopic] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ModelResponse *response = [ModelResponse responselWithObject:responseObject];
            
            if (response.state == 200) {
                weakSelf.chatTopicsLoadResult = YES;
                weakSelf.modelBiuSendChatTopics = [ModelBiuSendChatTopics modelWithDictionary:response.data];
                //[self.collectionViewChats reloadData];
            }else{
                NSLog(@"加载话题标签错误:%@", responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"加载话题标签错误:%@", error);
        }];
    }
}

- (void)updateViewCardWrapConstraint{
    if ([UIScreen is35Screen]) {
        self.constraintViewCardWrapTop.constant = 10;
    }
}


- (IBAction)RandomTopic:(id)sender {
    [self.view endEditing:YES];
    ModelBiuSendChatTopic *topic;
    while (true && self.modelBiuSendChatTopics.tags.count>0) {
        int index = arc4random() % self.modelBiuSendChatTopics.tags.count;
        //取出数据
        topic = [self.modelBiuSendChatTopics modelOfIndex:index];
        //取出当前的
        NSString *nowTopic = self.textViewTopic.text;
        if ([nowTopic isEqualToString:topic.topicContent]) {
            continue;
        }else{
            self.textViewTopic.text = topic.topicContent;
            self.placeholderLabel.hidden = YES;
            break;
        }
    }
    self.labelCodeCount.text = [NSString stringWithFormat:@"%lu/50", (unsigned long)topic.topicContent.length];
    self.btnSendBiu.enabled = YES;
}

- (void)dealloc{
    
}

@end
