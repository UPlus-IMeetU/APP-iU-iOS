//
//  XMInputViewProfession.h
//  IMeetU
//
//  Created by zhanghao on 16/3/7.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMInputViewProfessionDelegate;

@interface XMInputViewProfession : UIView

@property (nonatomic, weak) id<XMInputViewProfessionDelegate> delegateInputView;

@end
@protocol XMInputViewProfessionDelegate <NSObject>
@optional

- (void)xmInputViewProfession:(XMInputViewProfession*)inputView profession:(NSString*)profession;

@end
