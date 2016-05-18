//
//  MatchPeopleView.h
//  IMeetU
//
//  Created by Spring on 16/5/17.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelBiuFaceStar.h"
typedef NS_ENUM(NSInteger,MatchRefreshType) {
    Refresh = 0,
    Loading = 1
};
@interface MatchPeopleView : UIView
/**
 *  点击列表回调的block
 */
@property (nonatomic,copy) void (^RecieveBiuBiuSelectBlock)(ModelBiuFaceStar *modelBiuFaceStar);
- (void)initDataWithTime:(NSInteger)time withType:(MatchRefreshType)refreshType;
@end
