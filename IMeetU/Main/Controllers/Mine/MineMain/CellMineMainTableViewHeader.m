//
//  ViewMineMainTableViewHeader.m
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellMineMainTableViewHeader.h"
#import "UIColor+Plug.h"

@interface CellMineMainTableViewHeader()

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
@implementation CellMineMainTableViewHeader

- (void)awakeFromNib{
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithR:248 G:246 B:244];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initWithSection:(NSInteger)section{
    [self.labelTitle setText:[self titleWithSection:section]];
}

- (NSString*)titleWithSection:(NSInteger)section{
    switch (section) {
        case 1:return @"关于我"; break;
        case 2:return @"基本信息"; break;
        case 3:return @"身份/职业"; break;
        case 4:return @"个性标签"; break;
        case 5:return @"兴趣爱好"; break;
    }
    return @"";
}

+ (CGFloat)viewHeight{
    return 19;
}

@end
