//
//  ControllerPostRelease.m
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerPostRelease.h"
#import "POP.h"
#import "UIStoryboard+Plug.h"
#import "UIScreen+Plug.h"
#import "ControllerPostReleaseText.h"
#import "ControllerPostReleaseImage.h"
#import "TZImagePickerController.h"

@interface ControllerPostRelease ()<ControllerPostReleaseTextDelegate, ControllerPostReleaseImageDelegate, TZImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageViewBG;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnPostText;
@property (weak, nonatomic) IBOutlet UIButton *btnPostImage;
@property (weak, nonatomic) IBOutlet UILabel *labelPostText;
@property (weak, nonatomic) IBOutlet UILabel *labelPostImage;

@property (nonatomic, assign) BOOL animationExexFinish;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@end

@implementation ControllerPostRelease

+ (instancetype)controller{
    ControllerPostRelease *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerPostRelease"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageViewBG.alpha = 0;
    self.btnCancel.alpha = 0;
    self.btnPostText.alpha = 0;
    self.btnPostImage.alpha = 0;
    self.labelPostText.alpha = 0;
    self.labelPostImage.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated{
    if (!self.animationExexFinish) {
        self.imageViewBG.frame = CGRectMake(0, 0, [UIScreen screenWidth], [UIScreen screenHeight]);
        [UIView animateWithDuration:0.3 animations:^{
            self.imageViewBG.alpha = 1;
        } completion:^(BOOL finished) {
            [self animationOpen];
        }];
        self.animationExexFinish = YES;
    }
}

- (IBAction)onClickBtnPostText:(id)sender {
    UINavigationController *controllerNavi = [[UINavigationController alloc] init];
    controllerNavi.navigationBar.hidden = YES;
    ControllerPostReleaseText *controller = [ControllerPostReleaseText controller];
    controller.tagModel = self.tagModel;
    controller.delegatePostText = self;
    
    [controllerNavi pushViewController:controller animated:NO];
    [self presentViewController:controllerNavi animated:YES completion:nil];
}

- (IBAction)onClickBtnImage:(id)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
    // imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (IBAction)onClickBtnClose:(id)sender {
    [self animationClose];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageViewBG.alpha = 0;
    } completion:^(BOOL finished) {
        self.tabBarController.tabBar.hidden = NO;
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)animationOpen{
    CGFloat screenWidth = [UIScreen screenWidth];
    CGFloat screenHeight = [UIScreen screenHeight];
    CGPoint btnCancelPositionFrom = CGPointMake(screenWidth/2-1, screenHeight-15-25);
    CGPoint btnCancelPositionTo = CGPointMake(screenWidth/2, screenHeight-15-26);
    
    [self animationGroupWithView:self.btnPostText positionFrom:btnCancelPositionTo positionTo:CGPointMake(screenWidth/4, screenHeight-178-26) scaleFrom:CGSizeMake(0, 0) scaleTo:CGSizeMake(1, 1) rotationFrom:M_PI rotationTo:0 alphaFrom:0 alphaTo:1];
    [self animationGroupWithView:self.btnPostImage positionFrom:btnCancelPositionTo positionTo:CGPointMake(screenWidth/4*3, screenHeight-178-26) scaleFrom:CGSizeMake(0, 0) scaleTo:CGSizeMake(1, 1) rotationFrom:M_PI rotationTo:M_PI*2 alphaFrom:0 alphaTo:1];
    [self animationGroupWithView:self.btnCancel positionFrom:btnCancelPositionFrom positionTo:btnCancelPositionTo scaleFrom:CGSizeMake(0.8, 0.8) scaleTo:CGSizeMake(1, 1) rotationFrom:0 rotationTo:M_PI alphaFrom:0 alphaTo:1];
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.labelPostText.alpha = 1;
        self.labelPostImage.alpha = 1;
    } completion:nil];
}

- (void)animationClose{
    CGFloat screenWidth = [UIScreen screenWidth];
    CGFloat screenHeight = [UIScreen screenHeight];
    CGPoint btnCancelPositionFrom = CGPointMake(screenWidth/2, screenHeight-15-26);
    CGPoint btnCancelPositionTo = CGPointMake(screenWidth/2-1, screenHeight-15-25);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.labelPostText.alpha = 0;
        self.labelPostImage.alpha = 0;
    } completion:^(BOOL finished) {
        [self animationGroupWithView:self.btnPostText positionFrom:CGPointMake(screenWidth/4, screenHeight-178-26) positionTo:btnCancelPositionFrom scaleFrom:CGSizeMake(1, 1) scaleTo:CGSizeMake(0, 0) rotationFrom:0 rotationTo:M_PI alphaFrom:1 alphaTo:0];
        [self animationGroupWithView:self.btnPostImage positionFrom:CGPointMake(screenWidth/4*3, screenHeight-178-26) positionTo:btnCancelPositionFrom scaleFrom:CGSizeMake(1, 1) scaleTo:CGSizeMake(0, 0) rotationFrom:M_PI*2 rotationTo:M_PI alphaFrom:1 alphaTo:0];
        [self animationGroupWithView:self.btnCancel positionFrom:btnCancelPositionFrom positionTo:btnCancelPositionTo scaleFrom:CGSizeMake(1, 1) scaleTo:CGSizeMake(0.8, 0.8) rotationFrom:M_PI rotationTo:0 alphaFrom:1 alphaTo:0];
    }];
}

