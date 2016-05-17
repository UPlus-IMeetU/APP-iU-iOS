//
//  ControllerMyAlterName.m
//  MeetU
//
//  Created by zhanghao on 15/8/13.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ControllerMineAlterName.h"
#import "UIStoryboard+Plug.h"

@interface ControllerMineAlterName ()

@property (nonatomic, copy) NSString *nameNick;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UILabel *labelNameLen;

@end

@implementation ControllerMineAlterName

+(instancetype)controllerMyAlterName:(NSString *)nameNick{
    ControllerMineAlterName *controller = [UIStoryboard xmControllerWithName:@"Mine" indentity:@"ControllerMineAlterName"];
    controller.nameNick = nameNick;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textFieldName setText:self.nameNick];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickView:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedNotification:) name:UITextFieldTextDidChangeNotification object:self.textFieldName];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onClickView:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnSave:(id)sender {
    [self.view endEditing:YES];
    if (self.delegateAlterName) {
        if ([self.delegateAlterName respondsToSelector:@selector(controllerMineAlterName:nameNick:)]) {
            [self.delegateAlterName controllerMineAlterName:self nameNick:self.textFieldName.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)textFiledEditChangedNotification:(NSNotification *)obj{
    NSInteger kMaxLength = 10;
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    
    self.labelNameLen.text = [NSString stringWithFormat:@"%02lu/%lu", textField.text.length, kMaxLength];
}

@end
