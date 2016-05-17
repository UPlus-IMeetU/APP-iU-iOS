//
//  TFInputViewEmoji.m
//  MeetU
//
//  Created by zhanghao on 15/9/27.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "XMInputViewEmoji.h"
#import "UIColor+Plug.h"
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"
#import "CellEmoji.h"
#import "ModelEmoji.h"
#import "ModelsEmoji.h"

#define CellReuseIdentifier @"CellEmoji"

@interface XMInputViewEmoji()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewEmojis;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControlEmoji;
@property (weak, nonatomic) IBOutlet UIButton *btnEmojiBase;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (nonatomic, strong) ModelsEmoji *modelsEmoji;
@end
@implementation XMInputViewEmoji

+ (instancetype)xmInputViewEmoji{
    XMInputViewEmoji *view = [UINib xmViewWithName:@"XMInputViewEmoji" class:[XMInputViewEmoji class]];
    
    return view;
}

- (void)layoutSubviews{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionViewEmojis registerClass:[CellEmoji class] forCellWithReuseIdentifier:CellReuseIdentifier];
    self.collectionViewEmojis.collectionViewLayout = layout;
    
    self.collectionViewEmojis.delegate = self;
    self.collectionViewEmojis.dataSource = self;
    self.collectionViewEmojis.pagingEnabled = YES;
    self.collectionViewEmojis.showsHorizontalScrollIndicator = NO;
    
    self.pageControlEmoji.tintColor = [UIColor often_CCCCCC:0.6];
    self.pageControlEmoji.numberOfPages = [self numberOfPages];
}

- (ModelsEmoji *)modelsEmoji{
    if (!_modelsEmoji) {
        _modelsEmoji = [ModelsEmoji modelsEmoji];
    }
    return _modelsEmoji;
}

- (void)scrollZero{
    self.collectionViewEmojis.contentOffset = CGPointMake(0, 0);
}

- (NSInteger)numberCellOfHorizontal{
    NSInteger number = 7;
    
    if ([UIScreen is47Screen]) {
        return number + 1;
    }else if ([UIScreen is55Screen]){
        return number + 2;
    }
    
    return number;
}

- (NSInteger)numberCellForOneScreen{
    return CELL_NUMBER_VERTICAL * [self numberCellOfHorizontal];
}

- (NSInteger)locationInModelsWithIndex:(NSInteger)index{
    return index - (index/[self numberCellForOneScreen]);
}

- (NSInteger)numberOfPages{
    if ([self.modelsEmoji numberOfItems] % ([self numberCellForOneScreen]-1) != 0) {
        int numberScreen = (int)[self.modelsEmoji numberOfItems] / ([self numberCellForOneScreen] - 1);
        return ++numberScreen;
    }
    return [self.modelsEmoji numberOfItems] / ([self numberCellForOneScreen]-1);
}

- (NSInteger)numberCell{
    return [self numberCellForOneScreen] * [self numberOfPages];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = CGRectMake(0, 0, PANEL_W, PANEL_H);
        
    }
    return self;
}

- (CGFloat)minimumLineSpacing{
    return ([UIScreen screenWidth] - CELL_W * [self numberCellOfHorizontal]) / [self numberCellOfHorizontal];
}

- (UIImage*)imageOfIndex:(NSInteger)index{
    if ((index + 1)%[self numberCellForOneScreen] != 0) {
        return [self.modelsEmoji imageOfIndex:[self locationInModelsWithIndex:index]];
    }
                                               
    return [UIImage imageNamed:@"panelchat_btn_delete"];
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControlEmoji.currentPage = scrollView.contentOffset.x / [UIScreen screenWidth] + 0.5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegateXmInputView) {
        if ((indexPath.row+1) % [self numberCellForOneScreen] == 0) {
            if ([self.delegateXmInputView respondsToSelector:@selector(xmInputViewDelete)]) {
                [self.delegateXmInputView xmInputViewDelete];
            }
        }else{
            if ([self.delegateXmInputView respondsToSelector:@selector(xmInputViewAddEmoji:)]) {
                [self.delegateXmInputView xmInputViewAddEmoji:[self.modelsEmoji imageKeyOfIndex:[self locationInModelsWithIndex:indexPath.row]]];
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self numberCell];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellEmoji *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    [cell setImage:[self imageOfIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CELL_W, CELL_H);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return [self minimumLineSpacing];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, [self minimumLineSpacing]/2, 5, [self minimumLineSpacing]/2);
}
@end
