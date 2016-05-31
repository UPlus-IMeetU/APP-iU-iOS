//
//  CellPostTags.m
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellPostTags.h"


@interface CellPostTags()

@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@end
@implementation CellPostTags

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.labelContent setText:@""];
}

- (void)initWithTag:(NSString *)tag{
    [self.labelContent setText:tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
