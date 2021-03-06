//
//  ViewController.m
//  CollcetionViewLayout_demo
//
//  Created by baiqiang on 16/2/24.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

#import "MatchPeopleController.h"
#import "BQWaterLayout.h"
#import "MatchPeopleCell.h"
#import "UserDefultAccount.h"
#import "XMUrlHttp.h"
#import <YYKit/YYKit.h>
#import "ModelResponse.h"
#import "UIScreen+plug.h"
#import "UIColor+plug.h"

#import "XMHttpBiuBiu.h"


#import "ModelUserListMatch.h"


static NSString * const kIdentifierCell = @"MatchPeopleCell";

@interface MatchPeopleController () <UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BQWaterLayout *waterLayout;
@property (nonatomic, strong) NSMutableArray *matchPeopleArray;
@end

@implementation MatchPeopleController

#pragma mark - 类方法

#pragma mark - 创建方法

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}
#pragma mark - 实例方法
- (void)initData{
    self.matchPeopleArray = [NSMutableArray array];
    XMHttpBiuBiu *xmHttpBiuBiu = [[XMHttpBiuBiu alloc] init];
    [xmHttpBiuBiu loadMatchUserWithCount:20 timestamp:@"" callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            ModelUserListMatch *modelUserListMatch = [ModelUserListMatch modelWithJSON:[response objectForKey:@"data"]];
            self.matchPeopleArray = [[NSMutableArray alloc] initWithArray:modelUserListMatch.users];
            [self.collectionView reloadData];
        }
    }];
}


- (void)initUI{
    [self.view addSubview:self.collectionView];
}

#pragma mark - 事件响应方法

#pragma mark - UICollectionViewDataSource Method
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.matchPeopleArray.count;
    //return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MatchPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierCell forIndexPath:indexPath];
    cell.matchPeople = self.matchPeopleArray[indexPath.row];
    return cell;
}
#pragma mark - set方法

#pragma mark - get方法
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:self.waterLayout];
        [_collectionView registerNib:[UINib nibWithNibName:@"MatchPeopleCell" bundle:nil] forCellWithReuseIdentifier:kIdentifierCell];
        _collectionView.dataSource = self;
         _collectionView.backgroundColor = [UIColor colorWithR:247 G:245 B:243 A:1];
    }
    return _collectionView;
}
- (BQWaterLayout *)waterLayout {
    if (_waterLayout == nil) {
        //layout内部有设置默认属性
        _waterLayout = [[BQWaterLayout alloc] init];
        _waterLayout.lineNumber = 2;
        //计算每个item高度方法，必须实现（也可以设计为代理实现）
        __weak typeof(self) weakSelf = self;
        [_waterLayout computeIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexPath, CGFloat width) {
            ModelUserMatch *matchPeople = weakSelf.matchPeopleArray[indexPath.row];
            CGFloat imageLength = width - 20;
            //计算文本的高度
            NSLog(@"*************%@************",matchPeople.topic);
            NSString *name = matchPeople.topic;
            NSDictionary *attrs = @{NSFontAttributeName :[UIFont systemFontOfSize:11]};
            CGSize fontSize = [name boundingRectWithSize:CGSizeMake(imageLength,10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            return 8 + imageLength + 12 + ceil(fontSize.height) + 8;
        }];
        //内间距
        _waterLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _waterLayout;
}

@end
