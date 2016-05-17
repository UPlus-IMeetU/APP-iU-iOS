//
//  CellUserIdentifierGuideFooter.m
//  IMeetU
//
//  Created by zhanghao on 16/4/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellUserIdentifierGuideFooter.h"

@implementation CellUserIdentifierGuideFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)onClickBtnCopyWeChat:(id)sender {
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellUserIdentifierGuideFooter:wechat:)]) {
            [self.delegateCell cellUserIdentifierGuideFooter:self wechat:@"liu534469675"];
        }
    }
}

@end
