//
//  ModelCommunityNotifies.m
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelCommunityNotifies.h"
#import "ModelCommunityNotice.h"

@implementation ModelCommunityNotifies

- (ModelCommunityNotice *)modelWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.notifies.count) {
        return self.notifies[indexPath.row];
    }
    return nil;
}

- (NSInteger)numberOfRowsInSection{
    return self.notifies.count;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.notifies.count) {
        ModelCommunityNotice *notice = self.notifies[indexPath.row];
        return notice.cellHeight;
    }
    return 0;
}

- (long long)lastNoficeCreateAt{
    if (self.notifies.count > 0) {
        ModelCommunityNotice *notice = self.notifies[self.notifies.count-1];
        return notice.createAt;
    }
    return 0;
}

- (void)additionalNoticeWithArr:(NSArray *)notifies{
    [self.notifies addObjectsFromArray:notifies];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"notifies" : [ModelCommunityNotice class]
             };
}

@end
