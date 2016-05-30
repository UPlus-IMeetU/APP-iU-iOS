//
//  ControllerPostTags.m
//  IMeetU
//
//  Created by zhanghao on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerPostTags.h"
#import "UINib+Plug.h"
#import "UIStoryboard+Plug.h"

#import "CellPostTags.h"

#define CellReuseIdentifier @"CellPostTags"

@interface ControllerPostTags ()//<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) ControllerPostTagsType type;
@property (weak, nonatomic) IBOutlet UITableView *tableViewTags;

@end

@implementation ControllerPostTags

+ (instancetype)controllerWithType:(ControllerPostTagsType)type{
    ControllerPostTags *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerPostTags"];
    controller.type = type;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableViewTags registerNib:[UINib xmViewWithName:@"CellPostTags" class:[CellPostTags class]] forCellReuseIdentifier:CellReuseIdentifier];
    //self.tableViewTags.dataSource = self;
    //self.tableViewTags.delegate = self;
    self.tableViewTags.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
}


- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
