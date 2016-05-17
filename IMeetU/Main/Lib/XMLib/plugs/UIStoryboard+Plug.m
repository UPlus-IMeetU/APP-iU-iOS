//
//  UIStoryboard+Plug.m
//  MeetU_iOS
//
//  Created by zhanghao on 15/7/14.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "UIStoryboard+Plug.h"

@implementation UIStoryboard(Plug)

+(id)xmControllerWithName:(NSString *)name indentity:(NSString *)indentity{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:indentity];
}

@end
