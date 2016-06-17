//
//  CellMineMainProfileAndPhotos.m
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellMineMainProfileAndPhotos.h"
#import "ModelUser.h"

#import "UINib+Plug.h"
#import "XMNibStoryboardFilesName.h"

#import "CellMineMainCollectionPhoto.h"
#import "ModelResponseMine.h"
#import <YYKit/YYKit.h>

#import "ModelMinePhoto.h"
#import "NSDate+plug.h"
#import "UIColor+Plug.h"

#import "UserDefultAccount.h"


@interface CellMineMainProfileAndPhotos()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) ModelResponseMine *mineInfo;

@property (weak, nonatomic) IBOutlet UIButton *btnUserProfile;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;
@property (weak, nonatomic) IBOutlet UILabel *labelNameNick;

@property (weak, nonatomic) IBOutlet UIView *viewHisInfo;
@property (weak, nonatomic) IBOutlet UIView *viewMyInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelMatchScore;
@property (weak, nonatomic) IBOutlet UILabel *labelActyTime;

@property (weak, nonatomic) IBOutlet UIView *viewProfileStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelProfileStatus;

@property (weak, nonatomic) IBOutlet UIView *viewPhotosWrap;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPhotos;
@property (weak, nonatomic) IBOutlet UILabel *labelPhotosEmpty;

@property (weak, nonatomic) IBOutlet UIButton *btnUserIdentifier;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnBuyUmi;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayNumLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCollectionPhotoLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelPhotosEmptyLeft;

@end
@implementation CellMineMainProfileAndPhotos


- (void)initWithMine:(ModelResponseMine *)mine isMine:(BOOL)isMine isShowBtnBack:(BOOL)isShowBtnBack{
    self.mineInfo = mine;
    
    self.btnAddPhotos.hidden = !isMine;
    
    if (isMine) {
        self.constraintCollectionPhotoLeft.constant = 90;
        self.constraintLabelPhotosEmptyLeft.constant = 80;
    }else{
        self.constraintCollectionPhotoLeft.constant = 10;
        self.constraintLabelPhotosEmptyLeft.constant = 0;
    }
    
    self.btnUserIdentifier.hidden = !mine.userIdentifier;
    if (mine.userIdentifier == 1) {
        [self.btnUserIdentifier setBackgroundImage:[UIImage imageNamed:@"global_special_user_icon_pink"] forState:UIControlStateNormal];
    }else if (mine.userIdentifier == 2){
        [self.btnUserIdentifier setBackgroundImage:[UIImage imageNamed:@"global_special_user_icon_yellow"] forState:UIControlStateNormal];
    }else if (mine.userIdentifier == 3){
        [self.btnUserIdentifier setBackgroundImage:[UIImage imageNamed:@"global_special_user_icon_blue"] forState:UIControlStateNormal];
    }
    
    self.labelPhotosEmpty.hidden = (mine.photos.count > 0);
    self.collectionViewPhotos.hidden = !(mine.photos.count > 0);
    
    [self.viewPhotosWrap layoutIfNeeded];
    [self.collectionViewPhotos reloadData];
    
    [self.labelNameNick setText:self.mineInfo.nameNick];
    [self.btnUserProfile setBackgroundImageWithURL:[NSURL URLWithString:self.mineInfo.profileCircle] forState:UIControlStateNormal options:YYWebImageOptionAllowBackgroundTask];
    
    self.viewHisInfo.hidden = isMine;
    if (!isMine) {
        if (mine.distanceToTA<1000) {
            self.labelDistance.text = [NSString stringWithFormat:@"%lum", (long)mine.distanceToTA];
        }else{
            self.labelDistance.text = [NSString stringWithFormat:@"%.1fkm", mine.distanceToTA/1000.0];
        }
        self.labelMatchScore.text = [NSString stringWithFormat:@"%lu%%", (long)mine.matchScore];
        NSInteger time = ([NSDate currentTimeMillis]-mine.actyTime)/1000/60;
        if (time<60) {
            self.labelActyTime.text = [NSString stringWithFormat:@"%lumin", (long)time];
        }else if (time>60 && time<60*24){
            self.labelActyTime.text = [NSString stringWithFormat:@"%ldh", time/60];
        }else{
            self.labelActyTime.text = [NSString stringWithFormat:@"%ld天", time/60/24];
        }
    }
    self.viewHisInfo.hidden = isMine;
    self.viewMyInfo.hidden = !isMine;
    if ([UserDefultAccount userProfileStatus] == 1) {
        self.viewProfileStatus.hidden = NO;
        self.labelProfileStatus.text = @"审核中";
    }else if ([UserDefultAccount userProfileStatus]  == 3){
        self.viewProfileStatus.hidden = YES;
    }else if ([UserDefultAccount userProfileStatus]  == 5){
        self.viewProfileStatus.hidden = NO;
        self.labelProfileStatus.text = @"未通过";
    }
    if (isMine) {
        NSString *todayNumStr;
        if (self.mineInfo.todayNum < 10000) {
            todayNumStr = [NSString stringWithFormat:@"%ld",(long)self.mineInfo.todayNum];
        }else{
            todayNumStr = [NSString stringWithFormat:@"%ldw+",(long)self.mineInfo.todayNum / 10000];
        }
        todayNumStr = [NSString stringWithFormat:@"今日访问:%@",todayNumStr];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:todayNumStr];
        //进行范围设置
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value: [UIColor often_FCFCC8:1]
                        range:NSMakeRange(0,4)];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value: [UIColor often_FFFFFF:1]
                        range:NSMakeRange(4,todayNumStr.length - 4)];
        _todayNumLabel.attributedText = attrStr;
        
        NSString *totalNumStr ;
        if (self.mineInfo.totalNum < 10000) {
            totalNumStr = [NSString stringWithFormat:@"%ld",(long)self.mineInfo.totalNum];
        }else{
            totalNumStr = [NSString stringWithFormat:@"%ldw+",(long)self.mineInfo.totalNum / 10000];
        }
        totalNumStr = [NSString stringWithFormat:@"总访问:%@",totalNumStr];
        attrStr = [[NSMutableAttributedString alloc] initWithString:totalNumStr];
        //进行范围设置
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value: [UIColor often_FCFCC8:1]
                        range:NSMakeRange(0,3)];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value: [UIColor often_FFFFFF:1]
                        range:NSMakeRange(3,totalNumStr.length - 3)];
        _totalNumLabel.attributedText = attrStr;
    }
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionViewPhotos registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellCollectionMineMainPhoto] forCellWithReuseIdentifier:NibXMCellCollectionMineMainPhoto];
    self.collectionViewPhotos.backgroundColor = [UIColor whiteColor];
    self.collectionViewPhotos.showsHorizontalScrollIndicator = NO;
    self.collectionViewPhotos.collectionViewLayout = layout;
    self.collectionViewPhotos.dataSource = self;
    self.collectionViewPhotos.delegate = self;
    
    self.btnUserProfile.layer.cornerRadius = 42.5;
    self.btnUserProfile.layer.masksToBounds = YES;
    
    [self.btnUserProfile setBackgroundImage:[UIImage imageNamed:@"global_profile_defult"] forState:UIControlStateNormal];
    self.labelNameNick.text = @"";
    self.labelDistance.text = @"";
    self.labelMatchScore.text = @"";
    self.labelActyTime.text = @"";
    
    self.viewHisInfo.hidden = YES;
    
    self.viewProfileStatus.hidden = YES;
}

