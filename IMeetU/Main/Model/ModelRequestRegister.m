//
//  ModelRequestRegister.m
//  IMeetU
//
//  Created by zhanghao on 16/3/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelRequestRegister.h"
#import <YYKit/YYKit.h>

@implementation ModelRequestRegister

- (NSString *)deviceName{
    return @"ios";
}

//- (NSString *)deviceUUID{
//    if (!_deviceUUID) {
//        _deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    }
//    return _deviceUUID;
//}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"nameNick":@"nickname",
             @"gender":@"sex",
             @"birthday":@"birth_date",
             @"isGraduated":@"isgraduated",
             @"schoolId":@"school",
             @"cityId":@"city",
             @"cityNum":@"cityf",
             @"profession":@"career",
             @"phone":@"phone",
             @"deviceName":@"device_name",
             @"deviceUUID":@"device_code",
             @"password":@"password",
             @"urlProfile":@"icon_url",
             @"urlProfileOriginal":@"original_icon_url",
             @"deviceType":@"device_type"
             };
}

- (int)deviceType{
    return 4;
}

+ (NSArray *)modelPropertyBlacklist {
    return @[@"httpParameters"];
}

- (NSDictionary *)httpParameters{
    return @{@"data": [self modelToJSONString]};
}

@end
