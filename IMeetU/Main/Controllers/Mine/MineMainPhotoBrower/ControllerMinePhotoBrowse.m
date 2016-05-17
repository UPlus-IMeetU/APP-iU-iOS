//
//  ControllerMineMainPhotoBrower.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerMinePhotoBrowse.h"
#import <YYKit/YYKit.h>

#import "UINib+Plug.h"
#import "UIColor+Plug.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"

#import "XMNibStoryboardFilesName.h"

#import "CellMinePhotoBrowse.h"
#import "ModelMinePhoto.h"

#import "AFNetworking.h"
#import "XMUrlHttp.h"
#import "UserDefultAccount.h"
#import "ModelResponse.h"

#import "MBProgressHUD.h"

@interface ControllerMinePhotoBrowse ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) ModelMinePhoto *nowPhoto;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) BOOL isMine;
@property (weak, nonatomic) IBOutlet UILabel *labelIndex;
@property (weak, nonatomic) IBOutlet UIButton *btnDeletePhoto;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;

@property (nonatomic, strong) UIActionSheet *actionPhotoDel;
@end

@implementation ControllerMinePhotoBrowse

+ (instancetype)controllerWithPhotos:(NSMutableArray *)photos startIndex:(NSInteger)index isMine:(BOOL)isMine{
    ControllerMinePhotoBrowse *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameMine indentity:@"ControllerMinePhotoBrowse"];
    controller.startIndex = index;
    controller.photos = photos;
    controller.isMine = isMine;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionViewPhotos registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellCollectionMinePhotoBrowse] forCellWithReuseIdentifier:NibXMCellCollectionMinePhotoBrowse];
    self.collectionViewPhotos.backgroundColor = [UIColor colorWithR:233 G:233 B:233];
    self.collectionViewPhotos.showsHorizontalScrollIndicator = NO;
    self.collectionViewPhotos.collectionViewLayout = layout;
    self.collectionViewPhotos.pagingEnabled = YES;
    self.collectionViewPhotos.dataSource = self;
    self.collectionViewPhotos.delegate = self;
    
    self.labelIndex.hidden = YES;
    self.collectionViewPhotos.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.btnDeletePhoto.hidden = !self.isMine;
}

- (void)viewDidAppear:(BOOL)animated{
    self.collectionViewPhotos.contentOffset = CGPointMake([UIScreen screenWidth]*self.startIndex-1, 0);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.collectionViewPhotos.alpha = 1;
    } completion:^(BOOL finished) {
        self.nowPhoto = self.photos[self.startIndex];
        self.labelIndex.hidden = NO;
        [self.labelIndex setText:[NSString stringWithFormat:@"%lu/%lu", self.startIndex+1, self.photos.count]];
    }];
}


- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnDelete:(id)sender {
    [self.actionPhotoDel showInView:self.view];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellMinePhotoBrowse *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NibXMCellCollectionMinePhotoBrowse forIndexPath:indexPath];
    ModelMinePhoto *photo = self.photos[indexPath.row];
    [cell initWithUrl:photo.photoUrlOrigin];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger nowIndex = (NSInteger)(scrollView.contentOffset.x/[UIScreen screenWidth]);
    [self.labelIndex setText:[NSString stringWithFormat:@"%lu/%lu", nowIndex+1, self.photos.count]];
    self.nowPhoto = self.photos[nowIndex];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen screenWidth], [UIScreen screenHeight]-64);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (actionSheet == self.actionPhotoDel) {
        if (buttonIndex == 0) {
            AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
            httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"photo_name":self.nowPhoto.photoName, @"photo_code":self.nowPhoto.photoCode};
            [httpManager POST:[XMUrlHttp xmPhotoDelete] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                NSDictionary *resDic = response.data;
                
                if (response.state == 200) {
                    [self.photos removeObject:self.nowPhoto];
                    
                    if (self.delegatePhotoBrowse) {
                        if ([self.delegatePhotoBrowse respondsToSelector:@selector(controllerMinePhotoBrowse:deletePhotos:)]) {
                            [self.delegatePhotoBrowse controllerMinePhotoBrowse:self deletePhotos:self.photos];
                        }
                    }
                    [self.collectionViewPhotos reloadData];
                    [self.labelIndex setText:[NSString stringWithFormat:@"%lu/%lu", (NSInteger)(self.collectionViewPhotos.contentOffset.x/[UIScreen screenWidth])+1, self.photos.count]];
                }else{
                    
                }
                [hud hide:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [hud hide:YES];
            }];

        }
    }
}

- (UIActionSheet *)actionPhotoDel{
    if (!_actionPhotoDel) {
        _actionPhotoDel = [[UIActionSheet alloc] initWithTitle:@"确定删除照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除照片" otherButtonTitles:nil];
    }
    return _actionPhotoDel;
}

@end
