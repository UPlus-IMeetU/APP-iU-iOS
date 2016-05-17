//
//  ControllerMineAlterCharacter.m
//  IMeetU
//
//  Created by zhanghao on 16/3/9.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerMineAlterCharacter.h"
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"
#import "XMNibStoryboardFilesName.h"
#import "CellCollectionMineAlterCharacter.h"

#import "ModelUser.h"

#import <YYKit/YYKit.h>
#import "AFNetworking.h"
#import "XMUrlHttp.h"
#import "UserDefultAccount.h"

#import "ModelResponse.h"
#import "ModelCharachers.h"
#import "ModelCharacher.h"

#import "MLToast.h"

#define ReusableViewMineAlterCharacterIdentifier @"ReusableViewMineAlterCharacter"

@interface ControllerMineAlterCharacter ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *selectedCharacter;
@property (nonatomic, assign) NSInteger selectedCount;

@property (nonatomic, strong) ModelCharachers *modelCharacters;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCharacter;

@property (nonatomic, assign) NSInteger gender;

@end
@implementation ControllerMineAlterCharacter

+ (instancetype)controllerWithCharacters:(NSArray*)characters gender:(NSInteger)gender{
    ControllerMineAlterCharacter *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameMine indentity:@"ControllerMineAlterCharacter"];
    controller.selectedCharacter = characters;
    controller.selectedCount = characters.count;
    controller.gender = gender;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"type":@"personalied", @"sex":[NSNumber numberWithInteger:self.gender]};
    [httpManager POST:[XMUrlHttp xmAllCharactersInterestChat] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        
        if (response.state == 200) {
            if (response.data) {
                self.modelCharacters = [ModelCharachers modelWithJSON:response.data];
                for (ModelCharacher *mc in self.modelCharacters.characters) {
                    for (ModelCharacher *sc in self.selectedCharacter) {
                        if ([mc.code isEqualToString:sc.code]) {
                            mc.isSelected = YES;
                        }
                    }
                }
                [self.collectionViewCharacter reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [self.collectionViewCharacter registerNib:[UINib xmNibFromMainBundleWithName:NibXMCellCollectionMineAlterCharacter] forCellWithReuseIdentifier:NibXMCellCollectionMineAlterCharacter];
    [self.collectionViewCharacter registerNib:[UINib xmNibFromMainBundleWithName:ReusableViewMineAlterCharacterIdentifier] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewMineAlterCharacterIdentifier];
    self.collectionViewCharacter.dataSource = self;
    self.collectionViewCharacter.delegate = self;
    self.collectionViewCharacter.scrollEnabled = NO;
    self.collectionViewCharacter.collectionViewLayout = layout;
    self.collectionViewCharacter.backgroundColor = [UIColor clearColor];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelCharacters.characterCount;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellCollectionMineAlterCharacter *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NibXMCellCollectionMineAlterCharacter forIndexPath:indexPath];
    ModelCharacher *character = [self.modelCharacters characterOfIndex:indexPath.row];
    [cell initWithCharacter:character.content selected:character.isSelected];
    
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionFooter) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ReusableViewMineAlterCharacterIdentifier forIndexPath:indexPath];
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ModelCharacher *character = [self.modelCharacters characterOfIndex:indexPath.row];
    if (character.isSelected) {
        character.isSelected = !character.isSelected;
        self.selectedCount --;
        [self.collectionViewCharacter reloadData];
    }else{
        if (self.selectedCount < 10) {
            character.isSelected = !character.isSelected;
            self.selectedCount ++;
            [self.collectionViewCharacter reloadData];
        }else{
        
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake([UIScreen screenWidth], 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(24, 40, 20, 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if ([UIScreen is40Screen] || [UIScreen is35Screen]) {
        return ([UIScreen screenWidth]-80-61*3)/2;
    }
    return ([UIScreen screenWidth]-80-61*4)/3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 13;
}

- (IBAction)onClickBtnFinish:(id)sender {
    if (self.modelCharacters.selected.count>0) {
        if (self.delegateAlterCharacter) {
            if ([self.delegateAlterCharacter respondsToSelector:@selector(controllerMineAlterCharacter:selecteds:)]) {
                
                [self.delegateAlterCharacter controllerMineAlterCharacter:self selecteds:self.modelCharacters.selected];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else{
        [[MLToast toastInView:self.view content:@"请选择个性标签"] show];
    }
    
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)charactersWithSelected:(NSArray*)characterSelected{
        NSArray *arr = [ModelUser allCharater];
        NSMutableArray *characterArr = [NSMutableArray array];
        for (NSString *character in arr) {
            NSMutableDictionary *characterDic;
            if ([characterSelected indexOfObject:character] == NSNotFound) {
                characterDic = [NSMutableDictionary dictionaryWithObjects:@[character, @NO] forKeys:@[@"character", @"selected"]];
            }else{
                characterDic = [NSMutableDictionary dictionaryWithObjects:@[character, @YES] forKeys:@[@"character", @"selected"]];
            }
            [characterArr addObject:characterDic];
        }
        
        return characterArr;
}

@end
