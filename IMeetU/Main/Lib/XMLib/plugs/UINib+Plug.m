//
//  UINib+Plug.m
//  MettU_iOS
//
//  Created by zhanghao on 15/7/8.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "UINib+Plug.h"

@implementation UINib(Plug)

+ (instancetype)xmNibFromMainBundleWithName:(NSString*)name{
    return [UINib nibWithNibName:name bundle:[NSBundle mainBundle]];
}

+(id)xmViewWithName:(NSString *)name class:(Class)cls{
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    
    if (views == nil) {
        return nil;
    }
    for (int i=0; i<views.count; i++) {
        id view = views[i];
        if([view isKindOfClass:cls]){
            return view;
        }
    }
    return nil;
}

+(id)cellWithName:(NSString *)name class:(Class)cls tableView:(UITableView*)tableView identifier:(NSString*)identifier{
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    //注册以便循环利用
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    if (views == nil) {
        return nil;
    }
    for (int i=0; i<views.count; i++) {
        id view = views[i];
        if([view isKindOfClass:cls]){
            return view;
        }
    }
    return nil;
}

+(id)cellWithName:(NSString *)name identifier:(NSString*)identifie{
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    
    if (views != nil && views.count > 0) {
        return views[0];
    }
    
    return nil;
}

+ (id)cellWithName:(NSString *)name{
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    
    if (views != nil && views.count > 0) {
        return views[0];
    }
    
    return nil;
}

@end
