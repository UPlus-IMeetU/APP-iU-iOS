//
//  ViewSelectSchoolDepartmentSection.m
//  MeetU
//
//  Created by zhanghao on 15/10/31.
//  Copyright © 2015年 U-Plus. All rights reserved.
//

#import "ViewSelectSchoolSection.h"
#import "UINib+Plug.h"

@interface ViewSelectSchoolSection()

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
@implementation ViewSelectSchoolSection

+ (instancetype)viewSelectSchoolDepartmentSectionWithTitle:(NSString *)title{
    ViewSelectSchoolSection *view = [UINib xmViewWithName:@"ViewSchoolGroup" class:[ViewSelectSchoolSection class]];
    [view.labelTitle setText:title];
    
    return view;
}

@end
