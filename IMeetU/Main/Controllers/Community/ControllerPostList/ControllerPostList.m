//
//  ControllerPostList.m
//  IMeetU
//
//  Created by Spring on 16/5/27.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerPostList.h"
#import "MJRefresh.h"
#import "UIColor+Plug.h"
#import "UIView+Plug.h"
#import "UIViewAdditions.h"
#import "UINib+Plug.h"
#import "PostListCell.h"

@interface ControllerPostList ()<UITableViewDelegate,UITableViewDataSource,ZXCycleScrollViewDelegate,ZXCycleScrollViewDatasource>{
    //记录当前的位置
    CGFloat contentOffsetY;
    //新的位置
    CGFloat newContentOffsetY;
    //旧的位置
    CGFloat oldContentOffsetY;
}
@property (nonatomic,strong) UITableView *postListTableView;
@end

@implementation ControllerPostList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    // Do any additional setup after loading the view.
}


- (void)prepareUI{
    [self.view addSubview:self.postListTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)postListTableView{
    if (!_postListTableView) {
        _postListTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _postListTableView.delegate = self;
        _postListTableView.dataSource = self;
        _postListTableView.showsVerticalScrollIndicator = NO;
        _postListTableView.showsHorizontalScrollIndicator = NO;
        // 上拉刷新和下拉加载
        _postListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_postListTableView.mj_header endRefreshing];
        }];
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_postListTableView.mj_header;
        header.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
        header.lastUpdatedTimeLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
        header.stateLabel.font = [UIFont systemFontOfSize:12];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
        
        _postListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [_postListTableView.mj_footer endRefreshing];
        }];
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_postListTableView.mj_footer;
        footer.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        //设置为没有颜色
        _postListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _postListTableView.tableHeaderView = self.cycleScrollView;
        //进行列表的注册
        [_postListTableView registerNib:[UINib xmNibFromMainBundleWithName:@"PostListCell"] forCellReuseIdentifier:@"PostListCell"];
    }
    return _postListTableView;
}

- (ZXCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[ZXCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 138.0)];
        _cycleScrollView.delegate = self;
        _cycleScrollView.datasource = self;
        [_cycleScrollView changePageControlColor:[UIColor blackColor] :[UIColor whiteColor] ];
        //Timer不启动
        [_cycleScrollView.timer setFireDate:[NSDate distantFuture]];
    }
    return _cycleScrollView;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostListCell *postListCell = [tableView dequeueReusableCellWithIdentifier:@"PostListCell"];
    postListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return postListCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ControllerReply *controllerReply = [ControllerReply shareControllerReply];
    if(self.delegate){
        if ([self.delegate respondsToSelector:@selector(pushController:)]) {
            [self.delegate pushController:controllerReply];
        }
    }

}
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    contentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging) {  // 拖拽
        if ((scrollView.contentOffset.y - contentOffsetY) > 15.0f) {  // 向上拖拽
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(hideTitleView:)]) {
                    [self.delegate hideTitleView:YES];
                }
            }
            contentOffsetY = scrollView.contentOffset.y;
        } else if ((contentOffsetY - scrollView.contentOffset.y) > 15.0f) {   // 向下拖拽
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(hideTitleView:)]) {
                    [self.delegate hideTitleView:NO];
                }
            }
            contentOffsetY = scrollView.contentOffset.y;
        } else {
            
        }
    }
}

#pragma mark ZXCycleScrollViewDelegate,ZXCycleScrollViewDatasource
//返回滚动视图的个数
- (NSInteger)numberOfPages{
    return 3;
}
//定义ScrollView
- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.cycleScrollView.bounds];
    if (index==0) {
        imageView.backgroundColor=[UIColor orangeColor];
    }else if (index==1){
        imageView.backgroundColor=[UIColor purpleColor];
    }else{
        imageView.backgroundColor=[UIColor greenColor];
    }
    return imageView;
}

#pragma  delegate
- (void)didClickPage:(ZXCycleScrollView *)csView atIndex:(NSInteger)index
{
    NSLog(@"%li",(long)index);
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