- (void)animationGroupWithView:(UIView*)view positionFrom:(CGPoint)positionFrom positionTo:(CGPoint)positionTo scaleFrom:(CGSize)scaleFrom scaleTo:(CGSize)scaleTo rotationFrom:(CGFloat)rotationFrom rotationTo:(CGFloat)rotationTo alphaFrom:(CGFloat)alphaFrom alphaTo:(CGFloat)alphaTo{
    
    POPSpringAnimation *animationPosition = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    animationPosition.fromValue = [NSValue valueWithCGPoint:positionFrom];
    animationPosition.toValue = [NSValue valueWithCGPoint:positionTo];
    animationPosition.springBounciness = 10;
    animationPosition.springSpeed = 10;
    
    POPSpringAnimation *animationScale = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSubscaleXY];
    animationScale.fromValue = [NSValue valueWithCGSize:scaleFrom];
    animationScale.toValue = [NSValue valueWithCGSize:scaleTo];
    animationScale.springBounciness = 10;
    animationScale.springSpeed = 10;
    
    POPSpringAnimation *animationRotation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    animationRotation.beginTime = CACurrentMediaTime();
    animationRotation.fromValue = [NSNumber numberWithFloat:rotationFrom];
    animationRotation.toValue = [NSNumber numberWithFloat:rotationTo];
    animationRotation.springBounciness = 3.0f;
    animationRotation.springSpeed = 20.0f;
    
    POPBasicAnimation *animationAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    animationAlpha.fromValue = [NSNumber numberWithFloat:alphaFrom];
    animationAlpha.toValue = [NSNumber numberWithFloat:alphaTo];
    animationAlpha.duration = 0.3;
    
    [view.layer pop_addAnimation:animationPosition forKey:@"animationPosition"];
    [view.layer pop_addAnimation:animationScale forKey:@"animationScale"];
    [view.layer pop_addAnimation:animationRotation forKey:@"animationRotation"];
    [view.layer pop_addAnimation:animationAlpha forKey:@"animationAlpha"];
}

#pragma mark 照片选择代理
/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    //[self.navigationController popViewControllerAnimated:NO];
    [self cloaseController];
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    //self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    //self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    self.isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    [self animationOpen];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0), dispatch_get_main_queue(), ^{
        UINavigationController *controllerNavi = [[UINavigationController alloc] init];
        controllerNavi.navigationBar.hidden = YES;
        ControllerPostReleaseImage *controller = [ControllerPostReleaseImage controllerWithPhotos:photos];
        controller.tagModel = self.tagModel;
        controller.delegatePostImage = self;
        
        [controllerNavi pushViewController:controller animated:NO];
        [self presentViewController:controllerNavi animated:YES completion:nil];
    });
    
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    //    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    //    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    //    _layout.itemCount = _selectedPhotos.count;
    //     open this code to send video / 打开这段代码发送视频
    //     [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    //     NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    //     Export completed, send video here, send by outputPath or NSData
    //     导出完成，在这里写上传代码，通过路径或者通过NSData上传
    //
    //     }];
    //    [_collectionView reloadData];
    //    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark - 发文字帖代理
- (void)controllerPostReleaseTextCancel:(ControllerPostReleaseText *)controller{
    //[self.navigationController popViewControllerAnimated:NO];
    [self cloaseController];
}

- (void)controllerPostReleaseTextFinish:(ControllerPostReleaseText *)controller result:(BOOL)result{
    if (self.postReleaseSuccessBlock) {
        self.postReleaseSuccessBlock(result);
    }
    //[self.navigationController popViewControllerAnimated:NO];
    [self cloaseController];
}

#pragma mark - 发图片贴代理
- (void)controllerPostReleaseImageCancel:(ControllerPostReleaseImage *)controller{
    //[self.navigationController popViewControllerAnimated:NO];
    [self cloaseController];
}

- (void)controllerPostReleaseImageFinish:(ControllerPostReleaseImage *)controller result:(BOOL)result{
    if (self.postReleaseSuccessBlock) {
        self.postReleaseSuccessBlock(result);
    }
    //[self.navigationController popViewControllerAnimated:NO];
    [self cloaseController];
}

- (void)cloaseController{
    self.tabBarController.tabBar.hidden = NO;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
