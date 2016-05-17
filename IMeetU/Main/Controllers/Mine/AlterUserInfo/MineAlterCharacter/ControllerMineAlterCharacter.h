//
//  ControllerMineAlterCharacter.h
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllerMineAlterCharacterDelegate;
@interface ControllerMineAlterCharacter : UIViewController

@property (nonatomic, weak) id<ControllerMineAlterCharacterDelegate> delegateAlterCharacter;

+ (instancetype)controllerWithCharacters:(NSArray*)characters gender:(NSInteger)gender;

@end
@protocol ControllerMineAlterCharacterDelegate <NSObject>
@optional
- (void)controllerMineAlterCharacter:(ControllerMineAlterCharacter*)controller selecteds:(NSArray*)selecteds;
@end
