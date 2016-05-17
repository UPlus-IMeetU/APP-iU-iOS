//
//  ControllerBiuBiuReceive.h
//  IMeetU
//
//  Created by zhanghao on 16/3/4.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelBiuFaceStar.h"
#import "XMBiuFaceStarCollection.h"

@protocol ControllerBiuBiuReceiveDelegate;

@interface ControllerBiuBiuReceive : UIViewController

+ (ControllerBiuBiuReceive*)controllerWithFaceStar:(ModelBiuFaceStar*)model delegate:(id<ControllerBiuBiuReceiveDelegate>)delegate;

@end
@protocol ControllerBiuBiuReceiveDelegate <NSObject>
@optional
/**
 *  biubiu被自己抢了
 *
 *  @param controller
 *  @param biu        抢到的biubiu
 *  @param umiCount   biu币个数
 */
- (void)controllerBiuBiuReceive:(ControllerBiuBiuReceive*)controller grabBiu:(ModelBiuFaceStar*)biu umiCount:(NSInteger)umiCount;
/**
 *  biubiu已经被别人抢过了
 *
 *  @param controller <#controller description#>
 *  @param biu        <#biu description#>
 */
- (void)controllerBiuBiuReceive:(ControllerBiuBiuReceive*)controller alreadyGrabBiu:(ModelBiuFaceStar*)biu;
/**
 *  最新biu币个数
 *
 *  @param controller <#controller description#>
 *  @param umiCount   <#umiCount description#>
 */
- (void)controllerBiuBiuReceive:(ControllerBiuBiuReceive*)controller umiCount:(NSInteger)umiCount;
@end