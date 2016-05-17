//
//  CellUserIdentifierGuideFooter.h
//  IMeetU
//
//  Created by zhanghao on 16/4/14.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellUserIdentifierGuideFooterProtocol;

@interface CellUserIdentifierGuideFooter : UITableViewCell

@property (nonatomic, weak) id<CellUserIdentifierGuideFooterProtocol> delegateCell;

@end
@protocol CellUserIdentifierGuideFooterProtocol <NSObject>
@optional
- (void)cellUserIdentifierGuideFooter:(CellUserIdentifierGuideFooter*)cell wechat:(NSString*)wechat;

@end