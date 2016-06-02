//
//  CellCommunityNotifies.m
//  IMeetU
//
//  Created by zhanghao on 16/6/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellCommunityNotifies.h"

@interface CellCommunityNotifies()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewUnread;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelNameNick;
@property (weak, nonatomic) IBOutlet UILabel *labelSchool;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelNoticeContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPostCover;
@property (weak, nonatomic) IBOutlet UILabel *labelPostContent;

@end
@implementation CellCommunityNotifies

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelNameNick.text = @"";
    self.labelSchool.text = @"";
    self.labelTime.text = @"";
    self.labelNoticeContent.text = @"";
    self.labelPostContent.text = @"";
}

- (void)initWithModel{

}

@end
