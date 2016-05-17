//
//  MLAnnotation.h
//  MeetU
//
//  Created by zhanghao on 15/8/31.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MLAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
