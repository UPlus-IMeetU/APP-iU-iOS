//
//  MatchPeopleView.m
//  IMeetU
//
//  Created by Spring on 16/5/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "MatchPeopleView.h"
#import "MatchPeopleCell.h"
#import "UserDefultAccount.h"
#import "XMUrlHttp.h"
#import <YYKit/YYKit.h>
#import "ModelResponse.h"
#import "UIScreen+plug.h"
#import "UIColor+plug.h"
#import "XMHttpBiuBiu.h"
#import "MJRefresh.h"
#import "MLCollectionViewWaterfallLayout.h"

#import "NSDate+plug.h"
#import "ModelUserListMatch.h"
static NSString * const kIdentifierCell = @"MatchPeopleCell";
@interface MatchPeopleView()<UICollectionViewDelegate,UICollectionViewDataSource,MLCollectionViewWaterfallLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *matchPeopleArray;
@property (nonatomic, strong) MLCollectionViewWaterfallLayout *waterfallLayout;
@property (nonatomic, assign) BOOL isCanLoading;

@end
@implementation MatchPeopleView

#pragma mark - 实例方法

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (NSMutableArray *)matchPeopleArray{
    if (!_matchPeopleArray) {
        _matchPeopleArray = [NSMutableArray array];
    }
    return _matchPeopleArray;
}

- (void)initDataWithTime:(long long)time withType:(RefreshType)refreshType{
    XMHttpBiuBiu *xmHttpBiuBiu = [XMHttpBiuBiu http];
    __weak typeof(self) weakSelf = self;
    [xmHttpBiuBiu loadMatchUserWithCount:20 timestamp:time callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        
        if (code == 200) {
            ModelUserListMatch *modelUserListMatch = [ModelUserListMatch modelWithJSON:response];
            _isCanLoading = modelUserListMatch.hasNext;
            //NSLog(@"*************_isCanLoading  = %@**************",_isCanLoading);
            if (refreshType == Refresh) {
                [weakSelf.matchPeopleArray removeAllObjects];
                weakSelf.matchPeopleArray = [NSMutableArray arrayWithArray:modelUserListMatch.users];
            }else{
                [weakSelf.matchPeopleArray addObjectsFromArray:modelUserListMatch.users];
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    }];
}


- (void)initUI{
    [self addSubview:self.collectionView];
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
#pragma mark - 点击进入对应的页面
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ModelBiuFaceStar *modelBiuFaceStar = [ModelBiuFaceStar modelWithModelUserMatch:self.matchPeopleArray[indexPath.row]];
    if (self.RecieveBiuBiuSelectBlock) {
        self.RecieveBiuBiuSelectBlock(modelBiuFaceStar);
    }
    return;
}

#pragma mark - get方法
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:self.waterfallLayout];
        [_collectionView registerNib:[UINib nibWithNibName:@"MatchPeopleCell" bundle:nil] forCellWithReuseIdentifier:kIdentifierCell];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithR:247 G:245 B:243 A:1];
        
       // 上拉刷新
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_collectionView.mj_header;
        header.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
        header.lastUpdatedTimeLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
        header.stateLabel.font = [UIFont systemFontOfSize:12];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
        //下拉加载
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loading)];
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_collectionView.mj_footer;
        footer.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _collectionView;
}

- (void)refresh{
    [self initDataWithTime:0 withType:Refresh];
}

- (void)loading{
    //取出最后一个
    if (_isCanLoading) {
        long long lastTime = ((ModelUserMatch *)[_matchPeopleArray lastObject]).timeSendBiu;
        [self initDataWithTime:lastTime withType:Loading];
    }else{
        [self.collectionView.mj_footer endRefreshing];
    }
}

-  (MLCollectionViewWaterfallLayout *)waterfallLayout{
    if (_waterfallLayout == nil) {
        _waterfallLayout = [[MLCollectionViewWaterfallLayout alloc] init];
        _waterfallLayout.columnCount = 2;
        _waterfallLayout.columnMargin = 10;
        _waterfallLayout.rowMargin = 10;
        _waterfallLayout.delegateLayout = self;
        _waterfallLayout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _waterfallLayout;
};

- (CGSize)cellContentSizeWithIndexPath:(NSIndexPath*)indexPath{
    ModelUserMatch *matchPeople = self.matchPeopleArray[indexPath.row];
    CGFloat width = [UIScreen screenWidth] / 2;
    CGFloat imageLength = width - 20;
    //计算文本的高度
    NSString *name = matchPeople.topic;
    NSDictionary *attrs = @{NSFontAttributeName :[UIFont systemFontOfSize:11]};
    CGSize fontSize = [name boundingRectWithSize:CGSizeMake(imageLength,10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return CGSizeMake(width,8 + imageLength + 20 + ceil(fontSize.height) + 8);
}

@end
