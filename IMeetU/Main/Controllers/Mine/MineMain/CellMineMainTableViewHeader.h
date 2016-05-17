//
//  ViewMineMainTableViewHeader.h
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelUser.h"

@interface CellMineMainTableViewHeader : UITableViewCell

- (void)initWithSection:(NSInteger)section;

+ (CGFloat)viewHeight;

@end
