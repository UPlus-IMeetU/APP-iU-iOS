//
//  ModelCity.h
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelCity : NSObject

+(instancetype)modelCity;
+ (instancetype)modelCityWithProvince:(NSString*)province;

-(NSInteger)countWithComponent:(NSInteger)component;

-(void)updateCityWithProvince:(NSString*)province;
-(void)updateTownWithCity:(NSString*)city;

-(NSString*)nameWithRow:(NSUInteger)row component:(NSUInteger)component;
-(NSString*)provinceForIndex:(NSInteger)index;
-(NSString*)cityForIndex:(NSInteger)index;

-(NSUInteger)provinceNumForIndex:(NSInteger)index;
-(NSUInteger)cityNumForIndex:(NSInteger)index;


-(NSString*)addressIdWithProvince:(NSString*)province city:(NSString*)city;


@end
