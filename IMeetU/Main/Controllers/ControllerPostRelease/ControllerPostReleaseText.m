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
#import "MLToast.h"
#import "MBProgressHUD+plug.h"
#import "XMHttpCommunity.h"

#import "UIColor+Plug.h"

@interface ControllerPostReleaseText ()<UITextViewDelegate, ControllerPostTagsDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnFinish;
@property (weak, nonatomic) IBOutlet UILabel *labelTag;
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
        ControllerPostTags *controller = [ControllerPostTags controllerWithType:ControllerPostTagsTypeSearchCreate];
        controller.delegatePostTags = self;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    self.labelTag.userInteractionEnabled = YES;
    [self.labelTag addGestureRecognizer:tapGestureRecognizer];
    if (_tagModel) {
        [self.labelTag setText:[NSString stringWithFormat:@"#%@#", _tagModel.content]];
    }
    self.textViewContent.delegate = self;
    
    self.btnFinish.layer.cornerRadius = 5;
    self.btnFinish.layer.masksToBounds = YES;
    
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.view endEditing:YES];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"取消发帖" message:@"要退出内容编辑么？" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.delegatePostText) {
            if ([self.delegatePostText respondsToSelector:@selector(controllerPostReleaseTextCancel:)]) {
                [self.delegatePostText controllerPostReleaseTextCancel:self];
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:controller animated:YES completion:nil];

}

- (IBAction)onClickBtnFinish:(id)sender {
    [self.textViewContent resignFirstResponder];
    
    if (self.textViewContent.text.length > 0 && self.tagModel) {
        [self.textViewContent resignFirstResponder];
        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view label:@"" animated:YES];
        [[XMHttpCommunity http] releasePostTxtImgWithTags:@[[NSNumber numberWithInteger:self.tagModel.tagId]] imgs:@[] content:self.textViewContent.text callback:^(NSInteger code, NSString *postId, NSError *err) {
            if (code == 200) {
                [hud xmSetCustomModeWithResult:YES label:@"发布成功"];
                if (self.delegatePostText) {
                    if ([self.delegatePostText respondsToSelector:@selector(controllerPostReleaseTextFinish:result:)]) {
                        [self.delegatePostText controllerPostReleaseTextFinish:self result:YES];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.2), dispatch_get_main_queue(), ^{
                            [self dismissViewControllerAnimated:YES completion:nil];
                        });
                    }
                }
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"发布失败"];
            }
            [hud hide:YES afterDelay:0.3];
        }];
    }else if (self.textViewContent.text.length < 1){
        [[MLToast toastInView:self.view content:@"请填写帖子内容"] show];
    }else if (!self.tagModel){
        [[MLToast toastInView:self.view content:@"请选择话题"] show];
    }
}

- (void)controllerPostTags:(ControllerPostTags *)controller model:(ModelTag *)model{
    [self.navigationController popViewControllerAnimated:YES];
    self.tagModel = model;
    [self.labelTag setText:[NSString stringWithFormat:@"#%@#", model.content]];
    
    if(self.textViewContent.text.length>0){
        [self.btnFinish setBackgroundColor:[UIColor whiteColor]];
        [self.btnFinish setTitleColor:[UIColor often_6CD1C9:1] forState:UIControlStateNormal];
    }
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
            
            //设置行间距
            NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:textView.text];
            contentText.font = [UIFont systemFontOfSize:13];
            contentText.lineSpacing = 2.6;
            [textView setAttributedText:contentText];
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
    
    if(self.textViewContent.text.length>0 && self.tagModel){
        [self.btnFinish setBackgroundColor:[UIColor whiteColor]];
        [self.btnFinish setTitleColor:[UIColor often_6CD1C9:1] forState:UIControlStateNormal];
    }else{
        [self.btnFinish setBackgroundColor:[UIColor colorWithR:233 G:231 B:222]];
        [self.btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    
}

@end
