//
//  XMNetworkErr.m
//  IMeetU
//
//  Created by zhanghao on 16/6/4.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMNetworkErr.h"
#import "UINib+Plug.h"

@interface XMNetworkErr()

@property (nonatomic, assign) CGFloat y;
@property (nonatomic, copy) NSString *title1;
@property (nonatomic, copy) NSString *title2;
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, copy) void(^callback)(XMNetworkErr *view);

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle1;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle2;

@end
@implementation XMNetworkErr

+ (instancetype)viewWithSuperView:(UIView *)view y:(CGFloat)y callback:(void (^)(XMNetworkErr *))callback{
    return [XMNetworkErr viewWithSuperView:view y:y titles:@[] callback:callback];
}

+ (instancetype)viewWithSuperView:(UIView *)view y:(CGFloat)y titles:(NSArray *)titles callback:(void (^)(XMNetworkErr *))callback{
    XMNetworkErr *networkErr = [UINib xmViewWithName:@"XMNetworkErr" class:[XMNetworkErr class]];
    networkErr.y = y;
    networkErr.superView = view;
    networkErr.callback = callback;
    
    for (int i=0; i<titles.count; i++) {
        NSString *t = titles[i];
        if ([t isKindOfClass:[NSString class]]) {
            if (i==0) {
                networkErr.title1 = t;
            }else if (i==1){
                networkErr.title2 = t;
            }
        }
    }
    
    return networkErr;
}

- (void)awakeFromNib{
    [self.btn setTitle:@"" forState:UIControlStateNormal];
    [self.labelTitle1 setText:@""];
    [self.labelTitle2 setText:@""];
}

- (XMNetworkErr*)showView{
    self.alpha = 0;
    [self.superView addSubview:self];
    [self.labelTitle1 setText:self.title1];
    [self.labelTitle2 setText:self.title2];
    
    self.frame = CGRectMake(0, self.y, self.superView.bounds.size.width, 150);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    return self;
}

- (void)destroyView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)onClick:(id)sender {
    if (self.callback) {
        self.callback(self);
    }
}

@end
