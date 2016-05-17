//
//  CellMineMainBaseInfo.h
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelResponseMine;

@interface CellMineMainBaseInfo : UITableViewCell

- (void)initWithIsMine:(BOOL)isMine indexPath:(NSIndexPath*)indexPath mineInfo:(ModelResponseMine *)mineInfo;
+ (CGFloat)viewHeight;

@end
