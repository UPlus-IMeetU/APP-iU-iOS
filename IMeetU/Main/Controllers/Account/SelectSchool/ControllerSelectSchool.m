//
//  ControllerViewSelectSchool.m
//  MeetU
//
//  Created by zhanghao on 15/8/4.
//  Copyright (c) 2015年 U-Plus. All rights reserved.
//

#import "ControllerSelectSchool.h"
#import "CellTableSchool.h"

#import "UIStoryboard+Plug.h"
#import "ModelSchools.h"
#import "NSDate+plug.h"
#import "UINib+Plug.h"

#import "ViewSelectSchoolSection.h"

#define CellReuseIdentifier @"CellTableSchool"

@interface ControllerSelectSchool () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSchool;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSchools;

@property (nonatomic, strong) ModelSchools *modelSchools;

@end

@implementation ControllerSelectSchool

+(instancetype)controllerViewSelectSchool{
    ControllerSelectSchool *controller = [UIStoryboard xmControllerWithName:@"ControllerSelectSchool" indentity:@"ControllerSelectSchool"];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableViewSchools registerNib:[UINib xmNibFromMainBundleWithName:@"CellTableSchool"] forCellReuseIdentifier:CellReuseIdentifier];
    self.tableViewSchools.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewSchools.delegate = self;
    self.tableViewSchools.dataSource = self;
    
    [self.textFieldSchool addTarget:self action:@selector(onChangeTextFieldSchool:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.modelSchools updateSubSchoolsWithKey:self.textFieldSchool.text];
    
    [self.tableViewSchools reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)viewDidAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - get/set
-(ModelSchools*)modelSchools{
    if (_modelSchools == nil) {
        _modelSchools = [[ModelSchools alloc] init];
    }
    
    return _modelSchools;
}

#pragma mark - tableViewSchools dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.modelSchools sectionCount];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.modelSchools numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section==1){
        if ([self.modelSchools numberOfRowsInSection:1]>0){
            return 30;
        }else{
            return 0;
        }
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        //return [ViewSelectSchoolDepartmentHeader viewSelectSchoolDepartmentHeaderWithTime:[NSDate currentTimeMillis]];
        return [[UIView alloc] init];
    }else if (section == 1){
        if ([self.modelSchools numberOfRowsInSection:1]>0){
            return [ViewSelectSchoolSection viewSelectSchoolDepartmentSectionWithTitle:[self.modelSchools titleForHeaderInSection:section]];
        }
    }else if (section == 2){
        return [ViewSelectSchoolSection viewSelectSchoolDepartmentSectionWithTitle:[self.modelSchools titleForHeaderInSection:section]];
    }
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellTableSchool *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
   
    [cell initDataWithSchool:[self.modelSchools schoolForRowAtIndexPath:indexPath][@"schoolName"]];
    
    return cell;
}

#pragma mark - tableViewSchools deletage
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *selectedSchool = [self.modelSchools schoolForRowAtIndexPath:indexPath];
    [self.textFieldSchool setText:selectedSchool[@"schoolName"]];
    
    if (self.delegateSelegateSchool) {
        if ([self.delegateSelegateSchool respondsToSelector:@selector(controllerSelectSchool:schoolName:schoolId:)]) {
            [self.delegateSelegateSchool controllerSelectSchool:self schoolName:selectedSchool[@"schoolName"] schoolId:selectedSchool[@"schoolId"]];
        }
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)onChangeTextFieldSchool:(UITextField*)textField{
    [self.modelSchools updateSubSchoolsWithKey:textField.text];
    
    [self.tableViewSchools reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
    
    self.tableViewSchools.contentOffset = CGPointMake(0, 0);
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
