//
//  CellMineMainPersonalIntroductions.m
//  IMeetU
//
//  Created by zhanghao on 16/3/8.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellMineMainPersonalIntroductions.h"
#import "UIScreen+Plug.h"

@interface CellMineMainPersonalIntroductions()

@property (nonatomic, assign) BOOL isOpen;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenClose;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelContentMarginRight;


@end
@implementation CellMineMainPersonalIntroductions

- (void)initWithContent:(NSString *)content isOpen:(BOOL)isOpen isMine:(BOOL)isMine{
    if (isMine) {
        self.constraintLabelContentMarginRight.constant = 30;
    }else{
        self.constraintLabelContentMarginRight.constant = 0;
    }
    
    if (!content || content.length==0) {
        if (isMine){
            content = @"在这里介绍一下自己咯，关于爱情、关于成长、关于生活的种种......你想着什么样的人，最终会遇到什么样的人。So，给每一位来到这里的TA送上你的祝福";
        }else{
            content = @"TA还没留下关于自己的只言片语呢";
        }
    }
    
    [self.labelContent setText:content];
    if ([CellMineMainPersonalIntroductions realHeightWithContent:content isMine:isMine] < [CellMineMainPersonalIntroductions defultHeight]) {
        [self.btnOpenClose setHidden:YES];
    }else{
        [self.btnOpenClose setHidden:NO];
    }
    
    self.imgViewArrow.hidden = !isMine;
    self.isOpen = isOpen;
}


- (IBAction)onClickBtnOpenClose:(id)sender {
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellMineMainPersonalIntroductions:isOpen:)]) {
            [self.delegateCell cellMineMainPersonalIntroductions:self isOpen:!self.isOpen];
            if (self.isOpen) {
                [self.btnOpenClose setTitle:@"关闭" forState:UIControlStateNormal];
            }else{
                [self.btnOpenClose setTitle:@"展开" forState:UIControlStateNormal];
            }
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)viewHeightWithContent:(NSString*)content isOpen:(BOOL)isOpen isMine:(BOOL)isMine{
    CGFloat maxHeight = [CellMineMainPersonalIntroductions realHeightWithContent:content isMine:isMine];
    
    if (isOpen) {
        return maxHeight;
    }else{
        if (maxHeight > [CellMineMainPersonalIntroductions defultHeight]) {
            return [CellMineMainPersonalIntroductions defultHeight];
        }else{
            return maxHeight;
        }
    }
    return 0;
}

+ (CGFloat)realHeightWithContent:(NSString*)content isMine:(BOOL)isMine{
    CGFloat maxWidth = 0;
    CGFloat maxHeight = 0;
    if (!content || content.length==0) {
        content = @"在这里介绍一下自己咯，关于爱情、关于成长、关于生活的种种......你想着什么样的人，最终会遇到什么样的人。So，给每一位来到这里的TA送上你的祝福";
    }
    if (isMine) {
        maxWidth = [UIScreen screenWidth] - 54;
    }else{
        maxWidth = [UIScreen screenWidth] - 20;
    }
    UILabel *label = [[UILabel alloc] init];
    label.text = content;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    maxHeight = [label sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)].height;
    
    maxHeight += 34;
    
    return maxHeight;
}

+ (CGFloat)defultHeight{
    return 80;
}

@end
