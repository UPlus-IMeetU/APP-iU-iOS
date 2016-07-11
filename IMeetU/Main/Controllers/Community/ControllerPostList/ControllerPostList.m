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
#import "MLToast.h"


#import "XMHttpCommunity.h"
#import "ModelCommunity.h"
#import "ModelAdvert.h"
#import "AdvertDetailController.h"
#import "YYKit/YYKit.h"
#import "ControllerSamePostList.h"
#import "ControllerMineMain.h"
#import "UserDefultAccount.h"

#import "MJIUHeader.h"
#import "XMNetworkErr.h"
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
@property (nonatomic,assign) long long lastTime;
@property (nonatomic,assign) BOOL isHasNext;
@property (nonatomic,strong) UILabel *emptyLabel;
@property (nonatomic,strong) XMNetworkErr *xmNetworkErr;
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


- (void)refreshView{
    if (_postListArray.count == 0) {
        [self loadDataWithTime:0 withType:Refresh];
    }
}

- (void)updateView{
    [self loadDataWithTime:0 withType:Refresh];
}

- (void)postStatusChange:(NSNotification *)noti{
    NSDictionary *dict = noti.object;
    __weak typeof (self) weakSelf = self;
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
        [_postListTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }else if([[dict objectForKey:@"operation"] integerValue] == 1){
        NSInteger praise = [[dict objectForKey:@"praise"] integerValue];
        if (praise == 1) {
            //没有赞
            ((ModelPost *)_postListArray[index]).isPraise = 0;
            ((ModelPost *)_postListArray[index]).praiseNum --;
        }else{
            ((ModelPost *)_postListArray[index]).isPraise = 1;
            ((ModelPost *)_postListArray[index]).praiseNum ++;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.postListTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        });
        }else if([[dict objectForKey:@"operation"] integerValue] == 2){
        NSInteger isDelete = [[dict objectForKey:@"delete"] integerValue];
        if (isDelete == 1) {
            //没有赞
            ((ModelPost *)_postListArray[index]).commentNum --;
        }else{
            ((ModelPost *)_postListArray[index]).commentNum ++;
        }
        [_postListTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)prepareData{
    _lastTime = 0;
    _postListArray = [NSMutableArray array];
    _bannerArray = [NSMutableArray array];
    //进行处理
    [self loadDataWithTime:_lastTime withType:Refresh];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
}

- (void)loadDataWithTime:(long long)time withType:(RefreshType)refreshType{
    //请求数据的时候，先关闭轮播视图
    [_cycleScrollView.timer setFireDate:[NSDate distantFuture]];
    __weak typeof (self) weakSelf = self;
    [[XMHttpCommunity http] loadCommunityListWithType:self.postListType withTimeStamp:time withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        [_postListTableView.mj_footer endRefreshing];
        [_postListTableView.mj_header endRefreshing];

        if (code == 200) {
            [_xmNetworkErr destroyView];
            ModelCommunity *community = [ModelCommunity modelWithJSON:response];
            //获取最后时间
            weakSelf.lastTime = community.time;
            weakSelf.isHasNext = community.hasNext;
            if (refreshType == Refresh) {
                [weakSelf.postListArray removeAllObjects];
                [weakSelf.bannerArray removeAllObjects];
                weakSelf.postListArray = [NSMutableArray arrayWithArray:community.postList];
                weakSelf.bannerArray = [NSMutableArray arrayWithArray:community.banner];
                if (weakSelf.bannerArray.count != 0) {
                    weakSelf.postListTableView.tableHeaderView = weakSelf.cycleScrollView;
                }
            }else{
                [_postListArray addObjectsFromArray:community.postList];
            }
            [_postListTableView reloadData];
            [_cycleScrollView reloadData];
        }else if(code == -1 && _postListArray.count == 0){
            if (!_xmNetworkErr) {
                _xmNetworkErr = [[XMNetworkErr viewWithSuperView:self.view y:80 titles:@[@"呜呜，内容加载失败了",@"点击重新加载"] callback:^(XMNetworkErr *view) {
                    [weakSelf loadDataWithTime:0 withType:Refresh];
                }] showView];
                _emptyLabel.hidden = YES;
            }
        }
   }];
}
- (void)prepareUI{
     [self.view addSubview:self.postListTableView];
    self.postListTableView.backgroundColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:0.5];
    _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, self.view.width, 20)];
    _emptyLabel.font = [UIFont systemFontOfSize:13];
    _emptyLabel.textColor = [UIColor often_999999:1];
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
     [self.view addSubview:_emptyLabel];
     if (self.postListType == PostListTypeBiuBiu) {
        _emptyLabel.text = @"biubiu好友的内容动态会呈现在这里哦";
     }else if(self.postListType == PostListTypeRecommend){
        _emptyLabel.text = @"iU推荐的内容动态会呈现在这里哦";
     }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)postListTableView{
    if (!_postListTableView) {
        _postListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 49)];
        _postListTableView.contentInset = UIEdgeInsetsMake(36, 0, 0, 0);
        _postListTableView.delegate = self;
        _postListTableView.dataSource = self;
        _postListTableView.showsVerticalScrollIndicator = NO;
        _postListTableView.showsHorizontalScrollIndicator = NO;
        _postListTableView.backgroundColor = [UIColor often_A0A0A0:1];
        // 上拉刷新和下拉加载
        __weak typeof (self) weakSelf = self;
        _postListTableView.mj_header = [MJIUHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataWithTime:0 withType:Refresh];
        }];
        [((MJIUHeader *)_postListTableView.mj_header) initGit];
        _postListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (_isHasNext) {
                [weakSelf loadDataWithTime:_lastTime withType:Loading];
            }else{
                [_postListTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)_postListTableView.mj_footer;
        footer.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        //设置为没有颜色
        _postListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        [_cycleScrollView changePageControlColor:[UIColor colorWithRed:245/255.0 green:244.0/255.0 blue:145.0/255.0 alpha:1]:[UIColor whiteColor]];
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
    postListCell.postViewOperationBlock = ^(NSInteger postId,OperationType operationType,NSInteger userCode){
        [weakSelf operationBtnClickWithPostId:postId withOperationType:operationType withUserCode:userCode];
    };
    
    postListCell.postViewPraiseBlock = ^(NSInteger postId,NSInteger userCode,NSInteger praise){
        [weakSelf doPraiseWithId:postId withUserCode:userCode withPraise:praise];
    };
    postListCell.postViewGoSameTagListBlock = ^(ModelTag *modelTag){
        [weakSelf gotoTagListWithTag:modelTag];
    };
    
    postListCell.postViewGoHomePageBlock = ^(NSInteger userCode){
        [weakSelf gotoHomePage:userCode];
    };
    
    postListCell.postViewCreateCommentBlock  = ^(NSInteger postId){
        if(weakSelf.delegate){
            ControllerReply *controllerReply = [ControllerReply shareControllerReply];
            controllerReply.postId = postId;
            [((UIViewController *)weakSelf.delegate).navigationController pushViewController:controllerReply animated:YES];  
        }
    };
    postListCell.width = self.view.width;
    postListCell.modelPost = _postListArray[indexPath.row];
    return postListCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //计算cell的高度
    ModelPost *modelPost = self.postListArray[indexPath.row];
    return [ModelPost cellHeightWith:modelPost];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_postListArray.count == 0) {
        _emptyLabel.hidden = NO;
    }else{
        _emptyLabel.hidden = YES;
    }
    return _postListArray.count;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ControllerReply *controllerReply = [ControllerReply shareControllerReply];
    ModelPost *modelPost = _postListArray[indexPath.row];
    controllerReply.postId = modelPost.postId;
    if(self.delegate){
        [((UIViewController *)self.delegate).navigationController pushViewController:controllerReply animated:YES];
    }
    
}

