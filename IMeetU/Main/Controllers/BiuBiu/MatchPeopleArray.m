//
//  MatchPeopleArray.m
//  IMeetU
//
//  Created by Spring on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "MatchPeopleArray.h"

@implementation MatchPeopleArray
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"users":[MatchPeople class]};
}
@end
