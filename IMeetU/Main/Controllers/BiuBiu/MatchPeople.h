//
//  MatchPeople.h
//  IMeetU
//
//  Created by Spring on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchPeople : NSObject
@property (nonatomic,copy) NSString * icon_thumbnailUrl;
@property (nonatomic,copy) NSString * user_code;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * sex;
@property (nonatomic,assign) int age;
@property (nonatomic,copy) NSString * starsign;
@property (nonatomic,copy) NSString * school;
@property (nonatomic,copy) NSString * matching_score;
@property (nonatomic,assign) long distance;
@property (nonatomic,assign) long time;
@property (nonatomic,copy) NSString * chat_tags;
@end
