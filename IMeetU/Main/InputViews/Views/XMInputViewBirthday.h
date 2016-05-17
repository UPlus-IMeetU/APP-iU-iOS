//
//  TFInputViewBirthday.h
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "XMInputView.h"

@protocol XMInputViewBirthdayDelegate;

@interface XMInputViewBirthday : XMInputView

@property (nonatomic, strong) id<XMInputViewBirthdayDelegate> delegateXMInputView;

/**
 *  根据时间戳获得生日字符串形式
 *
 *  @param birthday <#birthday description#>
 *
 *  @return <#return value description#>
 */
+ (NSString*)birthdayStrWithBirthday:(NSInteger)birthday;
@end
@protocol XMInputViewBirthdayDelegate <NSObject>

@optional
- (void)xmInputViewBirthdayInputWithBirthday:(NSDate*)birthday;
@end