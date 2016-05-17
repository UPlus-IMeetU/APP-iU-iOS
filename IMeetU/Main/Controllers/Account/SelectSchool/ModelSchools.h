//
//  ModelSchools.h
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ModelSchools : NSObject

#pragma mark - 基础方法
-(NSInteger)allSchoolsCount;
-(NSInteger)subSchoolsCount;

-(NSString*)schoolNameFromAllWithLoc:(NSInteger)loc;

-(NSString*)schoolNameFromSubWithLoc:(NSInteger)loc;

-(void)updateSubSchoolsWithKey:(NSString*)key;

#pragma mark - tableView数据方法
-(NSInteger)sectionCount;
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
-(NSString*)titleForHeaderInSection:(NSInteger)section;

-(NSDictionary*)schoolForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