- (void)operationBtnClickWithPostId:(NSInteger) postId withOperationType:(OperationType)operationType withUserCode:(NSInteger) userCode{
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
                [self reportPostWithId:postId withUserCode:userCode];
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
    [[XMHttpCommunity http] deletePostWithId:postId withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInteger:postId] forKey:@"postId"];
            [dict setObject:@(0) forKey:@"operation"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postStatusChange" object:dict];
        }else{
            [[MLToast toastInView:self.view content:@"删除失败了>_<"] show];
        }
        
    }];
}

#pragma mark 举报操作
- (void)reportPostWithId:(NSInteger)postId withUserCode:(NSInteger) userCode{
    [[XMHttpCommunity http] createReportWithPostId:postId withCommentId:-1 withUserCode:userCode withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            [[MLToast toastInView:self.view content:@"举报成功了"] show];
        }else{
            [[MLToast toastInView:self.view content:@"举报失败了"] show];
        }
    }];
}
#pragma mark 进行点赞操作
- (void)doPraiseWithId:(NSInteger)postId withUserCode:(NSInteger) userCode withPraise:(NSInteger)praise{
    [[XMHttpCommunity http] praisePostWithId:postId withUserCode:userCode withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInteger:postId] forKey:@"postId"];
            [dict setObject:@(1) forKey:@"operation"];
            [dict setObject:[NSNumber numberWithInteger:praise] forKey:@"praise"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postStatusChange" object:dict];
        }else{
            [[MLToast toastInView:self.view content:@"点赞失败了>_<"] show];
            
        }
    }];
    
}
#pragma mark 进入个人主页
- (void)gotoHomePage:(NSInteger)userCode{
    ControllerMineMain *mainMain = [ControllerMineMain controllerWithUserCode:[NSString stringWithFormat:@"%ld",(long)userCode] getUserCodeFrom:MineMainGetUserCodeFromParam];
    [((UIViewController *)self.delegate).navigationController pushViewController:mainMain animated:YES];
}
#pragma mark 进入相同的列表
- (void)gotoTagListWithTag:(ModelTag *)modelTag{
    ControllerSamePostList *samePostList = [ControllerSamePostList controllerSamePostList];
    samePostList.titleName = modelTag.content;
    samePostList.tagId = modelTag.tagId;
    [((UIViewController *)self.delegate).navigationController pushViewController:samePostList animated:YES];
}
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    contentOffsetY = scrollView.contentOffset.y;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     if (scrollView.dragging) {  // 拖拽
        if ((scrollView.contentOffset.y - contentOffsetY) > 15.0f && _postListArray.count != 0) {  // 向上拖拽
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(hideTitleView:)]) {
                    [self.delegate hideTitleView:YES];
                }
            }
            contentOffsetY = scrollView.contentOffset.y;
        } else if ((contentOffsetY - scrollView.contentOffset.y) > 15.0f) {
            // 向下拖拽
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(hideTitleView:)]) {
                    [self.delegate hideTitleView:NO];
                }
            }
            contentOffsetY = scrollView.contentOffset.y;
        } else {
            
        }
    }
    
    if (scrollView.contentOffset.y == - 36) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(hideTitleView:)]) {
                [self.delegate hideTitleView:NO];
            }
        }
    }
}

