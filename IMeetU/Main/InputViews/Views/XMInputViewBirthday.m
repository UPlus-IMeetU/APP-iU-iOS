//
//  TFInputViewBirthday.m
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "XMInputViewBirthday.h"

#import "NSDate+plug.h"
@interface XMInputViewBirthday()

@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;

@end
@implementation XMInputViewBirthday


- (IBAction)onClickBtnFinsh:(id)sender {
    NSDate *birthdayDate = self.dataPicker.date;

    if (self.delegateXMInputView != nil) {
        if ([self.delegateXMInputView respondsToSelector:@selector(xmInputViewBirthdayInputWithBirthday:)]) {
            [self.delegateXMInputView xmInputViewBirthdayInputWithBirthday:birthdayDate];
        }
    }
}

+ (NSString*)birthdayStrWithBirthday:(NSInteger)birthday{
    NSDate *birthdayDate = [NSDate dateWithTimeIntervalSince1970:birthday/1000];
    return [NSString stringWithFormat:@"%li年%li月%li日", [birthdayDate yearNumber], [birthdayDate monthNumber], [birthdayDate dayNumber]];
}

@end
