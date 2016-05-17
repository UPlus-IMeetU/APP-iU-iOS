//
//  ViewChatMsgImgBrowser.m
//  IMeetU
//
//  Created by zhanghao on 16/4/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ViewChatMsgImgBrowser.h"

#import "MLToast.h"
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"

#import "CellChatMsgImgBrowser.h"

#define CellReuseIdentifier @"CellChatMsgImgBrowser"

@interface ViewChatMsgImgBrowser()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CellChatMsgImgBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) NSInteger startIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImg;
@property (nonatomic, assign) BOOL isInitial;
@property (weak, nonatomic) IBOutlet UIView *viewCover;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *viewIndicator;


@end
@implementation ViewChatMsgImgBrowser

+ (instancetype)instanceViewWithAllMsgs:(NSArray *)allMsgs msg:(id<IMessageModel>)messageModel{
    ViewChatMsgImgBrowser *view = [UINib xmViewWithName:@"ViewChatMsgImgBrowser" class:[ViewChatMsgImgBrowser class]];
    view.images = [NSMutableArray array];
    
    int i=0;
    for (EMMessage *msg in allMsgs) {
        if (msg.body.type == EMMessageBodyTypeImage) {
            [view.images addObject:msg];
            
            if ([msg.messageId isEqualToString:messageModel.message.messageId]) {
                view.startIndex = i;
            }
            i++;
        }
    }
    
    [view initial];
    return view;
}

- (void)initial{
    self.frame = CGRectMake(0, 0, [UIScreen screenWidth], [UIScreen screenHeight]);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewImg.collectionViewLayout = layout;
    self.collectionViewImg.dataSource = self;
    self.collectionViewImg.delegate = self;
    self.collectionViewImg.pagingEnabled = YES;
    [self.collectionViewImg registerNib:[UINib xmNibFromMainBundleWithName:@"CellChatMsgImgBrowser"] forCellWithReuseIdentifier:CellReuseIdentifier];
    
    [self.viewIndicator startAnimating];
}

- (void)showInView:(UIView *)view{
    self.alpha = 0;
    if (view) {
        [view addSubview:self];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            self.collectionViewImg.contentOffset = CGPointMake(self.startIndex*[UIScreen screenWidth], 0);
            [UIView animateWithDuration:0.3 animations:^{
                self.viewCover.alpha = 0;
            } completion:^(BOOL finished) {
                self.viewCover.hidden = YES;
            }];
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellChatMsgImgBrowser *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.delegateCell = self;
    if (indexPath.row < self.images.count) {
        [cell initWithImageMsg:self.images[indexPath.row]];
    }else{
        [cell initWithImageMsg:nil];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen screenWidth], [UIScreen screenHeight]);
}

- (IBAction)onClickBtnSaveImg:(id)sender {
    NSInteger index = self.collectionViewImg.contentOffset.x/[UIScreen screenWidth];
    if (index < self.images.count) {
        EMMessage *msg = self.images[index];
        EMImageMessageBody *body = ((EMImageMessageBody *)msg.body);
        UIImage *image = [UIImage imageWithContentsOfFile:body.localPath];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [[MLToast toastInView:self content:@"图片保存成功"] show];
    }else
    {
        [[MLToast toastInView:self content:@"图片保存失败"] show];
    }
}

- (void)cellChatMsgImgBrowser:(CellChatMsgImgBrowser *)cell didClose:(BOOL)close{
    if (close) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end
