//
//  ViewBiuPayB.m
//  IMeetU
//
//  Created by zhanghao on 16/4/5.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ViewBiuPayB.h"
#import "MBProgressHUD+plug.h"
#import "UIColor+Plug.h"

#import "BeeCloud.h"
#import "AFNetworking.h"
#import "UIScreen+Plug.h"

#import "XMUrlHttp.h"
#import <YYKit/YYKit.h>

#import "ModelResponse.h"
#import "UserDefultAccount.h"

#define testUserCode @"12880"

@interface ViewBiuPayB()<BeeCloudDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) CGFloat viewHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelUmCountNow;
@property (nonatomic, assign) NSInteger umiCountNow;

@property (weak, nonatomic) IBOutlet UIButton *btnUmiSelect_0;
@property (weak, nonatomic) IBOutlet UIButton *btnUmiSelect_1;
@property (weak, nonatomic) IBOutlet UIButton *btnUmiSelect_2;
@property (weak, nonatomic) IBOutlet UIButton *btnUmiSelect_3;
@property (weak, nonatomic) IBOutlet UILabel *labelUmiCount_0;
@property (weak, nonatomic) IBOutlet UILabel *labelUmiCount_1;
@property (weak, nonatomic) IBOutlet UILabel *labelUmiCount_2;
@property (weak, nonatomic) IBOutlet UILabel *labelUmiCount_3;

@property (nonatomic, assign) NSInteger umiSumMoney;
@property (nonatomic, assign) NSInteger umiCountSelected;
@property (weak, nonatomic) IBOutlet UILabel *labelUmiCountSelected;
@property (weak, nonatomic) IBOutlet UILabel *labelUmiMoneySelected;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedPayWay;
@property (weak, nonatomic) IBOutlet UIButton *btnPayALi;
@property (weak, nonatomic) IBOutlet UIButton *btnPayWeChat;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, strong) MBProgressHUD *hud;

@end
@implementation ViewBiuPayB

- (void)initialWithUmiCount:(NSInteger)umiCount{
    self.umiCountNow = umiCount;
    self.umiCountSelected = 60;
    self.segmentedPayWay.tintColor = [UIColor colorWithR:115 G:193 B:234];
    
    [self.labelUmCountNow setText:[NSString stringWithFormat:@"%lu粒", (long)self.umiCountNow]];
}

- (void)initWithViewHeight:(CGFloat)height{
    self.viewHeight = height;
}

- (void)layoutSubviews{
    self.frame = CGRectMake(0, 0, [UIScreen screenWidth], self.viewHeight);
}

- (IBAction)onClickBtnUmiSelect_0:(UIButton*)sender {
    [self selectedBtnUmi:sender umiCount:self.labelUmiCount_0 umiCount:60];
}

- (IBAction)onClickBtnUmiSelect_1:(UIButton*)sender {
    [self selectedBtnUmi:sender umiCount:self.labelUmiCount_1 umiCount:120];
}

- (IBAction)onClickBtnUmiSelect_2:(UIButton*)sender {
    [self selectedBtnUmi:sender umiCount:self.labelUmiCount_2 umiCount:500];
}

- (IBAction)onClickBtnUmiSelect_3:(UIButton*)sender {
    [self selectedBtnUmi:sender umiCount:self.labelUmiCount_3 umiCount:980];
}

- (void)selectedBtnUmi:(UIButton*)btn umiCount:(UILabel*)label umiCount:(NSInteger)count{
    [self.btnUmiSelect_0 setBackgroundImage:[UIImage imageNamed:@"pay_btn_buybiubiu"] forState:UIControlStateNormal];
    [self.btnUmiSelect_1 setBackgroundImage:[UIImage imageNamed:@"pay_btn_buybiubiu"] forState:UIControlStateNormal];
    [self.btnUmiSelect_2 setBackgroundImage:[UIImage imageNamed:@"pay_btn_buybiubiu"] forState:UIControlStateNormal];
    [self.btnUmiSelect_3 setBackgroundImage:[UIImage imageNamed:@"pay_btn_buybiubiu"] forState:UIControlStateNormal];
    [self.labelUmiCount_0 setTextColor:[UIColor blackColor]];
    [self.labelUmiCount_1 setTextColor:[UIColor blackColor]];
    [self.labelUmiCount_2 setTextColor:[UIColor blackColor]];
    [self.labelUmiCount_3 setTextColor:[UIColor blackColor]];
    
    [label setTextColor:[UIColor whiteColor]];
    [btn setBackgroundImage:[UIImage imageNamed:@"pay_btn_buybiubiu_light"] forState:UIControlStateNormal];
    
    [self.labelUmiCountSelected setText:[NSString stringWithFormat:@"%lu米", (long)count]];
    [self.labelUmiMoneySelected setText:[NSString stringWithFormat:@"￥%lu", count/10]];
    self.umiCountSelected = count;
}

- (IBAction)onClickBtnPayALi:(id)sender {
    self.segmentedPayWay.tintColor = [UIColor colorWithR:115 G:193 B:234];
    self.segmentedPayWay.selectedSegmentIndex = 0;
    [self doPay:PayChannelAliApp];
}