- (IBAction)onClickBtnProfile:(id)sender {
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellMineMainProfileAndPhotos:onClickBtnProfile:)]) {
            [self.delegateCell cellMineMainProfileAndPhotos:self onClickBtnProfile:sender];
        }
    }
}

- (IBAction)onClickBtnAddPhotos:(id)sender {
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellMineMainProfileAndPhotosAddPhotos:)]) {
            [self.delegateCell cellMineMainProfileAndPhotosAddPhotos:self];
        }
    }
}

//点击进入U币充值 Change
- (IBAction)onClickBtnBuyUMi:(id)sender {
    //获取现在的U币
    if (self.delegateCell) {
        if([self.delegateCell respondsToSelector:@selector(cellMineMainProfileAndPhotos:onClickBuyUMi:)]){
            [self.delegateCell cellMineMainProfileAndPhotos:self onClickBuyUMi:sender];
        }
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellMineMainProfileAndPhotos:onClickBtnBack:)]) {
            [self.delegateCell cellMineMainProfileAndPhotos:self onClickBtnBack:sender];
        }
    }
}


//进行相关的设置
- (IBAction)onClickBtnSetting:(id)sender {
    if(self.delegateCell){
        if([self.delegateCell respondsToSelector:@selector(cellMineMainProfileAndPhotos:onClickSetting:)]){
            [self.delegateCell cellMineMainProfileAndPhotos:self onClickSetting:sender];
        }
    }
}

- (IBAction)onClickBtnMore:(id)sender {
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellMineMainProfileAndPhotosOnClickMore:)]) {
            [self.delegateCell cellMineMainProfileAndPhotosOnClickMore:self];
        }
    }
}

- (IBAction)onClickBtnUserIdentifier:(id)sender {
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellMineMainProfileAndPhotos:onClickBtnUserIdentifier:)]) {
            [self.delegateCell cellMineMainProfileAndPhotos:self onClickBtnUserIdentifier:sender];
        }
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mineInfo.photos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellMineMainCollectionPhoto *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NibXMCellCollectionMineMainPhoto forIndexPath:indexPath];
    [cell initWithPhoto:self.mineInfo.photos[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 70);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellMineMainProfileAndPhotos:photoIndexPath:)]) {
            [self.delegateCell cellMineMainProfileAndPhotos:self photoIndexPath:indexPath];
        }
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

+ (CGFloat)viewHeight{
    return 257;
}

+ (CGFloat)viewHeaderHeight{
    return [CellMineMainProfileAndPhotos viewHeight]-101;
}

@end
