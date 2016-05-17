//
//  ControllerUserIdentifierGuide.m
//  IMeetU
//
//  Created by zhanghao on 16/4/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerUserIdentifierGuide.h"

#import "UINib+Plug.h"
#import "UIColor+plug.h"
#import "UIScreen+Plug.h"
#import "UIStoryboard+Plug.h"

#import "MLToast.h"

#import "CellUserIdentifierGuideBody.h"
#import "CellUserIdentifierGuideFooter.h"

#define CellIdentifierBody @"CellUserIdentifierGuideBody"
#define CellIdentifierfooter @"CellUserIdentifierGuideFooter"

@interface ControllerUserIdentifierGuide ()<UITableViewDataSource, UITableViewDelegate, CellUserIdentifierGuideFooterProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableViewMain;

@end

@implementation ControllerUserIdentifierGuide

+ (instancetype)controller{
    ControllerUserIdentifierGuide *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameGuide indentity:@"ControllerUserIdentifierGuide"];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewMain.delegate = self;
    self.tableViewMain.dataSource = self;
    self.tableViewMain.showsVerticalScrollIndicator = NO;
    self.tableViewMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewMain.backgroundColor = [UIColor colorWithR:255 G:255 B:243];
    [self.tableViewMain registerNib:[UINib xmNibFromMainBundleWithName:@"CellUserIdentifierGuideBody"] forCellReuseIdentifier:CellIdentifierBody];
    [self.tableViewMain registerNib:[UINib xmNibFromMainBundleWithName:@"CellUserIdentifierGuideFooter"] forCellReuseIdentifier:CellIdentifierfooter];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 435;
    }else if (indexPath.row == 1){
        if ([UIScreen screenHeight]-435-64 > 210) {
            return [UIScreen screenHeight]-435-64;
        }
        return 210;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        CellUserIdentifierGuideBody *cellBody = [tableView dequeueReusableCellWithIdentifier:CellIdentifierBody];
        cell = cellBody;
    }else if (indexPath.row == 1){
        CellUserIdentifierGuideFooter *cellFooter = [tableView dequeueReusableCellWithIdentifier:CellIdentifierfooter forIndexPath:indexPath];
        cellFooter.delegateCell = self;
        cell = cellFooter;
    }else{
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)cellUserIdentifierGuideFooter:(CellUserIdentifierGuideFooter *)cell wechat:(NSString *)wechat{
    [UIPasteboard generalPasteboard].string = wechat;
    [[MLToast toastInView:self.view content:@"已复制微信号"] show];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
