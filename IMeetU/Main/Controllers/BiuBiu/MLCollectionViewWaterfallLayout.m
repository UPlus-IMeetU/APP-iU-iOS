//
//  MLCollectionViewWaterfallLayout.m
//  MeetU
//
//  Created by zhanghao on 15/8/29.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "MLCollectionViewWaterfallLayout.h"

@interface MLCollectionViewWaterfallLayout()

@property (nonatomic, strong) NSMutableArray *columnsHeight;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSMutableArray *attributes;

@end
@implementation MLCollectionViewWaterfallLayout

//初始化数组，数组保存着当前每列的高度
- (NSMutableArray *)columnsHeight{
    if (!_columnsHeight) {
        _columnsHeight = [NSMutableArray array];
        for (int i=0; i<self.columnCount; i++) {
            [_columnsHeight addObject:[NSNumber numberWithFloat:self.sectionInsets.top]];
        }
    }
    
    return _columnsHeight;
}

- (NSMutableArray *)attributes{
    if (!_attributes) {
        self.columnsHeight = [NSMutableArray array];
        for (int i=0; i<self.columnCount; i++) {
            [self.columnsHeight addObject:[NSNumber numberWithFloat:self.sectionInsets.top]];
        }
        
        NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
        
        _attributes = [NSMutableArray array];
        for (int i=0; i<cellCount; i++) {
            [_attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
        }
        
    }
    return _attributes;
}

#pragma mark - 获取Cell的最终此存
- (CGFloat)cellWidth{
    return (self.collectionView.frame.size.width - self.sectionInsets.left - self.sectionInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount + self.cellInsets.left + self.cellInsets.right;
}

- (CGFloat)cellHeightWithIndexPath:(NSIndexPath*)indexPath{
    return self.cellWidth / [self cellContentWidthWithIndexPath:indexPath] * [self cellContentHeightWithIndexPath:indexPath] + self.cellInsets.top + self.cellInsets.bottom;
}

#pragma mark - 通过委托方法，获取Cell动态内容尺寸
- (CGFloat)cellContentWidthWithIndexPath:(NSIndexPath*)indexPath{
    if (self.delegateLayout) {
        if ([self.delegateLayout respondsToSelector:@selector(cellContentSizeWithIndexPath:)]) {
            return [self.delegateLayout cellContentSizeWithIndexPath:indexPath].width;
        }
    }
    
    return 0;
}

- (CGFloat)cellContentHeightWithIndexPath:(NSIndexPath*)indexPath{
    if (self.delegateLayout) {
        if ([self.delegateLayout respondsToSelector:@selector(cellContentSizeWithIndexPath:)]) {
            return [self.delegateLayout cellContentSizeWithIndexPath:indexPath].height;
        }
    }
    return 0;
}

#pragma mark - layout自动调用方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (void)prepareLayout{
    [super prepareLayout];
    //清空每列y值
    self.columnsHeight = [NSMutableArray array];
    for (int i=0; i<self.columnCount; i++) {
        [self.columnsHeight addObject:[NSNumber numberWithFloat:self.sectionInsets.top]];
    }
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    self.attributes = [NSMutableArray array];
    for (int i=0; i<cellCount; i++) {
        UICollectionViewLayoutAttributes *layoutAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [self.attributes addObject:layoutAttr];
    }
}

- (CGSize)collectionViewContentSize{
    float maxY = 0;
    for (int i=0; i<self.columnCount; i++) {
        if ([self.columnsHeight[i] floatValue] > maxY) {
            maxY = [self.columnsHeight[i] floatValue];
        }
    }
    return CGSizeMake(0, maxY - self.rowMargin + self.sectionInsets.bottom);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *layoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    int minColumn = 0;
    for (int i=0; i<self.columnCount; i++) {
        if ([self.columnsHeight[minColumn] floatValue] > [self.columnsHeight[i] floatValue]) {
            minColumn = i;
        }
    }
    
    float x = self.sectionInsets.left + (self.cellWidth + self.columnMargin) *minColumn;
    float y = [self.columnsHeight[minColumn] floatValue];
    
    self.columnsHeight[minColumn] = @([self.columnsHeight[minColumn] floatValue] + [self cellHeightWithIndexPath:indexPath] + self.rowMargin);
    
    layoutAttribute.frame = CGRectMake(x, y, self.cellWidth, [self cellHeightWithIndexPath:indexPath]);
    
    if (self.delegateLayout) {
        if ([self.delegateLayout respondsToSelector:@selector(cellFrame:indexPath:)]) {
            [self.delegateLayout cellFrame:layoutAttribute.frame indexPath:indexPath];
        }
    }
    
    return layoutAttribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributes;
}

@end
