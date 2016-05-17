//
//  TFInputViewCity.h
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "XMInputView.h"

@protocol XMInputViewCityDelegate;

@interface XMInputViewCity : XMInputView

@property (nonatomic, strong) id<XMInputViewCityDelegate> delegateXMInputView;

@end
@protocol XMInputViewCityDelegate <NSObject>
@optional

-(void)xmInputViewCityInputWithAddress:(NSString *)address addressId:(NSString *)addressId cityNum:(NSString*)cityNum;

@end