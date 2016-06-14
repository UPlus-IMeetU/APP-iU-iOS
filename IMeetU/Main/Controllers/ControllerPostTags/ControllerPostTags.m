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

#import "UIColor+Plug.h"
#import "CellPostTags.h"
#import "ViewHeaderPostTags.h"

#import "ModelTag.h"
#import "ModelTagsAll.h"
#import "ModelTagsSearch.h"

#import "XMHttpCommunity.h"
#import "MBProgressHUD+plug.h"

#import "MJRefresh.h"

#define CellReuseIdentifier @"CellPostTags"
#define HeaderFooterViewReuseIdentifier @"ViewHeaderPostTags"

typedef NS_ENUM(NSInteger, PostTagsShowContent) {
    PostTagsShowContentAll,
    PostTagsShowContentSearch
};

@interface ControllerPostTags ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelNoCreated;
@property (weak, nonatomic) IBOutlet UITableView *tableViewTags;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (weak, nonatomic) IBOutlet UILabel *labelSearchCountdown;
@property (weak, nonatomic) IBOutlet UIView *viewMain;


/**
 * 当前发起搜索请求的总次数
 */
@property (nonatomic, assign) int countOfSearchRequest;
/**
 * 最后一次搜索响应编号
 */
@property (nonatomic, assign) int numOfLastResp;

@property (nonatomic, assign) PostTagsShowContent postTagsShowContent;

@property (nonatomic, copy) NSString *lastSearchContent;

@property (nonatomic, strong) ModelTagsAll *modelTagsAll;
@property (nonatomic, strong) ModelTagsSearch *modelTagsSearch;

@property (nonatomic, assign) ControllerPostTagsType type;
@end

@implementation ControllerPostTags

+ (instancetype)controllerWithType:(ControllerPostTagsType)type{
    ControllerPostTags *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerPostTags"];
    controller.type = type;
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFieldSearch.layer.cornerRadius = self.textFieldSearch.frame.size.height * 0.5;
    [self.textFieldSearch clipsToBounds];
    [self.tableViewTags registerNib:[UINib xmNibFromMainBundleWithName:@"CellPostTags"] forCellReuseIdentifier:CellReuseIdentifier];
    [self.tableViewTags registerNib:[UINib xmNibFromMainBundleWithName:@"ViewHeaderPostTags"] forHeaderFooterViewReuseIdentifier:HeaderFooterViewReuseIdentifier];
    self.tableViewTags.dataSource = self;
    self.tableViewTags.delegate = self;
    self.tableViewTags.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.textFieldSearch addTarget:self action:@selector(onEditingChangeTextFieldSearch:) forControlEvents:UIControlEventEditingChanged];
    
    MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"" animated:YES];
    [[XMHttpCommunity http] allPostTagWithTime:0 postNum:0 callback:^(NSInteger code, ModelTagsAll *model, NSError *err) {
        if (code == 200) {
            self.modelTagsAll = model;
            [self.tableViewTags reloadData];
        }else{

        }
        [hud hide:YES afterDelay:0.2];
    }];
    [self addFooterRefresh];
    
    if (self.type == ControllerPostTagsTypeSearch) {
        self.textFieldSearch.placeholder = @"选择话题标签";
    }else if (self.type == ControllerPostTagsTypeSearchCreate){
        self.textFieldSearch.placeholder = @"创建/选择话题标签";
    }
    
    self.labelNoCreated.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.postTagsShowContent == PostTagsShowContentAll) {
        return [self.modelTagsAll numberOfSections];
    }else if (self.postTagsShowContent == PostTagsShowContentSearch){
        return [self.modelTagsSearch numberOfSections];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.postTagsShowContent == PostTagsShowContentAll) {
        return [self.modelTagsAll numberOfRowsInSection:section];
    }else if (self.postTagsShowContent == PostTagsShowContentSearch){
        return [self.modelTagsSearch numberOfRowsInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.textFieldSearch resignFirstResponder];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ViewHeaderPostTags *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderFooterViewReuseIdentifier];
    if (self.postTagsShowContent == PostTagsShowContentAll) {
        [view initWithTitle:[self.modelTagsAll titleWithIndex:section]];
    }else if (self.postTagsShowContent == PostTagsShowContentSearch){
        [view initWithTitle:[self.modelTagsSearch titleWithIndex:section]];
    }
    
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellPostTags *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    if (self.postTagsShowContent == PostTagsShowContentAll){
        [cell initWithTag:[self.modelTagsAll tagContentWithIndexPath:indexPath]];
    }else if (self.postTagsShowContent == PostTagsShowContentSearch){
        [cell initWithTag:[self.modelTagsSearch tagContentWithIndexPath:indexPath]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegatePostTags) {
        if ([self.delegatePostTags respondsToSelector:@selector(controllerPostTags:model:)]) {
            if (self.postTagsShowContent == PostTagsShowContentAll) {
                [self.delegatePostTags controllerPostTags:self model:[self.modelTagsAll modelWithIndexPath:indexPath]];
            }else if (self.postTagsShowContent == PostTagsShowContentSearch){
                if (indexPath.section == 0) {
                    if ([self.modelTagsSearch numberOfSections]==1) {
                        //选择
                        [self.delegatePostTags controllerPostTags:self model:[self.modelTagsSearch modelWithIndexPath:indexPath]];
                    }else if ([self.modelTagsSearch numberOfSections]==2){
                        //新建
                        MBProgressHUD *hud = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.viewMain label:@"" animated:YES];
                        [[XMHttpCommunity http] createPostTagWithContent:[self.modelTagsSearch tagContentWithIndexPath:indexPath] callback:^(NSInteger code, ModelTag *model, NSError *err) {
                            if (code == 200) {
                                [hud xmSetCustomModeWithResult:YES label:@"创建成功"];
                                [self.delegatePostTags controllerPostTags:self model:model];
                            }else{
                                [hud xmSetCustomModeWithResult:YES label:@"创建失败"];
                            }
                            [hud hide:YES afterDelay:0.3];
                        }];
                    }
                }else if (indexPath.section == 1){
                    //选择
                    [self.delegatePostTags controllerPostTags:self model:[self.modelTagsSearch modelWithIndexPath:indexPath]];
                }
            }
        }
    }
    
}

