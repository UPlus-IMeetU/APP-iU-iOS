//
//  ViewHeaderPostTags.m
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ViewHeaderPostTags.h"

@interface ViewHeaderPostTags()

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
@implementation ViewHeaderPostTags

- (void)awakeFromNib{
    [self.labelTitle setText:@""];
}

- (void)initWithTitle:(NSString *)title{
    [self.labelTitle setText:title];
}

@end
