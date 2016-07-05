//
//  UIStoryboard+Plug.h
//  MeetU_iOS
//
//  Created by zhanghao on 15/7/14.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define xmStoryboardNameAccount @"Account"
#define xmStoryboardNameMine @"Mine"
#define xmStoryboardNameGuide @"Guide"
#define xmStoryboardNameChatMsg @"ChatMsg"
#define xmStoryboardNameBuiBui @"BiuBiu"
#define xmStoryboardNameSetting @"Setting"
#define xmStoryboardNameCommunity @"Community"
#define xmStoryboardNameMessage @"Message"

@interface UIStoryboard(Plug)

+(id)xmControllerWithName:(NSString*)name indentity:(NSString*)indentity;

@end
