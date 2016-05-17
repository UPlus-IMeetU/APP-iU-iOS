//
//  ControllerUserProtocol.m
//  IMeetU
//
//  Created by zhanghao on 16/3/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerUserProtocol.h"

#import "UIStoryboard+Plug.h"
@interface ControllerUserProtocol ()

@property (weak, nonatomic) IBOutlet UIWebView *webViewUserProtocol;

@end

@implementation ControllerUserProtocol

+ (instancetype)controller{
    ControllerUserProtocol *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameAccount indentity:@"ControllerUserProtocol"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webViewUserProtocol loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://protect-app.oss-cn-beijing.aliyuncs.com/app-resources/html/protocol/UserProtocol.html"]]];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
