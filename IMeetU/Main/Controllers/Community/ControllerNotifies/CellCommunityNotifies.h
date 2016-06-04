//
//  CellCommunityNotifies.h
//  IMeetU
//
//  Created by zhanghao on 16/6/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelCommunityNotice;
@protocol CellCommunityNotifiesDelegate;

@interface CellCommunityNotifies : UITableViewCell

@property (nonatomic, weak) id<CellCommunityNotifiesDelegate> delegateNotice;
- (void)initWithModel:(ModelCommunityNotice*)model;

@end
@protocol CellCommunityNotifiesDelegate <NSObject>
@optional
- (void)cell:(CellCommunityNotifies*)cell userCode:(NSInteger)userCode;

@end