#pragma mark ZXCycleScrollViewDelegate,ZXCycleScrollViewDatasource
//返回滚动视图的个数
- (NSInteger)numberOfPages{
    if (_bannerArray.count == 1) {
        _cycleScrollView.pageControl.hidden = YES;
        _cycleScrollView.scrollView.scrollEnabled = NO;
        [_cycleScrollView.timer setFireDate:[NSDate distantFuture]];
    }else{
        __weak typeof (self) weakSelf = self;
        _cycleScrollView.pageControl.hidden = NO;
        _cycleScrollView.scrollView.scrollEnabled = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [weakSelf.cycleScrollView.timer setFireDate:[NSDate distantPast]];
        });
    }
    return _bannerArray.count;
}

//定义ScrollView
- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.cycleScrollView.bounds];
    ModelAdvert *advert = _bannerArray[index];
    [imageView setImageWithURL:[NSURL URLWithString:advert.cover] placeholder:[UIImage imageNamed:@"banner_fail"]];
    return imageView;
}

#pragma  delegate
- (void)didClickPage:(ZXCycleScrollView *)csView atIndex:(NSInteger)index
{
    ModelAdvert *modelAdvert = _bannerArray[index];
    NSString *coverUrl = modelAdvert.url;
    //如果包含http跳转页面
    if ([coverUrl containsString:@"http"]) {
        AdvertDetailController *advertController = [AdvertDetailController shareControllerAdvertWithModel:modelAdvert];
        [advertController setHidesBottomBarWhenPushed:YES];
        if (self.delegate) {
            [((UIViewController *)self.delegate).navigationController pushViewController:advertController animated:YES];
        }
    }else{
        ControllerSamePostList *samePostListController = [ControllerSamePostList controllerSamePostList];
        NSArray *array = [coverUrl componentsSeparatedByString:@","];
        samePostListController.tagId = [[array firstObject] intValue];
        samePostListController.titleName = [array lastObject];
        [samePostListController setHidesBottomBarWhenPushed:YES];
        if (self.delegate) {
            [((UIViewController *)self.delegate).navigationController pushViewController:samePostListController animated:YES];
        }
    }
  }
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
