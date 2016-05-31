//
//  ControllerReply.m
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerReply.h"
#import "UIStoryboard+Plug.h"
#import "UIColor+Plug.h"
#import "UINib+Plug.h"
#import "MBProgressHUD+plug.h"
#import "XMHttpCommunity.h"


#import "MJRefresh.h"
#import "MBProgressHUD.h"

#import "CommunityReplyCell.h"
#import "ModelPostDetail.h"
#import "YYKit/YYKit.h"
#import "PostListCell.h"
@interface ControllerReply ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  评论列表
 */
@property (weak, nonatomic) IBOutlet UITableView *replyTableView;
@property (strong,nonatomic) NSMutableArray *commentArray;

@end

@implementation ControllerReply

+ (instancetype)shareControllerReply{
    static ControllerReply *controller;
    controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerReply"];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self prepareUI];
    // Do any additional setup after loading the view.
}

- (void)prepareData{
    _commentArray = [NSMutableArray array];
    [[XMHttpCommunity http] loadPostDetailWithPostId:self.postId withTimeStamp:0 withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            ModelPostDetail *modelPostDetail = [ModelPostDetail modelWithJSON:response];
            
            //创建视图
            PostListCell *postCell =  [[[NSBundle mainBundle] loadNibNamed:@"PostListCell" owner:self options:nil] lastObject];
            postCell.size = CGSizeMake(self.view.width, [ModelPost cellHeightWith:modelPostDetail.post]);
            postCell.modelPost = modelPostDetail.post;
            _commentArray = [NSMutableArray arrayWithArray:modelPostDetail.commentList];
            _replyTableView.tableHeaderView = postCell;
            [_replyTableView reloadData];
        };
    }];
}
- (void)prepareUI{
    _replyTableView.showsVerticalScrollIndicator = NO;
    _replyTableView.showsHorizontalScrollIndicator = NO;
    // 上拉刷新和下拉加载
    _replyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ _replyTableView.mj_header endRefreshing];
    }];
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_replyTableView.mj_header;
    header.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
    header.lastUpdatedTimeLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    
    _replyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ _replyTableView.mj_footer endRefreshing];
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_replyTableView.mj_footer;
    footer.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    //设置为没有颜色
    _replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //进行列表的注册
    [_replyTableView registerNib:[UINib xmNibFromMainBundleWithName:@"CommunityReplyCell"] forCellReuseIdentifier:@"CommunityReplyCell"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityReplyCell *replyCell = [tableView dequeueReusableCellWithIdentifier:@"CommunityReplyCell"];
    replyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //进行删除或者举报操作
    typeof(self) weakSelf = self;
    replyCell.replyOperationBlock = ^(NSInteger postId,OperationReplyType operationType){
        [weakSelf operationBtnClickWithPostId:postId withOperationType:operationType];
    };
    return replyCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentArray.count;
}

/**
 *  返回按钮
 */
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        [self presentViewController:alertController animated:YES completion:nil];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}
/**
 *  进行删除操作
 *
 *  @param postId 删除的postId
 */
- (void)deletePostWithId:(NSInteger)postId{
    MBProgressHUD *hud = [MBProgressHUD xmShowHUDAddedTo:self.view animated:YES];
    hud.labelText = @"删除成功了";
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
}

/**
 *  进行举报操作
 *
 *  @param postId 举报的postId
 */
- (void)reportPostWithId:(NSInteger)postId{
    MBProgressHUD *hud = [MBProgressHUD xmShowHUDAddedTo:self.view animated:YES];
    hud.labelText = @"举报成功了";
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
    
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
