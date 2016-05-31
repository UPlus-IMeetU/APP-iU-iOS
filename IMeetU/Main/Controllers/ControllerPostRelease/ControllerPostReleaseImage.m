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

#define CellReuseIdentifier @"CellPostReleaseImage"
@interface ControllerPostReleaseImage ()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *btnFinish;
@property (weak, nonatomic) IBOutlet UILabel *labelTags;
@property (weak, nonatomic) IBOutlet UILabel *labelPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;
@property (weak, nonatomic) IBOutlet UILabel *labelCountdown;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImages;

@property (nonatomic, strong) NSArray *photos;
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
        NSLog(@"=========>tags tapGestureRecognizer");
    }];
    self.labelTags.userInteractionEnabled = YES;
    [self.labelTags addGestureRecognizer:tapGestureRecognizer];
    
    self.textViewContent.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionViewImages registerNib:[UINib xmNibFromMainBundleWithName:@"CellPostReleaseImage"] forCellWithReuseIdentifier:CellReuseIdentifier];
    self.collectionViewImages.collectionViewLayout = layout;
    self.collectionViewImages.delegate = self;
    self.collectionViewImages.dataSource = self;
    self.collectionViewImages.showsHorizontalScrollIndicator = NO;
    self.collectionViewImages.backgroundColor = [UIColor whiteColor];
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
    if (self.delegatePostImage) {
        if ([self.delegatePostImage respondsToSelector:@selector(controllerPostReleaseImageCancel:)]) {
            [self.delegatePostImage controllerPostReleaseImageCancel:self];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBtnFinish:(id)sender {
    if (self.delegatePostImage) {
        if ([self.delegatePostImage respondsToSelector:@selector(controllerPostReleaseImageFinish:)]) {
            [self.delegatePostImage controllerPostReleaseImageFinish:self];
        }
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
