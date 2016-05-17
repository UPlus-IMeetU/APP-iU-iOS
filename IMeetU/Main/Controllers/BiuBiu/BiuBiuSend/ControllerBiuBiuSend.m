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

#import "MobClick.h"

#import "UICollectionViewAlignRightLayout.h"


#define CellReuseIdentifier @"CellBiuBiuSend"

@interface ControllerBiuBiuSend ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YYKeyboardObserver>

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIView *viewCard;
@property (weak, nonatomic) IBOutlet UILabel *labelCodeCount;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewChats;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTopic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constarintViewEndEditBottom;
@property (weak, nonatomic) IBOutlet UIView *viewEndEdit;
@property (weak, nonatomic) IBOutlet UIView *viewEndEditSuper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewEndEditSuperHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnSendBiu;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewCardWrapTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewCardWrapBottom;

@property (nonatomic, strong) ModelBiuSendChatTopics *modelBiuSendChatTopics;

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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewAlignRightLayout alloc] init];
    self.collectionViewChats.collectionViewLayout = layout;
    [self.collectionViewChats registerNib:[UINib xmNibFromMainBundleWithName:CellReuseIdentifier] forCellWithReuseIdentifier:CellReuseIdentifier];
    self.collectionViewChats.dataSource = self;
    self.collectionViewChats.delegate = self;
    self.collectionViewChats.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }];
    [self.viewMain addGestureRecognizer:tapGestureRecognizer];
    
    
    [self.textFieldTopic addBlockForControlEvents:UIControlEventEditingDidBegin block:^(id  _Nonnull sender) {
        [self.modelBiuSendChatTopics selectItemOfIndex:NSIntegerMax];
        [self.collectionViewChats reloadData];
        
        self.btnSendBiu.enabled = NO;
       self.labelCodeCount.text = @"0/50";
    }];
    [self.textFieldTopic addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
        if (self.textFieldTopic.text.length>50) {
            self.textFieldTopic.text = [self.textFieldTopic.text substringToIndex:50];
        }
        
        self.btnSendBiu.enabled = self.textFieldTopic.text.length>0;
        self.labelCodeCount.text = [NSString stringWithFormat:@"%lu/50", self.textFieldTopic.text.length];
    }];
    
    [self.btnProfile setBackgroundImageWithURL:[NSURL URLWithString:[UserDefultAccount userProfileUrlThumbnail]] forState:UIControlStateNormal placeholder:nil];
    
    [self getModelBiuSendChatTopics];
    
    YYKeyboardManager *keyboardManager = [YYKeyboardManager defaultManager];
    [keyboardManager addObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //如果加载失败，重新加载
    if (!self.chatTopicsLoadResult) {
        [self getModelBiuSendChatTopics];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.modelBiuSendChatTopics selectItemOfIndex:NSIntegerMax];
    [self.collectionViewChats reloadData];
    [self.textFieldTopic setText:@""];
    [self.labelCodeCount setText:@"0/50"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.modelBiuSendChatTopics numberOfItems];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellBiuBiuSend *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    [cell initWithModel:[self.modelBiuSendChatTopics modelOfIndex:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self.modelBiuSendChatTopics selectItemOfIndex:indexPath.row];
    ModelBiuSendChatTopic *topic = [self.modelBiuSendChatTopics modelOfIndex:indexPath.row];
    [self.textFieldTopic setText:topic.topicContent];
    self.labelCodeCount.text = [NSString stringWithFormat:@"%lu/50", topic.topicContent.length];
    
    self.btnSendBiu.enabled = YES;
    [self.collectionViewChats reloadData];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onClickBtnSendFinish:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"发送中" animated:YES];
    
    if (self.textFieldTopic.text && self.textFieldTopic.text.length>0) {
        if (self.delegateBiuSender){
            if ([self.delegateBiuSender respondsToSelector:@selector(controllerBiuBiuSend:sendResult:virtualCurrency:)]) {
                
                AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
                httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
                httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
                
                NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"chat_tags":self.textFieldTopic.text};
                [httpManager POST:[XMUrlHttp xmBiuSend] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                    if (response.state == 200) {
                        NSInteger virtualCurrency = [response.data[@"virtual_currency"] integerValue];
                        //首页回调
                        [self.delegateBiuSender controllerBiuBiuSend:self sendResult:YES virtualCurrency:virtualCurrency];
                        //更改提示框
                        [hud xmSetCustomModeWithResult:YES label:@"发送成功"];
                        
                        [MobClick event:@"biu_send"];
                       //关闭提示框、跳回主页
                        dispatch_after(5*NSEC_PER_SEC, dispatch_get_main_queue(), ^{
                            [hud hide:YES];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                    }else{
                        [hud xmSetCustomModeWithResult:YES label:@"发送失败"];
                        [hud hide:YES afterDelay:3];
                    }
                    
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [hud xmSetCustomModeWithResult:NO label:@"发送失败"];
                    [hud hide:YES afterDelay:3];
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
        [self.viewEndEditSuper layoutIfNeeded]; //修改约束时需要添加此句
    }];
}

- (void)getModelBiuSendChatTopics{
    if (!self.chatTopicsLoadResult) {
        AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *parameters = @{@"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"type":@"chat", @"token":[UserDefultAccount token]};
        [httpManager POST:[XMUrlHttp xmAllCharactersInterestChatTopic] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ModelResponse *response = [ModelResponse responselWithObject:responseObject];
            
            if (response.state == 200) {
                self.chatTopicsLoadResult = YES;
                
                self.modelBiuSendChatTopics = [ModelBiuSendChatTopics modelWithDictionary:response.data];
                [self.collectionViewChats reloadData];
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
        self.constraintViewCardWrapBottom.constant = 10;
    }
}

@end
