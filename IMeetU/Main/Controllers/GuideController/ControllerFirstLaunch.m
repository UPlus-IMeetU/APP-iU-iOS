//
//  ControllerFirstLaunch.m
//  IMeetU
//
//  Created by zhanghao on 16/3/4.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerFirstLaunch.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"
#import "ControllerDrawer.h"
#import "AppDelegate.h"
#import "UserDefultConfig.h"

@interface ControllerFirstLaunch ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewPage;
@property (weak, nonatomic) IBOutlet UIButton *btnLaunch;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ControllerFirstLaunch

+ (instancetype)controller{
    ControllerFirstLaunch *controller = [UIStoryboard xmControllerWithName:@"Guide" indentity:@"ControllerFirstLaunch"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollViewPage.delegate = self;
    self.scrollViewPage.pagingEnabled = YES;
    self.scrollViewPage.showsHorizontalScrollIndicator = NO;
    self.scrollViewPage.contentSize = CGSizeMake([UIScreen screenWidth]*3, 0);
    
    for (int i=0; i<3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*[UIScreen screenWidth], 0, [UIScreen screenWidth], [UIScreen screenHeight])];
        imgView.image = [self imgWithIndex:i];
        [self.scrollViewPage addSubview:imgView];
    }
    
    self.btnLaunch.alpha = 0;
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = (scrollView.contentOffset.x/[UIScreen screenWidth]+0.5);
    self.btnLaunch.alpha = (scrollView.contentOffset.x-[UIScreen screenWidth])/[UIScreen screenWidth];
}

- (UIImage*)imgWithIndex:(NSInteger)index{
    NSInteger size = 35;
    if ([UIScreen is35Screen]) {
        size = 35;
    }else if ([UIScreen is40Screen]){
        size = 40;
    }else if ([UIScreen is47Screen]){
        size = 47;
    }else if ([UIScreen is55Screen]){
        size = 55;
    }
    NSString *imgName = [NSString stringWithFormat:@"guide_page_img_bg_%lu_%lu", index, size];
    
    return [UIImage imageNamed:imgName];
}

- (IBAction)onClickBtnLaunch:(id)sender {
    [UserDefultConfig setNoFirshLaunch];
    [AppDelegate launchFirst];
}



@end
