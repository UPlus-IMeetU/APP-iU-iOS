//
//  CellMineMainTags.m
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellMineMainTags.h"
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"
#import "XMNibStoryboardFilesName.h"
#import "CellMineMainCollectionTag.h"
#import "ModelInterest.h"

#import "ModelCharacher.h"
#import "ModelMineAlterInterest.h"

@interface CellMineMainTags()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) ModelUser *user;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray *characters;
@property (nonatomic, strong) NSArray *interests;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewArrow;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewTags;

@end
@implementation CellMineMainTags

- (void)initWithCharacters:(NSArray*)characters indexPath:(NSIndexPath*)indexPath isMine:(BOOL)isMine{
    self.characters = characters;
    self.isMine = isMine;
    
    self.indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    [self setTitleWithIndexPath:self.indexPath];
    
    [self.collectionViewTags reloadData];
    
    self.imageViewArrow.hidden = !isMine;
}

- (void)initWithInterests:(NSArray*)interests indexPath:(NSIndexPath*)indexPath isMine:(BOOL)isMine{
    self.interests = interests;
    self.isMine = isMine;
    
    self.indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    [self setTitleWithIndexPath:self.indexPath];
    
    [self.collectionViewTags reloadData];
    
    self.imageViewArrow.hidden = !isMine;
}

- (void)awakeFromNib {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [self.collectionViewTags registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellCollectionMineMainTag] forCellWithReuseIdentifier:NibXMCellCollectionMineMainTag];
    self.collectionViewTags.showsVerticalScrollIndicator = NO;
    self.collectionViewTags.collectionViewLayout = layout;
    self.collectionViewTags.dataSource = self;
    self.collectionViewTags.delegate = self;
    [self.collectionViewTags setBackgroundColor:[UIColor whiteColor]];
    
    self.collectionViewTags.userInteractionEnabled = NO;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.indexPath.section == 4) {
        return self.characters.count;
    }else if (self.indexPath.section == 5){
        return self.interests.count;
    }
    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellMineMainCollectionTag *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NibXMCellCollectionMineMainTag forIndexPath:indexPath];
    if (self.indexPath.section == 4) {
        [cell initWithCharacter:self.characters[indexPath.row]];
    }else if (self.indexPath.section == 5){
        [cell initWithInterest:self.interests[indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(53, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat marginLeftRight = ([UIScreen screenWidth]-53*4-28*3)/2;
    return UIEdgeInsetsMake(13, marginLeftRight, 14, marginLeftRight);
}

- (void)setTitleWithIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section == 4) {
        [self.labelTitle setText:@"我的个性标签"];
        [self.imgViewTitle setImage:[UIImage imageNamed:@"mine_main_imageview_tab"]];
    }else if (indexPath.section == 5){
        [self.labelTitle setText:@"我的兴趣爱好"];
        [self.imgViewTitle setImage:[UIImage imageNamed:@"mine_main_imageview_hobby"]];
    }
}

+ (CGFloat)viewHeightWithTagCount:(NSInteger)count{
    CGFloat height = 48;
    if (count>0) {
        if (count%4 == 0) {
            height += ((int)count/4)*38 + 14;
        }else{
            height += ((int)count/4+1)*38 + 14;
        }
    }
    
    return height;
}

@end
