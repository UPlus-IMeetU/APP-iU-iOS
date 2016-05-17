//
//  TFInputViewGender.h
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "XMInputView.h"


@protocol XMInputViewGenderDelegate;
@protocol XMInputViewGenderDataSource;

@interface XMInputViewGender : XMInputView

@property (nonatomic, weak) id<XMInputViewGenderDelegate> delegateXMInputView;
@property (nonatomic, weak) id<XMInputViewGenderDataSource> datasourceXMInputView;

@end
@protocol XMInputViewGenderDelegate <NSObject>

@optional
-(void)xmInputViewGenderInputWithGenderStr:(NSString*)genderStr genderNum:(NSInteger)genderNum;

@end
@protocol XMInputViewGenderDataSource <NSObject>

@optional
-(NSInteger)initGenterInXmInputViewGender:(XMInputViewGender*)inputView;

@end
