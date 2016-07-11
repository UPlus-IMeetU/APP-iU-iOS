//
//  ControllerPostReleaseImage.m
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerPostReleaseImage.h"
#import <YYKit/YYKit.h>
#import "UINib+Plug.h"
#import "UIStoryboard+Plug.h"
#import "CellPostReleaseImage.h"
#import "ControllerPostTags.h"
#import "MLToast.h"
#import "MBProgressHUD+plug.h"
#import "XMHttpCommunity.h"
#import "XMOSS.h"
#import "UserDefultAccount.h"
#import "NSDate+plug.h"
#import "UIColor+plug.h"

#define CellReuseIdentifier @"CellPostReleaseImage"
@interface ControllerPostReleaseImage ()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ControllerPostTagsDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnFinish;
@property (weak, nonatomic) IBOutlet UILabel *labelTag;
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;
@property (weak, nonatomic) IBOutlet UILabel *labelCountdown;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImages;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSMutableArray *photosModelReq;
/**
 *  发帖时间
 */
@property (nonatomic, copy) NSString *timepost;
@end

@implementation ControllerPostReleaseImage

+ (instancetype)controllerWithPhotos:(NSArray*)photos{
    ControllerPostReleaseImage *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerPostReleaseImage"];
    controller.photos = photos;
    
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
    
    self.textViewContent.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionViewImages registerNib:[UINib xmNibFromMainBundleWithName:@"CellPostReleaseImage"] forCellWithReuseIdentifier:CellReuseIdentifier];
    self.collectionViewImages.collectionViewLayout = layout;
    self.collectionViewImages.delegate = self;
    self.collectionViewImages.dataSource = self;
    self.collectionViewImages.showsHorizontalScrollIndicator = NO;
    self.collectionViewImages.backgroundColor = [UIColor whiteColor];
    if (_tagModel) {
        [self.labelTag setText:[NSString stringWithFormat:@"#%@#", _tagModel.content]];
    }
    self.btnFinish.layer.cornerRadius = 5;
    self.btnFinish.layer.masksToBounds = YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellPostReleaseImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    [cell initWithPhoto:self.photos[indexPath.row]];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 70);
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.view endEditing:YES];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"取消发帖" message:@"要退出内容编辑么？" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.delegatePostImage) {
            if ([self.delegatePostImage respondsToSelector:@selector(controllerPostReleaseImageCancel:)]) {
                [self.delegatePostImage controllerPostReleaseImageCancel:self];
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)onClickBtnFinish:(id)sender {
    [self.textViewContent resignFirstResponder];
    
    if (self.tagModel && self.photos && self.photos.count) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewMain animated:YES];
        hud.color = [UIColor colorWithR:0 G:0 B:0 A:0.7];
        hud.minSize = CGSizeMake(100, 100);
        self.timepost = [NSString stringWithFormat:@"%lu", [NSDate currentTimeMillisSecond]];
        [self releasePostWithImgIndex:0 hud:hud];
    }else if (!self.tagModel){
        [[MLToast toastInView:self.view content:@"请选择话题"] show];
    }else if (!self.photos || self.photos.count<1){
        [[MLToast toastInView:self.view content:@"请选择照片"] show];
    }
}

- (void)controllerPostTags:(ControllerPostTags *)controller model:(ModelTag *)model{
    [self.navigationController popViewControllerAnimated:YES];
    self.tagModel = model;
    [self.labelTag setText:[NSString stringWithFormat:@"#%@#", model.content]];
    
    [self.btnFinish setBackgroundColor:[UIColor whiteColor]];
    [self.btnFinish setTitleColor:[UIColor often_6CD1C9:1] forState:UIControlStateNormal];
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
}


- (void)releasePostWithImgIndex:(NSInteger)index hud:(MBProgressHUD*)hud{
    if (index < self.photos.count) {
        hud.progress = 0;
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = [NSString stringWithFormat:@"%li/%li", index+1, self.photos.count];
        
        UIImage *img = self.photos[index];
        NSString *fileName = [NSString stringWithFormat:@"community/post/img/%@_%@_%li.jpeg", [UserDefultAccount userCode], self.timepost, index];
        [self.photosModelReq addObject:@{
                                         @"url":fileName,
                                         @"w":[NSNumber numberWithFloat:img.size.width],
                                         @"h":[NSNumber numberWithFloat:img.size.height]
                                         }];
        
        [XMOSS uploadFileWithData:UIImageJPEGRepresentation(img, 0.8) fileName:fileName progress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            hud.progress = totalByteSent/1.0/totalBytesExpectedToSend;
            
        } finish:^id(OSSTask *task, NSString *fileName) {
            if (!task.error) {
                [self releasePostWithImgIndex:index+1 hud:hud];
            }else{
                [hud xmSetCustomModeWithResult:NO label:@"图片上传失败"];
                [hud hide:YES afterDelay:0.3];
            }
            return nil;
        }];
    }else{
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"发布...";
        
        NSArray *tags = @[[NSNumber numberWithInteger:self.tagModel.tagId]];
        [[XMHttpCommunity http] releasePostTxtImgWithTags:tags imgs:self.photosModelReq content:self.textViewContent.text callback:^(NSInteger code, NSString *postId, NSError *err) {
            if (code == 200) {
                [hud xmSetCustomModeWithResult:YES label:@"发布成功"];
                if (self.delegatePostImage) {
                    if ([self.delegatePostImage respondsToSelector:@selector(controllerPostReleaseImageFinish:result:)]) {
                        [self.delegatePostImage controllerPostReleaseImageFinish:self result:YES];
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }else{
                [hud xmSetCustomModeWithResult:YES label:@"发布失败"];
            }
            [hud hide:YES afterDelay:0.3];
        }];
    }
}

- (NSMutableArray *)photosModelReq{
    if (!_photosModelReq) {
        _photosModelReq = [NSMutableArray array];
    }
    return _photosModelReq;
}
@end
