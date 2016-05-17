//
//  ControllerAboutIU.m
//  IMeetU
//
//  Created by zhanghao on 16/3/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerAboutIU.h"
#import "UIStoryboard+Plug.h"

#import "MLToast.h"

#import <StoreKit/StoreKit.h>
#import "MBProgressHUD+plug.h"

@interface ControllerAboutIU ()<SKStoreProductViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewMain;

@end

@implementation ControllerAboutIU

+ (instancetype)controller{
    ControllerAboutIU *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameGuide indentity:@"ControllerAboutIU"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (IBAction)onClickBtnEvaluation:(id)sender {
    [self evaluate];
}

- (IBAction)onClickBtnCopyWX:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"liu534469675";

    [[MLToast toastInView:self.view content:@"已复制微信号"] show];
    
}

- (IBAction)onClickBtnPhone:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"010-52725343"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)evaluate{
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"启动..." animated:YES];
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId
     @{SKStoreProductParameterITunesItemIdentifier : @"1054807926"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             [hud xmSetCustomModeWithResult:NO label:@"启动失败"];
             [hud hide:YES afterDelay:1];
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出AppStore应用界面
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 [hud hide:YES];
             }
              ];
         }
     }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
