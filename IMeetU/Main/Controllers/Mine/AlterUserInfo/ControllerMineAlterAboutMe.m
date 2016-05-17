//
//  ControllerMineAlterAboutMe.m
//  IMeetU
//
//  Created by zhanghao on 16/3/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerMineAlterAboutMe.h"
#import <YYKit/YYKit.h>
#import "UIStoryboard+Plug.h"

@interface ControllerMineAlterAboutMe ()<UITextViewDelegate>

@property (nonatomic, copy) NSString *aboutMe;
@property (weak, nonatomic) IBOutlet UITextView *textViewAboutMe;
@property (weak, nonatomic) IBOutlet UILabel *labelWordCount;

@end

@implementation ControllerMineAlterAboutMe

+ (instancetype)controllerMineAlterAboutMe:(NSString *)aboutMe{
    ControllerMineAlterAboutMe *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameMine indentity:@"ControllerMineAlterAboutMe"];
    controller.aboutMe = aboutMe;
    
    return controller;
}

- (void)viewDidLoad{
    [self.textViewAboutMe setText:self.aboutMe];
    [self.labelWordCount setText:[NSString stringWithFormat:@"%lu/500", self.aboutMe.length]];
    self.textViewAboutMe.delegate = self;
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnFinish:(id)sender {
    if (self.delegateAlterAboutMe) {
        if ([self.delegateAlterAboutMe respondsToSelector:@selector(controllerMineAlterAboutMe:aboutMe:)]) {
            [self.delegateAlterAboutMe controllerMineAlterAboutMe:self aboutMe:self.textViewAboutMe.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *content = textView.text;
    if (content.length > 500) {
        content = [content substringToIndex:500];
        self.textViewAboutMe.text = content;
    }
    
    [self.labelWordCount setText:[NSString stringWithFormat:@"%lu/500", content.length]];
}

@end
