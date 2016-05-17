//
//  CellMineMainPersonalIntroductions.h
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellMineMainPersonalIntroductionsDelegate;

@interface CellMineMainPersonalIntroductions : UITableViewCell

@property (nonatomic, weak) id<CellMineMainPersonalIntroductionsDelegate> delegateCell;

- (void)initWithContent:(NSString*)content isOpen:(BOOL)isOpen isMine:(BOOL)isMine;

+ (CGFloat)viewHeightWithContent:(NSString*)content isOpen:(BOOL)isOpen isMine:(BOOL)isMine;

@end
@protocol CellMineMainPersonalIntroductionsDelegate <NSObject>
@optional
- (void)cellMineMainPersonalIntroductions:(CellMineMainPersonalIntroductions*)cell isOpen:(BOOL)isOpen;

@end
