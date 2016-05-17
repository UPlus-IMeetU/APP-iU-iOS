//
//  ControllerMineAlterInterest.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerMineAlterInterest.h"
#import "UINib+Plug.h"
#import "UIColor+Plug.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"

#import "CellCollectionMineAlterInterest.h"
#import "CellTableViewMineAlterInterest.h"
#import "ReusableViewMineAlterInterestHeader.h"
#import "ReusableViewMineAlterInterestFooter.h"

#import "ModelInterest.h"
#import "ModelInterests.h"

#import <YYKit/YYKit.h>
#import "AFNetworking.h"
#import "XMUrlHttp.h"
#import "UserDefultAccount.h"

#import "ModelResponse.h"
#import "ModelMineAlterInterestAll.h"
#import "ModelMineAlterInterestSection.h"
#import "ModelMineAlterInterest.h"

#import "MLToast.h"

#define CellCollectionMineAlterInterestReuseIdentifier @"CellCollectionMineAlterInterest"
#define ReusableViewMineAlterInterestHeaderIdentifier @"ReusableViewMineAlterInterestHeader"
#define ReusableViewMineAlterInterestFooterIdentifier @"ReusableViewMineAlterInterestFooter"

#define CellTableViewMineAlterInterestReuseIdentifier @"CellTableViewMineAlterInterest"
#define CellTableViewMineAlterInterestFooterReuseIdentifier @"CellTableViewMineAlterInterestFooter"

@interface ControllerMineAlterInterest ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *selectedInterests;
@property (nonatomic, strong) ModelMineAlterInterestAll *modelInterestAll;

/**
 *  此线主要用于当tableview上拉超过底部时，配合tableview上的线，当tableview下拉超过顶部时需要隐藏
 */
@property (weak, nonatomic) IBOutlet UIView *viewLineTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewInterests;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEdge;

@end

@implementation ControllerMineAlterInterest

+ (instancetype)controllerWithInterests:(NSArray*)interests{
    ControllerMineAlterInterest *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameMine indentity:@"ControllerMineAlterInterest"];
    controller.selectedInterests = interests;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"type":@"interest"};
    [httpManager POST:[XMUrlHttp xmAllCharactersInterestChat] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            self.modelInterestAll = [ModelMineAlterInterestAll modelWithJSON:response.data];
            [self.collectionViewInterests reloadData];
            
            for (ModelMineAlterInterestSection *mSection in self.modelInterestAll.interestAll) {
                for (ModelMineAlterInterest *mi in mSection.interests) {
                    for (ModelMineAlterInterest *mis in self.selectedInterests) {
                        if ([mis.interestCode isEqualToString:mi.interestCode]) {
                            mi.selected = YES;
                        }
                    }
                }
            }
            
            
            [self.tableViewEdge reloadData];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [self.collectionViewInterests registerNib:[UINib xmNibFromMainBundleWithName:CellCollectionMineAlterInterestReuseIdentifier] forCellWithReuseIdentifier:CellCollectionMineAlterInterestReuseIdentifier];
    [self.collectionViewInterests registerNib:[UINib xmNibFromMainBundleWithName:ReusableViewMineAlterInterestHeaderIdentifier] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewMineAlterInterestHeaderIdentifier];
    [self.collectionViewInterests registerNib:[UINib xmNibFromMainBundleWithName:ReusableViewMineAlterInterestFooterIdentifier] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewMineAlterInterestFooterIdentifier];
    self.collectionViewInterests.backgroundColor = [UIColor colorWithR:248 G:246 B:244];
    self.collectionViewInterests.collectionViewLayout = layout;
    self.collectionViewInterests.dataSource = self;
    self.collectionViewInterests.delegate = self;
    
    [self.tableViewEdge registerNib:[UINib xmNibFromMainBundleWithName:CellTableViewMineAlterInterestReuseIdentifier] forCellReuseIdentifier:CellTableViewMineAlterInterestReuseIdentifier];
    [self.tableViewEdge registerNib:[UINib xmNibFromMainBundleWithName:CellTableViewMineAlterInterestFooterReuseIdentifier] forCellReuseIdentifier:CellTableViewMineAlterInterestFooterReuseIdentifier];
    self.tableViewEdge.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewEdge.backgroundColor = [UIColor clearColor];
    self.tableViewEdge.dataSource = self;
    self.tableViewEdge.delegate = self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.modelInterestAll.numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.modelInterestAll numberOfItemsInSection:section];
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        ReusableViewMineAlterInterestHeader *reusableViewHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ReusableViewMineAlterInterestHeaderIdentifier forIndexPath:indexPath];
        [reusableViewHeader initWithTitle:[self.modelInterestAll titleOfHeaderInSection:indexPath.section]];
        reusableView = reusableViewHeader;
    }else if (kind == UICollectionElementKindSectionFooter){
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ReusableViewMineAlterInterestFooterIdentifier forIndexPath:indexPath];
    }
    
    return reusableView;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellCollectionMineAlterInterest *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellCollectionMineAlterInterestReuseIdentifier forIndexPath:indexPath];
    [cell initWithModelInterest:[self.modelInterestAll modelInterestForCellAtIndexPath:indexPath] sectionTitle:[self.modelInterestAll titleOfHeaderInSection:indexPath.section]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake([UIScreen screenWidth], 72);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (self.modelInterestAll.numberOfSections -1 == section) {
        return CGSizeMake([UIScreen screenWidth], 100);
    }
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 11, 0, 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 13;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.modelInterestAll onSelectedOfIndexPath:indexPath];
    
    [self.collectionViewInterests reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelInterestAll.numberOfSections+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.modelInterestAll heightTableViewOfRow:indexPath.row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.collectionViewInterests.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    self.tableViewEdge.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    
    self.viewLineTableView.hidden = (scrollView.contentOffset.y<0);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        
    }else if (indexPath.row>0 && indexPath.row<self.modelInterestAll.numberOfSections+1){
        CellTableViewMineAlterInterest *cellTableView = [tableView dequeueReusableCellWithIdentifier:CellTableViewMineAlterInterestReuseIdentifier forIndexPath:indexPath];
        [cellTableView initWithPointImg:[self.modelInterestAll pointImgOfSection:indexPath.row-1]];
        cell = cellTableView;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableViewMineAlterInterestFooterReuseIdentifier forIndexPath:indexPath];
    }
    cell.backgroundColor = [UIColor colorWithR:248 G:246 B:244];
    return cell;
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnFinish:(id)sender {
    if (self.modelInterestAll.selected.count > 0){
    if (self.delegateAlterInterest) {
        if ([self.delegateAlterInterest respondsToSelector:@selector(controllerMineAlterInterest:selecteds:)]) {
            [self.delegateAlterInterest controllerMineAlterInterest:self selecteds:self.modelInterestAll.selected];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    }else{
        [[MLToast toastInView:self.view content:@"请选择兴趣标签"] show];
    }
}
@end
