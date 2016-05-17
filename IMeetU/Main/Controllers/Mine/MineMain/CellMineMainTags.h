//
//  CellMineMainTags.h
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelUser.h"

@interface CellMineMainTags : UITableViewCell

- (void)initWithCharacters:(NSArray*)characters indexPath:(NSIndexPath*)indexPath isMine:(BOOL)isMine;
- (void)initWithInterests:(NSArray*)interests indexPath:(NSIndexPath*)indexPath isMine:(BOOL)isMine;

+ (CGFloat)viewHeightWithTagCount:(NSInteger)count;

@end
