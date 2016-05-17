//
//  DBCity.h
//  MeetU
//
//  Created by zhanghao on 15/8/10.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBCity : NSObject

+(NSArray*)selectProvince;

+(NSArray*)selectCityWithProvince:(NSString*)province;

+(NSString*)addressIdWithProvince:(NSString*)province city:(NSString*)city;

+(NSString*)addressWithId:(NSString*)Id;

+(NSDictionary*)addressDicWithId:(NSString *)Id;

+ (NSInteger)selectIndexOfProvince:(NSString*)province;

+ (NSInteger)selectIndexOfCity:(NSString*)city province:(NSString*)province;
@end
