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


#import "MJRefresh.h"
#import "CommunityReplyCell.h"
@interface ControllerReply ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  评论列表
 */
@property (weak, nonatomic) IBOutlet UITableView *replyTableView;

@end

@implementation ControllerReply

+ (instancetype)shareControllerReply{
    static ControllerReply *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerReply"];
    });
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    // Do any additional setup after loading the view.
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
    return replyCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

/**
 *  返回按钮
 */
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
