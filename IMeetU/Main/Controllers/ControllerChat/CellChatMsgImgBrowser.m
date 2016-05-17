//
//  CellChatMsgImgBrowser.m
//  IMeetU
//
//  Created by zhanghao on 16/4/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "CellChatMsgImgBrowser.h"
#import <YYKit/YYKit.h>

@interface CellChatMsgImgBrowser()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation CellChatMsgImgBrowser

- (void)initWithImage:(UIImage *)image{
    [self.imageView setImage:image];
}

- (void)initWithImageMsg:(EMMessage *)imageMsg{
    EMImageMessageBody *body = ((EMImageMessageBody *)imageMsg.body);
    
    UIImage *image = [UIImage imageWithContentsOfFile:body.thumbnailLocalPath];
    [self.imageView setImage:image];
    
    if (body.downloadStatus != EMDownloadStatusSuccessed) {
        [[EMClient sharedClient].chatManager asyncDownloadMessageAttachments:imageMsg progress:nil completion:^(EMMessage *message, EMError *error) {
            EMImageMessageBody *body = ((EMImageMessageBody *)message.body);
            UIImage *image = [UIImage imageWithContentsOfFile:body.localPath];
            
            [self.imageView setImage:image];
        }];
    }else{
        UIImage *image = [UIImage imageWithContentsOfFile:body.localPath];
        [self.imageView setImage:image];
    }
}

- (IBAction)onClickBtnClose:(id)sender {
    if (self.delegateCell) {
        if ([self.delegateCell respondsToSelector:@selector(cellChatMsgImgBrowser:didClose:)]) {
            [self.delegateCell cellChatMsgImgBrowser:self didClose:YES];
        }
    }
}


@end
