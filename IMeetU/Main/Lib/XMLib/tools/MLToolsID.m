//
//  MLPassword.m
//  MeetU
//
//  Created by zhanghao on 15/10/6.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "MLToolsID.h"
#import "NSDate+plug.h"

@implementation MLToolsID

+ (NSString *)createBaseID{
    NSString *passwd = @"";
    NSInteger time = [NSDate currentTimeMillis];
    
    for (int i=0; i<6; i++) {
        passwd = [NSString stringWithFormat:@"%c%@", 'a'+arc4random()%25, passwd];
    }
    
    return [NSString stringWithFormat:@"%zi%@", time, passwd];
}

+ (NSString*)createUserProfileID{
    NSString *passwd = @"";
    NSInteger time = [NSDate currentTimeMillis];
    
    for (int i=0; i<6; i++) {
        passwd = [NSString stringWithFormat:@"%c%@", 'a'+arc4random()%25, passwd];
    }
    
    return [NSString stringWithFormat:@"%zi_%@", time, passwd];
}

@end
