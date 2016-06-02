//
//  ControllerCommunity.m
//  IMeetU
//
//  Created by Spring on 16/5/26.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerCommunity.h"
#import "SMPagerTabView.h"
#import "UIStoryboard+Plug.h"
#import "ControllerPostList.h"
#import "ControllerPostRelease.h"
#import "ControllerPostTags.h"
#import "UIColor+Plug.h"
#import <YYKit/YYKit.h>
#import "ModelTag.h"
#import "ControllerCommunityNotifies.h"

@interface ControllerCommunity ()<ControllerPostListDelegate,SMPagerTabViewDelegate, ControllerPostTagsDelegate>
@property (strong, nonatomic) SMPagerTabView *titleView;
/**
 *  存储子视图控制器
 */
@property (strong,nonatomic) NSMutableArray *subViewArray;

@end

@implementation ControllerCommunity

/**
 *  单例对象
 *
 *  @return 单例
 */
+ (instancetype)shareControllerCommunity{
    static ControllerCommunity *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerCommunity"];
    });
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    // Do any additional setup after loading the view from its nib
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

/**
 *  进行页面布局
 */
- (void)prepareUI{
    self.navigationController.navigationBar.hidden = YES;
    //默认情况下，上面的titleView是显示的
    [self.view addSubview:self.titleView];
    _subViewArray = [NSMutableArray array];
    
    ControllerPostList *postListRecommend = [[ControllerPostList alloc] init];
    postListRecommend.postListType = PostListTypeRecommend;
    postListRecommend.title = @"推荐";
    postListRecommend.delegate = self;
    [self.subViewArray addObject:postListRecommend];
    
    ControllerPostList *postListNew = [[ControllerPostList alloc] init];
    postListNew.postListType = PostListTypeNew;
    postListNew.title = @"新鲜";
    postListNew.delegate = self;
    [self.subViewArray addObject:postListNew];
    
    ControllerPostList *postListBiuBiu = [[ControllerPostList alloc] init];
    postListBiuBiu.postListType = PostListTypeBiuBiu;
    postListBiuBiu.title = @"biubiu";
    postListBiuBiu.delegate = self;
    [self.subViewArray addObject:postListBiuBiu];
    
    _titleView.delegate = self;
    [_titleView buildUI];
    [_titleView selectTabWithIndex:0 animate:NO];
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [_subViewArray count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return _subViewArray[number];
}


- (void)whenSelectOnPager:(NSUInteger)number {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ControllerPostListDelegate
- (void)hideTitleView:(BOOL)isHidden{
    if (isHidden && _titleView.tabFrameHeight == 36.0) {
        [UIView animateWithDuration:1 animations:^{
            _titleView.tabFrameHeight = 0.5;
            [_titleView setHide];
        } completion:^(BOOL finished) {
            [_titleView setNeedsLayout];
        }];
    }
    if (!isHidden && _titleView.tabFrameHeight == 0.5) {
        [UIView animateWithDuration:1 animations:^{
            _titleView.tabFrameHeight = 36.0;
            [_titleView setShow];
        } completion:^(BOOL finished) {
            [_titleView setNeedsLayout];
        }];
    }
}

#pragma mark titleView getter
- (SMPagerTabView *)titleView{
    if (!_titleView) {
        self.titleView = [[SMPagerTabView  alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64 - 49 )];
        self.titleView.selectedLineWidth = self.view.width / 3;
        self.titleView.tabButtonFontSize = 15;
    }
    return _titleView;
}

- (IBAction)onClickBtnNotifies:(id)sender {
    ControllerCommunityNotifies *controller = [ControllerCommunityNotifies controller];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClickBtnTags:(id)sender {
    ControllerPostTags *controller = [ControllerPostTags controller];
    controller.delegatePostTags = self;
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)onClickBtnPostRelease:(id)sender {
    ControllerPostRelease *controller = [ControllerPostRelease controller];
    //[self.navigationController pushViewController:controller animated:NO];
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)controllerPostTags:(ControllerPostTags *)controller model:(ModelTag *)model{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
