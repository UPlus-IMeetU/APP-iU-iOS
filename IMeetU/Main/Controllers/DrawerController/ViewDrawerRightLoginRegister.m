//
//  ViewDrawerRightLoginRegister.m
//  IMeetU
//
//  Created by zhanghao on 16/5/13.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ViewDrawerRightLoginRegister.h"
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"

@interface ViewDrawerRightLoginRegister()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDistance;


@end
@implementation ViewDrawerRightLoginRegister

+ (instancetype)view{
    ViewDrawerRightLoginRegister *view = [UINib xmViewWithName:@"ViewDrawerRightLoginRegister" class:[ViewDrawerRightLoginRegister class]];
    if ([UIScreen is40Screen]) {
        view.constraintDistance.constant = 90;
    }
    
    return view;
}



- (IBAction)onClickBtnRegister:(id)sender {
    if (self.delegateLoginRegister) {
        if ([self.delegateLoginRegister respondsToSelector:@selector(viewDrawerRightRegister:)]) {
            [self.delegateLoginRegister viewDrawerRightRegister:self];
        }
    }
}

- (IBAction)onClickBtnLogin:(id)sender {
    if (self.delegateLoginRegister) {
        if ([self.delegateLoginRegister respondsToSelector:@selector(viewDrawerRightLogin:)]) {
            [self.delegateLoginRegister viewDrawerRightLogin:self];
        }
    }
}

@end
