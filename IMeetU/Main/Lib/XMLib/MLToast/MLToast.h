//
//  MLToast.h
//  MeetU
//
//  Created by zhanghao on 15/11/16.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MLToast : UIView

+ (instancetype)toastInView:(UIView*)view content:(NSString*)content;
- (void)show;

@end
