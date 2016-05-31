//
//  ControllerPostReleaseText.m
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerPostReleaseText.h"
#import <YYKit/YYKit.h>
#import "UIStoryboard+Plug.h"
#import "ControllerPostTags.h"
#import "ControllerPostTags.h"

@interface ControllerPostReleaseText ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnFinish;
@property (weak, nonatomic) IBOutlet UILabel *labelTags;
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;
@property (weak, nonatomic) IBOutlet UILabel *labelCountdown;

@end

@implementation ControllerPostReleaseText

+ (instancetype)controller{
    ControllerPostReleaseText *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerPostReleaseText"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        ControllerPostTags *controller = [ControllerPostTags controllerWithType:ControllerPostTagsTypeRelease];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    self.labelTags.userInteractionEnabled = YES;
    [self.labelTags addGestureRecognizer:tapGestureRecognizer];
    
    self.textViewContent.delegate = self;
}

- (IBAction)onClickBtnCancel:(id)sender {
    if (self.delegatePostText) {
        if ([self.delegatePostText respondsToSelector:@selector(controllerPostReleaseTextCancel:)]) {
            [self.delegatePostText controllerPostReleaseTextCancel:self];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBtnFinish:(id)sender {
}

- (void)textViewDidChange:(UITextView *)textView{
    NSInteger kMaxLength = 300;
    
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textView.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    
    int countdown = 300 - (int)textView.text.length;
    self.labelCountdown.text = [NSString stringWithFormat:@"%03i", countdown>=0?countdown:0];
    self.labelPlaceholder.hidden = textView.text.length>0;
}
@end
