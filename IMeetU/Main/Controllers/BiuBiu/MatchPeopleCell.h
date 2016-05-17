//
//  MatchPeopleCell.h
//  IMeetU
//
//  Created by Spring on 16/5/16.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchPeople.h"
@interface MatchPeopleCell : UICollectionViewCell
@property (nonatomic,strong) MatchPeople *matchPeople;
- (void)Circular;
@end
