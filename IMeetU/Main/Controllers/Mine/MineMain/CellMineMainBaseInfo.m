//
//  CellMineMainBaseInfo.m
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellMineMainBaseInfo.h"
#import "ModelUser.h"

#import "NSDate+plug.h"

#import "XMQueryConstellation.h"
#import "DBCity.h"
#import "DBSchools.h"
#import "UIColor+Plug.h"
#import "ModelResponseMine.h"


@interface CellMineMainBaseInfo()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelContentRight;
@property (nonatomic, copy) NSString *title;

@property (weak, nonatomic) IBOutlet UIView *viewSeparator;
@end
@implementation CellMineMainBaseInfo

- (void)initWithIsMine:(BOOL)isMine indexPath:(NSIndexPath *)indexPath mineInfo:(ModelResponseMine *)mineInfo{
    indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    
    self.selectionStyle = [self selectionStyleWithIsMine:isMine indexPath:indexPath];
    //是否显示cell右边的指示器
    self.imageViewArrow.hidden = [self isHiddenImgViewArrowWithIndexPath:indexPath isMine:isMine];
    //cell内容右边距
    self.constraintLabelContentRight.constant = isMine?44:20;
    [self layoutIfNeeded];
    //cell标题
    [self.labelTitle setText:[self titleWithIndexPath:indexPath mineInfo:mineInfo]];
    //设置cell的内容
    [self setLabelContentWithIndexPath:indexPath mineInfo:mineInfo];
    //设置cell图标
    [self.imgViewTitle setImage:[self imgViewTitleWithIndexPath:indexPath]];
    
    //cell分割线
    if (indexPath.section==1 && indexPath.section==2 && indexPath.row==7) {
        self.viewSeparator.hidden = YES;
    }else if (indexPath.section==3 && indexPath.row==2){
        self.viewSeparator.hidden = YES;
    }else{
        self.viewSeparator.hidden = NO;
    }
    
    //判断是否可以发biu
    UIButton *biuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    biuButton.frame = CGRectMake(0, self.frame.size.width - 49, self.frame.size.width , 49);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (CGFloat)viewHeight{
    return 48;
}

- (UITableViewCellSelectionStyle)selectionStyleWithIsMine:(BOOL)isMine indexPath:(NSIndexPath *)indexPath{
    if (isMine) {
        if (indexPath.section==2 && indexPath.row==1) {
            return UITableViewCellSelectionStyleNone;
        }else{
            return UITableViewCellSelectionStyleDefault;
        }
    }
    return UITableViewCellSelectionStyleNone;
}

- (CGFloat)constantConstraintImgViewArrowWidthWithIsMine:(BOOL)isMine{
    if (isMine) {
        return 20;
    }
    return 0;
}

- (BOOL)isHiddenImgViewArrowWithIndexPath:(NSIndexPath*)indexPath isMine:(BOOL)isMine{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return NO;
    }else if (indexPath.section==2 && indexPath.row==1) {
        return YES;
    }else if (!isMine && (indexPath.section == 1 && indexPath.row)){
        return YES;
    }
    return NO;
}

- (NSString *)titleWithIndexPath:(NSIndexPath*)indexPath mineInfo:(ModelResponseMine *)mineInfo{
    if (indexPath.section == 1){
        switch (indexPath.row) {
            case 1:return @"个人动态";
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:return @"昵称"; break;
            case 1:return @"性别"; break;
            case 2:return @"生日"; break;
            case 3:return @"星座"; break;
            case 4:return @"所在城市"; break;
            case 5:return @"我的家乡"; break;
            case 6:return @"身高体重"; break;
        }
    }else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:return @"身份"; break;
            case 1:return @"学校"; break;
        }
    }
    
    return @"";
}

- (void)setLabelContentWithIndexPath:(NSIndexPath*)indexPath mineInfo:(ModelResponseMine *)mineInfo{
    NSString *content = [self contentWithIndexPath:indexPath mineInfo:mineInfo];
    [self.labelContent setTextColor:[UIColor blackColor]];
    
    if (content.length == 0) {
        [self.labelContent setTextColor:[UIColor colorWithR:160 G:160 B:160]];
        if (indexPath.section==2 && indexPath.row==5) {
            content = @"世界那么大 你家在哪儿";
        }else if (indexPath.section==2 && indexPath.row==6) {
            content = @"茁壮成长中";
        }
    }
    [self.labelContent setText:content];
}

- (UIImage*)imgViewTitleWithIndexPath:(NSIndexPath*)indexPath{
    UIImage *img = [[UIImage alloc] init];
    NSInteger row = indexPath.row;
    if (indexPath.section == 1){
        if (row == 1){
            return [UIImage imageNamed:@"mine_main_imageview_post"];
        }
    }else if (indexPath.section == 2) {
        if (row == 0) {
            return [UIImage imageNamed:@"mine_main_imageview_name"];
        }else if (row == 1){
            return [UIImage imageNamed:@"mine_main_imageview_gender"];
        }else if (row == 2){
            return [UIImage imageNamed:@"mine_main_imageview_birthday"];
        }else if (row == 3){
            return [UIImage imageNamed:@"mine_main_imageview_constellation"];
        }else if (row == 4){
            return [UIImage imageNamed:@"mine_main_imageview_city"];
        }else if (row == 5){
            return [UIImage imageNamed:@"mine_main_imageview_home_town"];
        }else if (row == 6){
            return [UIImage imageNamed:@"mine_main_imageview_tall"];
        }
    }else if (indexPath.section == 3){
        if (row == 0) {
            return [UIImage imageNamed:@"mine_main_imageview_shenfen"];
        }else if (row == 1){
            return [UIImage imageNamed:@"mine_main_imageview_school"];
        }
    }
    
    return img;
}

- (NSString*)contentWithIndexPath:(NSIndexPath*)indexPath mineInfo:(ModelResponseMine *)mineInfo{
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:return mineInfo.nameNick; break;
            case 1:
                if (mineInfo.gender == 0) {
                    
                }else if (mineInfo.gender == 1){
                    return @"男生";
                }else{
                    return @"女生";
                }
                break;
            case 2:return [NSDate timeDateFormatYMD:mineInfo.birthday]; break;
            case 3:
                if (mineInfo.constellation) {
                    return mineInfo.constellation;
                }else{
                    return [XMQueryConstellation constellationWithDate:[mineInfo.birthday currentTimeMillisSecond]];
                }
                break;
            case 4:return [DBCity addressWithId:mineInfo.city]; break;
            case 5:
                if (mineInfo.homeTown) {
                    return [DBCity addressWithId:mineInfo.homeTown];
                }
                break;
            case 6:
                if (mineInfo.bodyHeight>0 && mineInfo.bodyWeight>0) {
                    return [NSString stringWithFormat:@"%lucm/%lukg", mineInfo.bodyHeight, mineInfo.bodyWeight];
                }
                break;
        }
    }else if (indexPath.section == 3){
        
        if (indexPath.row == 0){
            if (mineInfo.isGraduated==1) {
                return @"学生党";
            }else if(mineInfo.isGraduated==2){
                return @"毕业族";
            }
        }else if (indexPath.row == 1){
            return [[DBSchools shareInstance] schoolNameWithID:[mineInfo.school integerValue]];
        }
    }
    
    return @"";
}

@end
