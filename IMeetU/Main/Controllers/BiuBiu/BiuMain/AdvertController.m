//
//  AdvertController.m
//  IMeetU
//
//  Created by Spring on 16/5/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "AdvertController.h"
#import "AdvertCell.h"
#import "AdvertDetailController.h"
#import "AFHTTPSessionManager.h"
#import "XMUrlHttp.h"
#import "YYKit/YYKit.h"
#import "ModelResponse.h"
#import "ModelAdvert.h"
#import "ModelActivity.h"
#import "UserDefultAccount.h"
#define CellIdentifier @"AdvertCell"
#import "MobClick.h"
@interface AdvertController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *activityArray;
@end

@implementation AdvertController

- (void)viewDidLoad {
    //活动列表页面，进入次数
    [MobClick event:@"acty_list_into"];
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self prepareData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)prepareData{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [httpManager POST:[XMUrlHttp xmGetActivity] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            ModelActivity *modelActivity = [ModelActivity modelWithJSON:response.data[@"activity"]];
            self.activityArray = modelActivity.actys;
                //ModelActivity *modelActivitys = [ModelActivity modelWithJSON:response.data];
            [self.tableView reloadData];
            
            //正常加载数据
            [UserDefultAccount setHaveToView:1];
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activityArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //活动列表页面，活动打开总次数
    [MobClick event:@"acty_list_open_total"];
    AdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // 设置选中的风格
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ModelAdvert *modelAdvert = self.activityArray[indexPath.row];
    [cell.advertImageView setImageWithURL:[NSURL URLWithString:modelAdvert.cover] placeholder:[UIImage imageNamed:@"biu_activty_img_1"]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelAdvert *modelAdvert = self.activityArray[indexPath.row];
    AdvertDetailController *advertController = [AdvertDetailController shareControllerAdvertWithModel:modelAdvert];
    
    [advertController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:advertController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138.0f;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

@end
