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


#import "XMHttpCommunity.h"
#import "ModelCommunity.h"
#import "ModelAdvert.h"
#import "AdvertDetailController.h"
#import "YYKit/YYKit.h"
@interface ControllerPostList ()<UITableViewDelegate,UITableViewDataSource,ZXCycleScrollViewDelegate,ZXCycleScrollViewDatasource>{
    //记录当前的位置
    CGFloat contentOffsetY;
    //新的位置
    CGFloat newContentOffsetY;
    //旧的位置
    CGFloat oldContentOffsetY;
}
@property (nonatomic,strong) UITableView *postListTableView;
/**
 *  帖子
 */
@property (nonatomic,strong) NSMutableArray *postListArray;
/**
 *  轮播图
 */
@property (nonatomic,strong) NSMutableArray *bannerArray;
@end

@implementation ControllerPostList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self prepareUI];
    
    //注册通知
    //通知事件 0为删除 1为点赞操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postStatusChange:) name:@"postStatusChange" object:nil];
}


- (void)postStatusChange:(NSNotification *)noti{
    NSDictionary *dict = noti.object;
    //首先遍历出要操作的对象
    NSInteger postId = [[dict objectForKey:@"postId"] integerValue];
    int index = 0;
    BOOL hasObject = NO;
    for( ; index < _postListArray.count ; index ++){
        ModelPost *modelPost = _postListArray[index];
        if (modelPost.postId == postId) {
            hasObject = YES;
            break;
        }
    }
    //如果不存在的话，就跳出
    if (!hasObject) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    
    //进行删除操作
    if ([[dict objectForKey:@"operation"] integerValue] == 0) {
        //删除数据
        [_postListArray removeObjectAtIndex:index];
        [_postListTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }else if([[dict objectForKey:@"operation"] integerValue] == 1){
        ((ModelPost *)_postListArray[index]).isPraise = [dict objectForKey:@"praise"];
        [_postListTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)prepareData{
    _postListArray = [NSMutableArray array];
    _bannerArray = [NSMutableArray array];
    //进行处理
    [[XMHttpCommunity http] loadCommunityListWithType:self.postListType withTimeStamp:0 withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        ModelCommunity *community = [ModelCommunity modelWithJSON:response];
        _postListArray = [NSMutableArray arrayWithArray:community.postList];
        _bannerArray = [NSMutableArray arrayWithArray:community.banner];
        [_postListTableView reloadData];
        [_cycleScrollView reloadData];
    }];
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
        _postListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
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
    __weak typeof(self) weakSelf = self;
    postListCell.postViewOperationBlock = ^(NSInteger postId,OperationType operationType){
        [weakSelf operationBtnClickWithPostId:postId withOperationType:operationType];
    };
    
    postListCell.postViewPraiseBlock = ^(NSInteger postId,NSInteger praise){
        [weakSelf doPraiseWithId:postId WithPraise:praise];
    };
    postListCell.width = self.view.width;
    postListCell.modelPost = _postListArray[indexPath.row];
    return postListCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //计算cell的高度
    ModelPost *modelPost = self.postListArray[indexPath.row];
    NSString *contentStr = modelPost.content;
    CGSize titleSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(self.view.width - 20, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    
    NSInteger imageCount = modelPost.imgs.count;
    NSInteger photoViewWidth = 0;
    if (imageCount == 0) {
        photoViewWidth = -20;
    }else if(imageCount == 1){
        photoViewWidth = self.view.width - 20;
    }else if(imageCount == 2){
        photoViewWidth = (self.view.width - 20 - 5) * 0.5;
    }else if(imageCount == 3){
        photoViewWidth = ceil((self.view.width - 20 - 5 * 2) /  3);
    }else if(imageCount >3 && imageCount <= 6){
        photoViewWidth = ceil((self.view.width - 20 - 5 * 2) /  3) * 2 + 5;
    }else{
       photoViewWidth = ceil((self.view.width - 20 - 5 * 2) /  3) * 3 + 5 * 2;
    }
    return 165.0f +  ceil(titleSize.height) + photoViewWidth;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _postListArray.count;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ControllerReply *controllerReply = [ControllerReply shareControllerReply];
    if(self.delegate){
        [((UIViewController *)self.delegate).navigationController pushViewController:controllerReply animated:YES];
    }

}

- (void)operationBtnClickWithPostId:(NSInteger) postId withOperationType:(OperationType)operationType{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *operationStr = (operationType == OperationTypeDelete) ? @"删除":@"举报";
    NSString *messageStr = (operationType == OperationTypeDelete) ?@"嗨，确定要删除内容么?":@"嗨，确定要举报TA么?";
    [controller addAction:[UIAlertAction actionWithTitle:operationStr style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //弹出框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:operationStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (operationType == OperationTypeDelete) {
                [self deletePostWithId:postId];
            }else{
                [self reportPostWithId:postId];
            }
        }]];
        if (self.delegate) {
            [((UIViewController *)self.delegate) presentViewController:alertController animated:YES completion:nil];
        }
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    if (self.delegate) {
        [((UIViewController *)self.delegate) presentViewController:controller animated:YES completion:nil];
    }
}


#pragma mark 删除操作
- (void)deletePostWithId:(NSInteger)postId{
//    [[XMHttpCommunity http] deletePostWithId:postId withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
//        if (code == 200) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInteger:postId] forKey:@"postId"];
            [dict setObject:@(0) forKey:@"operation"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postStatusChange" object:dict];
//        }
//    }];
}

#pragma mark 举报操作
- (void)reportPostWithId:(NSInteger)postId{
    
}
#pragma mark 进行点赞操作
- (void)doPraiseWithId:(NSInteger)postId WithPraise:(NSInteger)praise{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:postId] forKey:@"postId"];
    [dict setObject:@(1) forKey:@"operation"];
    if (praise == 0) {
        praise = 1;
    }else{
        praise = 0;
    }
    [dict setObject:[NSNumber numberWithInteger:praise] forKey:@"praise"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postStatusChange" object:dict];
}
#pragma mark 进行通知删除
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
    return _bannerArray.count;
}
//定义ScrollView
- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.cycleScrollView.bounds];
    if (_bannerArray.count == 0 || index >= _bannerArray.count) {
        return imageView;
    }
    ModelAdvert *advert = _bannerArray[index];
    [imageView setImageWithURL:[NSURL URLWithString:advert.cover] placeholder:[UIImage imageNamed:@"biu_activty_img_1"]];
    return imageView;
}

#pragma  delegate
- (void)didClickPage:(ZXCycleScrollView *)csView atIndex:(NSInteger)index
{
    ModelAdvert *modelAdvert = _bannerArray[index];
    AdvertDetailController *advertController = [AdvertDetailController shareControllerAdvertWithModel:modelAdvert];
    [advertController setHidesBottomBarWhenPushed:YES];
    if (self.delegate) {
        [((UIViewController *)self.delegate).navigationController pushViewController:advertController animated:YES];
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
