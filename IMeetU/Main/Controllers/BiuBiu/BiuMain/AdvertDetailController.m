//
//  AdvertDetailController.m
//  IMeetU
//
//  Created by Spring on 16/5/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "AdvertDetailController.h"
#import "UIStoryboard+Plug.h"
#import "ModelAdvert.h"
#import "MBProgressHUD+plug.h"

@interface AdvertDetailController ()<UIWebViewDelegate>

@property (nonatomic, weak) ModelAdvert *model;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIWebView *advertWebView;

@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation AdvertDetailController

+ (instancetype)shareControllerAdvertWithModel:(ModelAdvert *)model{
    AdvertDetailController *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"AdvertDetailController"];
    controller.model = model;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleName =@"";
    if (!self.model.name) {
        titleName = self.model.title;
    }else{
        titleName = self.model.name;
    }
    [self.labelTitle setText:titleName];
    NSURL *url = [NSURL URLWithString:self.model.url];
    self.advertWebView.delegate = self;
    
    [self.advertWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"加载中..." animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.hud hide:YES];
}

- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
