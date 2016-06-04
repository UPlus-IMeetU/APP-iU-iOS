//
//  CellCommunityNotifies.m
//  IMeetU
//
//  Created by zhanghao on 16/6/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellCommunityNotifies.h"
#import "ModelCommunityNotice.h"
#import <YYKit/YYKit.h>
#import "DBSchools.h"
#import "NSDate+plug.h"

@interface CellCommunityNotifies()

@property (weak, nonatomic) IBOutlet UIView *viewUnread;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelNameNick;
@property (weak, nonatomic) IBOutlet UILabel *labelSchool;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelNoticeContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPostCover;
@property (weak, nonatomic) IBOutlet UILabel *labelPostContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPostContentMarginLeft;

@property (nonatomic, weak) ModelCommunityNotice *model;
@end
@implementation CellCommunityNotifies

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelNameNick.text = @"";
    self.labelSchool.text = @"";
    self.labelTime.text = @"";
    self.labelNoticeContent.text = @"";
    self.labelPostContent.text = @"";
    
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    self.viewUnread.layer.cornerRadius = 3;
    self.viewUnread.layer.masksToBounds = YES;
}

- (void)initWithModel:(ModelCommunityNotice*)model{
    self.model = model;
    self.viewUnread.hidden = model.isRead;
    [self.btnProfile setBackgroundImageWithURL:[NSURL URLWithString:model.userProfile] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@""]];
    [self.labelNameNick setText:model.userName];
    [self.labelSchool setText:[[DBSchools shareInstance] schoolNameWithID:[model.userSchool integerValue]]];
    [self.labelNoticeContent setText:model.desc];
    
    [self.labelTime setText:[[NSDate dateWithTimeIntervalSince1970:model.createAt] xmTimeTextOfDate]];
    if (!model.postImg || model.postImg.length<1) {
        self.imgViewPostCover.hidden = YES;
        self.constraintPostContentMarginLeft.constant = 10;
    }else {
        self.imgViewPostCover.hidden = NO;
        self.constraintPostContentMarginLeft.constant = 59;
        [self.imgViewPostCover setImageWithURL:[NSURL URLWithString:model.postImg] placeholder:nil];
    }
    [self.labelPostContent setText:model.postContent];
    [self layoutIfNeeded];
}

- (IBAction)onClickBtnUserProfile:(id)sender {
    if (self.delegateNotice) {
        if ([self.delegateNotice respondsToSelector:@selector(cell:userCode:)]) {
            [self.delegateNotice cell:self userCode:self.model.userCode];
        }
    }
}

@end
