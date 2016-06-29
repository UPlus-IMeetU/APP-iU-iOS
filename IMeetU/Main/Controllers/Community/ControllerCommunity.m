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
#import "ViewDrawerRightLoginRegister.h"
#import "UserDefultAppGlobalStatus.h"
#import "ControllerUserLogin.h"
#import "ControllerUserRegisterThirdStep.h"
#import "UserDefultAccount.h"
#import "ControllerSamePostList.h"
#import "ControllerTabBarMain.h"

@interface ControllerCommunity ()<ControllerPostListDelegate,SMPagerTabViewDelegate, ControllerPostTagsDelegate,ViewDrawerRightLoginRegisterDelegate>
@property (strong, nonatomic) SMPagerTabView *titleView;
/**
 *  存储子视图控制器
 */
@property (strong,nonatomic) NSMutableArray *subViewArray;

@property (weak, nonatomic) IBOutlet UIButton *btnNotifies;
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
}

- (void)viewWillAppear:(BOOL)animated{
    
    if ([UserDefultAppGlobalStatus noticeCount]) {
        [self.btnNotifies setImage:[UIImage imageNamed:@"btn_activity_light"] forState:UIControlStateNormal];
    }else{
        [self.btnNotifies setImage:[UIImage imageNamed:@"found_btn_activity_nor"] forState:UIControlStateNormal];
    }
    [(ControllerPostList *)[_subViewArray objectAtIndex:0] refreshView];
    [(ControllerPostList *)[_subViewArray objectAtIndex:1] refreshView];
    [(ControllerPostList *)[_subViewArray objectAtIndex:2] refreshView];
}

- (void)viewDidAppear:(BOOL)animated{
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
    postListBiuBiu.title = @"BiuBiu";
    postListBiuBiu.delegate = self;
    [self.subViewArray addObject:postListBiuBiu];
    
    _titleView.delegate = self;
    [_titleView buildUI];
    [_titleView selectTabWithIndex:1 animate:NO];
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
    if (isHidden && _titleView.tabView.alpha == 1) {
        [_titleView setHide];
        [UIView animateWithDuration:0.25f animations:^{
            _titleView.tabView.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    }
    if (!isHidden && _titleView.tabView.alpha == 0) {
        
        [UIView animateWithDuration:0.25f animations:^{
            _titleView.tabView.alpha = 1;
        } completion:^(BOOL finished) {
            [_titleView setShow];
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

- (IBAction)onClickBtnNotifies:(UIButton*)sender {
    [sender setImage:[UIImage imageNamed:@"biu_btn_activity_nor"] forState:UIControlStateNormal];
    ControllerCommunityNotifies *controller = [ControllerCommunityNotifies controller];
    [self.navigationController pushViewController:controller animated:YES];
    [[ControllerTabBarMain shareController] hideBadgeWithIndex:1];
}

- (IBAction)onClickBtnTags:(id)sender {
    ControllerPostTags *controller = [ControllerPostTags controllerWithType:ControllerPostTagsTypeSearch];
    controller.delegatePostTags = self;
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)onClickBtnPostRelease:(id)sender {
    ControllerPostRelease *controller = [ControllerPostRelease controller];
    controller.postReleaseSuccessBlock = ^(BOOL success){
        if (success) {
             [(ControllerPostList *)[_subViewArray objectAtIndex:1] updateView];
        }
    };
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)controllerPostTags:(ControllerPostTags *)controller model:(ModelTag *)model{
    ControllerSamePostList *samePostList = [ControllerSamePostList controllerSamePostList];
    samePostList.titleName = model.content;
    samePostList.tagId = model.tagId;
    [self.navigationController pushViewController:samePostList animated:YES];
}

#pragma mark ViewDrawerRightLoginRegisterDelegate
- (void)viewDrawerRightLogin:(ViewDrawerRightLoginRegister *)view{
    ControllerUserLogin *controller = [ControllerUserLogin controller];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDrawerRightRegister:(ViewDrawerRightLoginRegister *)view{
    ControllerUserRegisterThirdStep *controller = [ControllerUserRegisterThirdStep controller];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
