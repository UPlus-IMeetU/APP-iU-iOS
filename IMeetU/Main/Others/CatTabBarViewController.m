//
//  CatTabBarViewController.m
//  Catweibo
//
//  Created by Justin on 15/4/2.
//  Copyright (c) 2015年 Justin. All rights reserved.
//

//在setupAllChildViewControllers 方法里面初始化试图控制器

//nav 背景图片
#define NAVBAR_IMAGE @"tabbar"
//nav字体颜色
#define K_NAV_FONT_COLOR [UIColor whiteColor]

#import "CatTabBarViewController.h"
#import "FilmViewController.h"
#import "CinemaViewController.h"
#import "TIcketViewController.h"
#import "MineViewController.h"
#import "CatTabBar.h"
@interface CatTabBarViewController ()<CatTabBarDelegate>
//自定义tabbar
@property (nonatomic,weak) CatTabBar *customTabBar;
@end

@implementation CatTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化Tabbar
    [self setupTabbar];
    
    //初始化所有的子控制器
    [self setupAllChildViewControllers];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@",self.tabBar.subviews);
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

//监听tabbar按钮的改变
- (void)tabbar:(CatTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to {
    self.selectedIndex = to;
}

//初始化tabbar
- (void)setupTabbar {
    
    CatTabBar *customTabbar = [[CatTabBar alloc]init];
    //customTabbar.backgroundColor = [UIColor redColor];
    customTabbar.frame = self.tabBar.bounds;
    customTabbar.delegate = self;
    [self.tabBar addSubview:customTabbar];
    self.customTabBar = customTabbar;
    
}

//初始化所有的子控制器
- (void)setupAllChildViewControllers
{
    //1.
    FilmViewController *home = [[FilmViewController alloc] init];
    
    [self setupChildViewController:home title:@"查影片" imageName:@"movieNews" selectedImageName:@"movieNews"];
    //2.
    CinemaViewController *message = [[CinemaViewController alloc] init];
    [self setupChildViewController:message title:@"找影院" imageName:@"theater" selectedImageName:@"theater"];
    //3.
    TicketViewController *discover =[[TicketViewController alloc] init];
    [self setupChildViewController:discover title:@"淘影票" imageName:@"ticket" selectedImageName:@"ticket"];
    //4.
    MineViewController *me =[[MineViewController alloc] init];
    [self setupChildViewController:me title:@"我的" imageName:@"personal" selectedImageName:@"personal"];
}


/*
 *  初始化一个自控制器
 
 *  childVc             需要初始化的子控制器
 *  title               标题
 *  imageName           图标
 *  selectImageName     选择的图标
 */


- (void)setupChildViewController:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    //1.设置控制器的属性
    childVC.title = title;
    
    //设置图标
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    //设置选中的图标
        childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];  
    
    //2.包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    //背景图片
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:NAVBAR_IMAGE] forBarMetrics:(UIBarMetricsDefault)];
    
    //详情自定义navigationbar的title字体
    UIColor *color = K_NAV_FONT_COLOR;
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    nav.navigationBar.titleTextAttributes = dict;

    [self addChildViewController:nav];
    
    //3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVC.tabBarItem];
    
}

@end
