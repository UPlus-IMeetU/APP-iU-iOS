//
//  ControllerChatMsgLocation.m
//  IMeetU
//
//  Created by zhanghao on 16/3/21.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerChatMsgLocation.h"

#import <MapKit/MapKit.h>

#import "UIStoryboard+Plug.h"

#import "MLAnnotation.h"

@interface ControllerChatMsgLocation ()<MKMapViewDelegate>

@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@end

@implementation ControllerChatMsgLocation

+ (instancetype)controllerWithLatitude:(float)latitude longitude:(float)longitude{
    ControllerChatMsgLocation *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameChatMsg indentity:@"ControllerChatMsgLocation"];
    controller.latitude = latitude;
    controller.longitude = longitude;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.map.mapType = MKMapTypeStandard;
    self.map.delegate = self;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.025, 0.020);//这个显示大小精度自己调整
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    [self.map setRegion:MKCoordinateRegionMake(location, span) animated:YES];
    
    MLAnnotation *annotation = [[MLAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
    [self.map addAnnotation:annotation];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
