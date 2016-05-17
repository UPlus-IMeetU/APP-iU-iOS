//
//  ModelContacts.m
//  IMeetU
//
//  Created by zhanghao on 16/3/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ModelContacts.h"
#import "ModelContact.h"

@implementation ModelContacts

+ (instancetype)modelWithContacts:(NSArray *)model{
    ModelContacts *contacts = [[ModelContacts alloc] init];
    contacts.contacts = model;
    return contacts;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}

- (ModelContact *)contactForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [self numberOfRowsInSection:indexPath.section]) {
        return self.contacts[indexPath.row];
    }
    return nil;
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"contacts":@"users"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{
             @"contacts":[ModelContact class]
             };
}

@end
