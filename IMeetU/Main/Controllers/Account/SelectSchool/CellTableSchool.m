//
//  CellTableSchool.m
//  MeetU
//
//  Created by zhanghao on 15/11/1.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "CellTableSchool.h"
#import "UIColor+Plug.h"

@interface CellTableSchool()

@property (weak, nonatomic) IBOutlet UILabel *labelSchool;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;

@end
@implementation CellTableSchool

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initDataWithSchool:(NSString*)school{
    [self.labelSchool setText:school];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.labelSchool setTextColor:[UIColor often_33C6E5:1]];
        UIImage *img = [[UIImage imageNamed:@"mine_alter_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 100) resizingMode:UIImageResizingModeTile];
        [self.imgBg setImage:img];
    }else{
        [self.labelSchool setTextColor:[UIColor often_A0A0A0:1]];
        UIImage *img = [[UIImage imageNamed:@"mine_alter_defualt"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 100) resizingMode:UIImageResizingModeTile];
        [self.imgBg setImage:img];
    }
}

@end
