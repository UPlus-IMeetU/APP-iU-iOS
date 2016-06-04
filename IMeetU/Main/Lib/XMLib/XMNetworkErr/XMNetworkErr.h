//
//  XMNetworkErr.h
//  IMeetU
//
//  Created by zhanghao on 16/6/4.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMNetworkErr : UIView

+ (instancetype)viewWithSuperView:(UIView*)view y:(CGFloat)y callback:(void(^)(XMNetworkErr *view))callback;

+ (instancetype)viewWithSuperView:(UIView*)view y:(CGFloat)y titles:(NSArray*)titles callback:(void(^)(XMNetworkErr *view))callback;

- (XMNetworkErr*)showView;

- (void)destroyView;

@end
