//
//  AdvertDetailController.m
//  IMeetU
//
//  Created by Spring on 16/5/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "AdvertDetailController.h"
#import "UIStoryboard+Plug.h"
@interface AdvertDetailController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *advertWebView;
@end

@implementation AdvertDetailController

+ (instancetype)shareControllerAdvert{
    static AdvertDetailController *controller;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"AdvertDetailController"];
    });
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:self.advertUrl];
    [self.advertWebView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