- (IBAction)onClickBtnPayWeChat:(id)sender {
    self.segmentedPayWay.tintColor = [UIColor colorWithR:131 G:204 B:116];
    self.segmentedPayWay.selectedSegmentIndex = 1;
    [self doPay:PayChannelWxApp];
}


- (void)doPay:(PayChannel)channel {
    [BeeCloud setBeeCloudDelegate:self];
    self.hud  = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self label:@"通知中..." animated:YES];
    
    NSString *channelStr = @"";
    if (channel==PayChannelAliApp) {
        channelStr = @"ali";
    }else if (channel==PayChannelWxApp){
        channelStr = @"wx";
    }
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"bill_type":@"1", @"channel":channelStr, @"title":@"U米充值", @"totalfee":[NSNumber numberWithInteger:self.umiSumMoney], @"totalnum":[NSNumber numberWithInteger:self.umiCountSelected]};
    [httpManager POST:[XMUrlHttp xmPayCreateBiuOrder] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            //[self.hud hide:YES];
            
            NSDictionary *res = response.data;
            self.orderCode = res[@"bill_no"];
            
            [BeeCloud setBeeCloudDelegate:self];
            //构造支付请求对象
            BCPayReq *payReq = [[BCPayReq alloc] init];
            //设置支付类型（支付宝/微信）
            payReq.channel = channel;
            //设置订单名称（活动名称）
            payReq.title = @"U米充值";
            //设置订单价格
            payReq.totalFee = [NSString stringWithFormat:@"%lu", (long)self.umiSumMoney];
            //设置订单号（使用ObjActivityOrder的id）
            payReq.billNo = self.orderCode;
            //设置scheme
            if (channel == PayChannelAliApp) {
                payReq.scheme = @"ailipayimeetucc";
            }else if (channel == PayChannelWxApp){
                payReq.scheme = @"wxc38cdfe5049cb17e";
            }
            //设置订单超时时间
            payReq.billTimeOut = 1000;
            //设置附加参数
            payReq.optional = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@"umi"}];
            //发起支付请求
            [BeeCloud sendBCReq:payReq];
        }else{
            [self.hud xmSetCustomModeWithResult:NO label:@"订单生成失败"];
            [self.hud hide:YES afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud xmSetCustomModeWithResult:NO label:@"订单生成失败"];
        [self.hud hide:YES afterDelay:1.5];
    }];
}

- (void)onBeeCloudResp:(BCBaseResp *)resp{
    self.hud.labelText = @"校验中...";
    
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
            //支付响应事件类型，包含微信、支付宝、银联、百度
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == BCErrCodeSuccess) {
                AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
                httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
                httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
                
                NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"bill_no":self.orderCode};
                [httpManager POST:[XMUrlHttp xmPayVerifyUmiOrderRes] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                    if (response.state==200) {
                        NSDictionary *res = response.data;
                        NSInteger payRes = [res[@"result"] integerValue];
                        self.umiCountNow = [res[@"virtual_currency"] integerValue];
                        if (payRes==0) {
                            [self.hud xmSetCustomModeWithResult:NO label:@"支付失败"];
                        }else if (payRes==1){
                            [self.hud xmSetCustomModeWithResult:YES label:@"支付成功"];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                if (self.delegatePayUmi) {
                                    if ([self.delegatePayUmi respondsToSelector:@selector(viewBiuPayB:payRes:umiCount:)]) {
                                        [self.delegatePayUmi viewBiuPayB:self payRes:YES umiCount:self.umiCountNow];
                                    }
                                }
                            });
                        }
                    }else{
                        [self.hud xmSetCustomModeWithResult:NO label:@"支付失败"];
                    }
                    NSLog(@"%@", responseObject);
                    [self.hud hide:YES afterDelay:1.5];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self.hud xmSetCustomModeWithResult:NO label:@"支付失败"];
                    [self.hud hide:YES afterDelay:1.5];
                }];
                
            } else if(tempResp.resultCode == BCErrCodeUserCancel){
                [self.hud xmSetCustomModeWithResult:NO label:@"支付取消"];
            }else if (tempResp.resultCode == BCErrCodeSentFail){
                [self.hud xmSetCustomModeWithResult:NO label:@"发送错误"];
            }else if (tempResp.resultCode == BCErrCodeCommon){
                [self.hud xmSetCustomModeWithResult:NO label:@"支付失败"];
            }
            [self.hud hide:YES afterDelay:1.5];
        }
            break;
        default:
        {}
            break;
    }
}

- (NSInteger)umiSumMoney{
    return self.umiCountSelected/10*100;
}

- (IBAction)buyButtonClick:(id)sender {
    NSLog(@"购买的是%ld",(long)_umiCountSelected);
    //进行了购买的操作
    //测试
    if ([[UserDefultAccount userCode] isEqualToString:testUserCode]) {
          [self.delegatePayUmi buyUMi:_umiCountSelected];
    }else{
        [self showActionSheet];
    }
}

- (void)showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择支付方式"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"支付宝", @"微信",@"苹果支付",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //选择了支付宝
        [self doPay:PayChannelAliApp];
    }else if(buttonIndex == 1){
        //选择了微信
        [self doPay:PayChannelWxApp];
    }else if(buttonIndex == 2){
        //选择了苹果内购
        [self.delegatePayUmi buyUMi:_umiCountSelected];
    }
}
@end
