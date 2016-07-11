//
//  ControllerSamePostList.m
//  IMeetU
//
//  Created by Spring on 16/5/31.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerSamePostList.h"
#import "MJRefresh.h"
#import "UIColor+Plug.h"
#import "UINib+Plug.h"
#import "UIView+Plug.h"
#import "UIViewAdditions.h"

#import "XMHttpCommunity.h"
#import "ModelCommunity.h"
#import "PostListCell.h"
#import "ControllerReply.h"
#import "YYKit/YYKit.h"
#import "UIStoryboard+Plug.h"
#import "MLToast.h"
#import "XmNetworkErr.h"
#import "ControllerMineMain.h"
#import "ControllerPostRelease.h"
#import "ModelTag.h"

#import "MJIUHeader.h"

@interface ControllerSamePostList ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *postListTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign,nonatomic) BOOL isHasNext;
@property (assign,nonatomic) long long lastTime;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (nonatomic,strong) XMNetworkErr *xmNetworkErr;
@property (weak, nonatomic) IBOutlet UIButton *releaseButton;

/**
 *  帖子
 */
@property (nonatomic,strong) NSMutableArray *postListArray;
@end

@implementation ControllerSamePostList

+ (instancetype)controllerSamePostList{
    static ControllerSamePostList *controller;
        controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerSamePostList"];
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self preapreData];
    [self prepareUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postStatusChange:) name:@"postStatusChange" object:nil];
    // Do any additional setup after loading the view.
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
        NSInteger praise = [[dict objectForKey:@"praise"] integerValue];
        if (praise == 1) {
            //没有赞
            ((ModelPost *)_postListArray[index]).isPraise = 0;
            ((ModelPost *)_postListArray[index]).praiseNum --;
        }else{
            ((ModelPost *)_postListArray[index]).isPraise = 1;
            ((ModelPost *)_postListArray[index]).praiseNum ++;
        }
        [_postListTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
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

- (void)preapreData{
    _postListArray = [NSMutableArray array];
    [self loadDataWithTime:0 withType:Refresh];
}

- (void)loadDataWithTime:(long long)time withType:(RefreshType)refreshType{
    __weak typeof (self) weakSelf = self;
    if (!_isMyPostList) {
        [[XMHttpCommunity http] getPostListWithId:_tagId withTimeStamp:time withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                ModelCommunity *community = [ModelCommunity modelWithJSON:response];
                _lastTime = community.time;
                _isHasNext = community.hasNext;
                if (refreshType == Refresh) {
                    [weakSelf.postListArray removeAllObjects];
                    weakSelf.postListArray = [NSMutableArray arrayWithArray:community.postList];
                }else{
                    [weakSelf.postListArray addObjectsFromArray:community.postList];
                }
                [weakSelf.postListTableView reloadData];
                [weakSelf.postListTableView.mj_header endRefreshing];
                [weakSelf.postListTableView.mj_footer endRefreshing];
            }
        }];
    }else{
        [[XMHttpCommunity http] getMyPostListWithTime:time withUserCode:_userCode withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                [_xmNetworkErr destroyView];
                ModelCommunity *community = [ModelCommunity modelWithJSON:response];
                _lastTime = community.time;
                _isHasNext = community.hasNext;
                if (refreshType == Refresh) {
                    [weakSelf.postListArray removeAllObjects];
                    weakSelf.postListArray = [NSMutableArray arrayWithArray:community.postList];
                }else{
                    [weakSelf.postListArray addObjectsFromArray:community.postList];
                }
                [weakSelf.postListTableView reloadData];
                [weakSelf.postListTableView.mj_header endRefreshing];
                [weakSelf.postListTableView.mj_footer endRefreshing];
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
}
- (void)prepareUI{
    _postListTableView.delegate = self;
    _postListTableView.dataSource = self;
    _postListTableView.backgroundColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:0.5];
     __weak typeof (self) weakSelf = self;
    _postListTableView.mj_header = [MJIUHeader  headerWithRefreshingBlock:^{
        [weakSelf loadDataWithTime:0 withType:Refresh];
    }];
     [((MJIUHeader *)_postListTableView.mj_header) initGit];
    _postListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_isHasNext) {
            [weakSelf loadDataWithTime:_lastTime withType:Loading];
        }else{
            [weakSelf.postListTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)_postListTableView.mj_footer;
    footer.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    //设置为没有颜色
    _postListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //进行列表的注册
    [_postListTableView registerNib:[UINib xmNibFromMainBundleWithName:@"PostListCell"] forCellReuseIdentifier:@"PostListCell"];
    
    _titleLabel.text = self.titleName;
    if (self.isMyPostList) {
        _releaseButton.hidden = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    postListCell.postViewGoHomePageBlock  = ^(NSInteger userCode){
        [weakSelf goHomePage:userCode];
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
    if (_postListArray.count == 0 && _isMyPostList) {
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
    controllerReply.notGoSameList = YES;
    [self.navigationController pushViewController:controllerReply  animated:YES];
}

- (void)operationBtnClickWithPostId:(NSInteger) postId withOperationType:(OperationType)operationType withUserCode:(NSInteger)userCode{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *operationStr = (operationType == OperationTypeDelete) ? @"删除":@"举报";
    NSString *messageStr = (operationType == OperationTypeDelete) ?@"嗨，确定要删除内容么?":@"嗨，确定要举报TA么?";
    __weak typeof (self) weakSelf = self;
    [controller addAction:[UIAlertAction actionWithTitle:operationStr style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //弹出框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:operationStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (operationType == OperationTypeDelete) {
                [weakSelf deletePostWithId:postId];
            }else{
                [weakSelf reportPostWithId:postId withUserCode:userCode];
            }
        }]];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
        [self presentViewController:controller animated:YES completion:nil];
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
            [MLToast toastInView:self.view content:@"点赞失败了>_<"];
        }
    }];
    
}



#pragma mark
- (void)goHomePage:(NSInteger)userCode{
    ControllerMineMain *mineMain = [ControllerMineMain controllerWithUserCode:[NSString stringWithFormat:@"%ld",(long)userCode] getUserCodeFrom:MineMainGetUserCodeFromParam];
    [self.navigationController pushViewController:mineMain animated:YES];
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onClickBtnPostRelease:(id)sender {
    
    ControllerPostRelease *controller = [ControllerPostRelease controller];
    ModelTag *modelTag = [ModelTag new];
    modelTag.tagId = self.tagId;
    modelTag.content = self.titleName;
    controller.tagModel = modelTag;
    controller.postReleaseSuccessBlock = ^(BOOL success){
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    self.tabBarController.tabBar.hidden = YES;

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
