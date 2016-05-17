//
//  TFInputViewFactory.h
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMInputView.h"

@class XMInputViewGender;
@class XMInputViewBirthday;
@class XMInputViewCity;
@class XMInputViewProfession;

@interface XMInputViewFactory : XMInputView

+(XMInputViewGender*)xmInputViewGender;

+(XMInputViewBirthday*)xmInputViewBirthday;

+(XMInputViewCity*)xmInputViewCity;

+(XMInputViewProfession*)xmInputViewProfession;

@end
