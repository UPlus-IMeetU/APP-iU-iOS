//
//  ModelCity.m
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ModelCity.h"
#import "DBCity.h"

@interface ModelCity()

@property (nonatomic, copy) NSString *nowProvince;
@property (nonatomic, copy) NSString *nowCity;

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *citys;

@end
@implementation ModelCity

+(instancetype)modelCity{
    ModelCity *obj = [[ModelCity alloc] init];
    
    obj.provinces = [DBCity selectProvince];
    obj.citys = [DBCity selectCityWithProvince:[obj provinceForIndex:0]];
    
    return obj;
}

+ (instancetype)modelCityWithProvince:(NSString*)province{
    ModelCity *obj = [[ModelCity alloc] init];
    
    obj.provinces = [DBCity selectProvince];
    if (province) {
        obj.citys = [DBCity selectCityWithProvince:province];
    }else{
        obj.citys = [DBCity selectCityWithProvince:[obj provinceForIndex:0]];
    }
    
    return obj;
}


-(NSInteger)countWithComponent:(NSInteger)component{
    if (component == 0) {
        return [self countOfProvinces];
    }else if (component == 1){
        return [self countOfCitys];
    }
    
    return 0;
}
-(NSUInteger)countOfProvinces{
    return self.provinces.count;
}
-(NSUInteger)countOfCitys{
    return self.citys.count;
}


-(void)updateCityWithProvince:(NSString *)province{
    if (province != nil) {
        self.nowProvince = province;
        self.citys = [DBCity selectCityWithProvince:province];
    }
}
-(void)updateTownWithCity:(NSString *)city{
    if (city != nil) {
        self.nowCity = city;
    }
}

-(NSString*)nameWithRow:(NSUInteger)row component:(NSUInteger)component{
    if (component == 0) {
        return [self provinceForIndex:row];
    }else if (component == 1){
        return [self cityForIndex:row];
    }
    
    return @"";
}
-(NSString*)provinceForIndex:(NSInteger)index{
    if (index < self.provinces.count) {
        NSDictionary *province = self.provinces[index];
        return province[@"name"];
    }
    return @"";
}
-(NSString*)cityForIndex:(NSInteger)index{
    if (index < self.citys.count) {
        NSDictionary *city = self.citys[index];
        return city[@"name"];
    }
    return @"";
}


-(NSUInteger)provinceNumForIndex:(NSInteger)index{
    if (index < self.provinces.count) {
        NSDictionary *province = self.provinces[index];
        return [province[@"num"] longValue];
    }
    return 0;
}
-(NSUInteger)cityNumForIndex:(NSInteger)index{
    if (index < self.citys.count) {
        NSDictionary *city = self.citys[index];
        return [city[@"num"] longValue];
    }
    return 0;
}

-(NSString*)addressIdWithProvince:(NSString*)province city:(NSString*)city{
    return [DBCity addressIdWithProvince:province city:city];
}

@end
