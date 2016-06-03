//
//  ViewChatMsgBtnBiu.m
//  IMeetU
//
//  Created by zhanghao on 16/6/2.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ViewChatMsgBtnBiu.h"
#import "UINib+Plug.h"

@interface ViewChatMsgBtnBiu()

@property (weak, nonatomic) IBOutlet UIView *viewNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;
@property (nonatomic, copy) void(^callback)();

@end
@implementation ViewChatMsgBtnBiu

+ (instancetype)viewWithCallback:(void (^)())callback{
    ViewChatMsgBtnBiu *view = [UINib xmViewWithName:@"ViewChatMsgBtnBiu" class:[ViewChatMsgBtnBiu class]];
    view.callback = callback;
    
    return view;
}

- (void)awakeFromNib{
    self.viewNumber.layer.cornerRadius = 5;
    self.viewNumber.layer.masksToBounds = YES;
}

- (void)setNumber:(NSInteger)number{
    if (number<1) {
        self.viewNumber.hidden = YES;
    }else if (number>0 && number<100){
        self.viewNumber.hidden = NO;
        [self.labelNumber setText:[NSString stringWithFormat:@"%ld", number]];
    }else{
        self.viewNumber.hidden = NO;
        [self.labelNumber setText:@"99+"];
    }
}

- (IBAction)onClickBtn:(id)sender {
    if (self.callback) {
        self.callback();
    }
}

@end