- (void)onEditingChangeTextFieldSearch:(UITextField*)sender{
    
    UITextRange *selectedRange = [sender markedTextRange];
    //获取高亮部分
    UITextPosition *position = [sender positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，进入搜索流程
    if (!position) {
        if (sender.text && sender.text.length>0){
            if (sender.text.length > 30){
                [sender setText:[sender.text substringWithRange:NSMakeRange(0, 30)]];
            }
            [self.labelSearchCountdown setText:[NSString stringWithFormat:@"%i", 30-(int)sender.text.length]];
            //搜索框中的内容与上次搜索不一致时才能再次进行搜索请求
            if (![sender.text isEqualToString:self.lastSearchContent]) {
                self.tableViewTags.mj_footer = nil;
                self.lastSearchContent = sender.text;
                self.countOfSearchRequest ++;
                
                //如果之前为全部标签
                if (self.postTagsShowContent == PostTagsShowContentAll) {
                    //搜索字符串
                    self.modelTagsSearch.searchStr = self.lastSearchContent;
                    //切换状态
                    self.postTagsShowContent = PostTagsShowContentSearch;
                    //刷新列表
                    [self.tableViewTags reloadData];
                }
                [[XMHttpCommunity http] searchPostTagWithStr:self.lastSearchContent num:self.countOfSearchRequest callback:^(NSInteger code, ModelTagsSearch *model, NSError *err) {
                    if (code == 200) {
                        if (model.num > self.numOfLastResp) {
                            self.numOfLastResp = model.num;
                            self.modelTagsSearch = model;
                            self.modelTagsSearch.searchStr = self.lastSearchContent;
                            
                            if (self.type == ControllerPostTagsTypeSearch) {
                                _modelTagsSearch.isCreate = NO;
                            }else if (self.type == ControllerPostTagsTypeSearchCreate){
                                _modelTagsSearch.isCreate = YES;
                            }
                            
                            if ([self.modelTagsSearch numberOfSections] == 1) {
                                if ([self.modelTagsSearch numberOfRowsInSection:0] == 0){
                                    self.labelNoCreated.hidden = NO;
                                }else{
                                    self.labelNoCreated.hidden = YES;
                                }
                            }else if ([self.modelTagsSearch numberOfSections] == 2){
                                if ([self.modelTagsSearch numberOfRowsInSection:1] == 0){
                                    self.labelNoCreated.hidden = NO;
                                }else{
                                    self.labelNoCreated.hidden = YES;
                                }
                            }
                            
                            [self.tableViewTags reloadData];
                        }
                    }
                }];
            }
        }else{
            self.postTagsShowContent = PostTagsShowContentAll;
            [self.tableViewTags reloadData];
            self.labelNoCreated.hidden = YES;
            [self addFooterRefresh];
        }
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (ModelTagsAll *)modelTagsAll{
    if (!_modelTagsAll) {
        _modelTagsAll = [[ModelTagsAll alloc] init];
    }
    return _modelTagsAll;
}

- (ModelTagsSearch *)modelTagsSearch{
    if (!_modelTagsSearch) {
        _modelTagsSearch = [[ModelTagsSearch alloc] init];
        if (self.type == ControllerPostTagsTypeSearch) {
            _modelTagsSearch.isCreate = NO;
        }else if (self.type == ControllerPostTagsTypeSearchCreate){
            _modelTagsSearch.isCreate = YES;
        }
    }
    return _modelTagsSearch;
}

- (void)addFooterRefresh{
    if (!self.tableViewTags.mj_footer) {
        self.tableViewTags.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [[XMHttpCommunity http] allPostTagWithTime:self.modelTagsAll.time postNum:self.modelTagsAll.postNum callback:^(NSInteger code, ModelTagsAll *model, NSError *err) {
                if (code == 200) {
                    [self.modelTagsAll additionalNewerWithTags:model.postNewest];
                    self.modelTagsAll.hasNext = model.hasNext;
                    self.modelTagsAll.time = model.time;
                    self.modelTagsAll.postNum = model.postNum;
                    
                    if (!model.hasNext) {
                        [self.tableViewTags.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableViewTags.mj_footer endRefreshing];
                    }
                    [self.tableViewTags reloadData];
                    
                    [self.modelTagsSearch numberOfRowsInSection:1];
                }else{
                    [self.tableViewTags.mj_footer endRefreshing];
                }
            }];
        }];
    }
}
@end
