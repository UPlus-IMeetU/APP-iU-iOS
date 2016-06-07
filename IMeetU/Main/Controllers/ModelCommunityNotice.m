//
//  ModelCommunityNotice.m
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelCommunityNotice.h"
#import "UIScreen+Plug.h"

@implementation ModelCommunityNotice

- (CGFloat)cellHeight{
    if (_cellHeight < 150) {
        UILabel *l = [[UILabel alloc] init];
        l.numberOfLines = 0;
        l.text = self.desc;
        l.font = [UIFont systemFontOfSize:13];
        CGSize size = [l sizeThatFits:CGSizeMake([UIScreen screenWidth]-83, CGFLOAT_MAX)];
        _cellHeight = size.height+150;
    }
    return _cellHeight;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"type":@"type",
             @"isRead":@"isRead",
             @"userCode":@"userCode",
             @"userName":@"userName",
             @"userProfile":@"userHead",
             @"userSchool":@"userSchool",
             @"createAt":@"createAt",
             @"desc":@"desc",
             @"postId":@"postId",
             @"postImg":@"postImg",
             @"postContent":@"postContent",
             };
}

@end
