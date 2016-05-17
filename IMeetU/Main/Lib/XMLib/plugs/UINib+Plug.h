//
//  UINib+Plug.h
//  MettU_iOS
//
//  Created by zhanghao on 15/7/8.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINib(Plug)

+ (instancetype)xmNibFromMainBundleWithName:(NSString*)name;

+(id)xmViewWithName:(NSString*)name class:(Class)cls;

+(id)cellWithName:(NSString *)name class:(Class)cls tableView:(UITableView*)tableView identifier:(NSString*)identifier;

+(id)cellWithName:(NSString *)name identifier:(NSString*)identifie;

+ (id)cellWithName:(NSString*)name;
@end
