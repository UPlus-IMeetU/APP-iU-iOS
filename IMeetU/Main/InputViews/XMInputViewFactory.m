//
//  TFInputViewFactory.m
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "XMInputViewFactory.h"

#import "UINib+Plug.h"

#import "XMInputView.h"
#import "XMInputViewGender.h"
#import "XMInputViewBirthday.h"
#import "XMInputViewCity.h"
#import "XMInputViewProfession.h"

#define NibName @"XMInputViews"

@interface XMInputViewFactory()

@end
@implementation XMInputViewFactory

+(XMInputViewGender *)xmInputViewGender{
    XMInputViewGender *view = [UINib xmViewWithName:NibName class:[XMInputViewGender class]];
    return view;
}

+(XMInputViewBirthday *)xmInputViewBirthday{
    XMInputViewBirthday *view = [UINib xmViewWithName:NibName class:[XMInputViewBirthday class]];
    return view;
}

+(XMInputViewCity *)xmInputViewCity{
    XMInputViewCity *view = [UINib xmViewWithName:NibName class:[XMInputViewCity class]];
    return view;
}

+ (XMInputViewProfession*)xmInputViewProfession{
    XMInputViewProfession *view = [UINib xmViewWithName:NibName class:[XMInputViewProfession class]];
    return view;
}

@end
