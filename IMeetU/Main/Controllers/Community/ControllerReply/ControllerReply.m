//
//  ControllerReply.m
//  IMeetU
//
//  Created by Spring on 16/5/29.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerReply.h"
#import "UIStoryboard+Plug.h"
#import "UIColor+Plug.h"
#import "UINib+Plug.h"
#import "MBProgressHUD+plug.h"
#import "XMHttpCommunity.h"


#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "MLToast.h"

#import "CommunityReplyCell.h"
#import "ModelPostDetail.h"
#import "YYKit/YYKit.h"
#import "PostListCell.h"
#import "UserDefultAccount.h"
#import "EnumHeader.h"
#import "ControllerMineMain.h"
#import "ControllerSamePostList.h"
#import "ControllerMineMain.h"
#import "MJIUHeader.h"
#import "UIFont+Plug.h"

@interface ControllerReply ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
/**
 *  评论列表
 */
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UITableView *replyTableView;
@property (strong,nonatomic) NSMutableArray *commentArray;
//输入框
@property (weak, nonatomic) IBOutlet UIView *inputView;
//输入框的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;


/**
 *  回复的信息
 */
@property (strong, nonatomic) ModelComment *selectedModelComment;
@property (strong, nonatomic) ModelComment *currentModelComment;
@property (strong, nonatomic) ModelPost *modelPost;

@property (nonatomic,assign) long long lastTime;
@property (nonatomic,assign) BOOL isHasNext;
@end

@implementation ControllerReply

+ (instancetype)shareControllerReply{
    static ControllerReply *controller;
    controller = [UIStoryboard xmControllerWithName:xmStoryboardNameCommunity indentity:@"ControllerReply"];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self prepareUI];
    //注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)prepareData{
    _commentArray = [NSMutableArray array];
    [self loadDataWithTime:0 withRefreshType:Refresh];
}

- (void)loadDataWithTime:(long long)time withRefreshType:(RefreshType)refreshType{
    __weak typeof (self) weakSelf = self;
    [[XMHttpCommunity http] loadPostDetailWithPostId:self.postId withTimeStamp:time withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            ModelPostDetail *modelPostDetail = [ModelPostDetail modelWithJSON:response];
            //创建视图
            weakSelf.lastTime = modelPostDetail.time;
            weakSelf.isHasNext = modelPostDetail.hasNext;
            PostListCell *postCell =  [[[NSBundle mainBundle] loadNibNamed:@"PostListCell" owner:self options:nil] lastObject];
            postCell.size = CGSizeMake(self.view.width, [ModelPost cellHeightWith:modelPostDetail.post]);
            postCell.modelPost = modelPostDetail.post;
            //保存一下当前的信息
            weakSelf.modelPost = modelPostDetail.post;
            if (refreshType == Refresh) {
                [weakSelf.commentArray removeAllObjects];
                weakSelf.commentArray = [NSMutableArray arrayWithArray:modelPostDetail.commentList];
            }else{
                [weakSelf.commentArray addObjectsFromArray:modelPostDetail.commentList];
            }
            
            postCell.postViewCreateCommentBlock = ^(NSInteger postId){
                [weakSelf.textView becomeFirstResponder];
            };
            postCell.postViewOperationBlock = ^(NSInteger postId,OperationType operationType,NSInteger userCode){
                [weakSelf operationBtnClickWithPostId:postId withOperationType:operationType withUserCode:userCode];
            };
            
            postCell.postViewPraiseBlock = ^(NSInteger postId,NSInteger userCode,NSInteger praise){
                [weakSelf doPraiseWithId:postId withUserCode:userCode withPraise:praise];
            };
            if (!_notGoSameList) {
                postCell.postViewGoSameTagListBlock = ^(ModelTag *modelTag){
                    [weakSelf gotoTagListWithTag:modelTag];
                };
            }
            postCell.postViewGoHomePageBlock = ^(NSInteger userCode){
                [weakSelf gotoHomePage:userCode];
            };
            _replyTableView.tableHeaderView = postCell;
            [_replyTableView reloadData];
        };
        [_replyTableView.mj_header endRefreshing];
        [_replyTableView.mj_footer endRefreshing];
        
        
    }];
}
- (void)prepareUI{
    _replyTableView.showsVerticalScrollIndicator = NO;
    _replyTableView.showsHorizontalScrollIndicator = NO;
    _replyTableView.contentOffset = CGPointMake(0, 0);
    _replyTableView.backgroundColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:0.5];
    // 上拉刷新和下拉加载
    __weak typeof (self) weakSelf = self;
    _replyTableView.mj_header = [MJIUHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithTime:0 withRefreshType:Refresh];
    }];
    [((MJIUHeader *)_replyTableView.mj_header) initGit];
   
    _replyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (!_isHasNext) {
            [weakSelf.replyTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            ModelComment *modelComment = [_commentArray lastObject];
            [weakSelf loadDataWithTime:modelComment.createAt withRefreshType:Loading];
        }
        
    }];
    MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter *)_replyTableView.mj_footer;
    footer.stateLabel.textColor = [UIColor colorWithR:128 G:128 B:128 A:1];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    //设置为没有颜色
    _replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //进行列表的注册
    [_replyTableView registerNib:[UINib xmNibFromMainBundleWithName:@"CommunityReplyCell"] forCellReuseIdentifier:@"CommunityReplyCell"];
    
    //设置textView的颜色
    _textView.layer.cornerRadius = 4;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = [UIColor often_CCCCCC:1].CGColor;
    _textView.clipsToBounds = YES;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeySend;
    
    _placeHolderLabel.text = @"你想说点什么呢?";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 监听的方法
- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
{
    //获取键盘的高度
    //创建一个透明视图
    
    [self.view bringSubviewToFront:_inputView];
    CGRect _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        _bottomHeight.constant = _keyboardRect.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)keyboardWillHide:(NSNotification*)notification //键盘下落
{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        _bottomHeight.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)textDidChanged:(NSNotification *)notif //监听文字改变 换行时要更改输入框的位置
{
    NSString *textString = _textView.text;
    CGSize titleSize = [textString sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(self.view.width - 30, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    if (ceil(titleSize.height) + 13 > _inputViewHeight.constant) {
        [UIView animateWithDuration:0.1 animations:^{
            _inputViewHeight.constant = ceil(titleSize.height) + 13 ;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _textView.contentOffset = CGPointZero;
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            if (ceil(titleSize.height) + 13 <= 43) {
                _inputViewHeight.constant = 43;
            }else{
                _inputViewHeight.constant = ceil(titleSize.height) + 13 ;
            }
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
        if (textView.text.length > 300) {
            textView.text = [textView.text substringToIndex:300];
        }
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([[self.textView.text stringByTrim] isEqualToString:@""]) {
            return NO;
        }
        //点击确定按钮了
        [self createComment];
        return NO;
    }
    return YES;
}

//回复或者是评论
- (void)createComment{
    //是否有评论的人
    NSInteger toUserCode = 0;
    NSInteger parentId = 0;
    if (_selectedModelComment) {
        toUserCode = _selectedModelComment.userFromCode;
        parentId = _selectedModelComment.commentId;
    }else{
          toUserCode = _modelPost.userCode;
    }
    __weak typeof(self) weakSelf = self;
    [[XMHttpCommunity http] createCommentWithPostId:_modelPost.postId withParentId:parentId withToUserCode:toUserCode withContent:_textView.text callback:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                [[MLToast toastInView:self.view content:@"评论成功了~"] show];
                weakSelf.textView.text = @"";
                [weakSelf.textView resignFirstResponder];
                weakSelf.placeHolderLabel.text = @"你想说点什么...";
                weakSelf.placeHolderLabel.hidden = NO;
                weakSelf.selectedModelComment = nil;
                ModelComment *modelComment = [ModelComment modelWithJSON:[response objectForKey:@"comment"]];
                [_commentArray insertObject:modelComment atIndex:0];
                [_replyTableView reloadData];
                
                self.modelPost.commentNum ++;
                [((PostListCell *)_replyTableView.tableHeaderView) setModelPost:self.modelPost];
                
                //进行通知
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[NSNumber numberWithInteger:_modelPost.postId] forKey:@"postId"];
                [dict setObject:@(2) forKey:@"operation"];
                [dict setObject:@(0) forKey:@"delete"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postStatusChange" object:dict];
                
                weakSelf.inputViewHeight.constant = 46;
                [weakSelf.view layoutIfNeeded];
                
                //滑动到对应的位置
                //_replyTableView.contentOffset = CGPointMake([], <#CGFloat y#>)
            }else{
                [[MLToast toastInView:self.view content:@"评论失败了~"] show];
            }

    }];
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityReplyCell *replyCell = [tableView dequeueReusableCellWithIdentifier:@"CommunityReplyCell"];
    replyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //进行删除或者举报操作
    typeof(self) weakSelf = self;
    replyCell.modelComment = _commentArray[indexPath.row];
    replyCell.replyOperationBlock = ^(NSInteger commentId,NSInteger userCode){
        if ([[UserDefultAccount userCode] integerValue] == userCode) {
              [weakSelf operationBtnClickWithPostId:commentId withOperationType:OperationCommentDelete withUserCode:nil];
        }else{
            [weakSelf operationBtnClickWithPostId:commentId withOperationType:OperationCommentReport withUserCode:userCode];
        }
    };
    
    replyCell.replyGotoHomePage = ^(NSInteger userCode){
        ControllerMineMain *mainMain = [ControllerMineMain controllerWithUserCode:[NSString stringWithFormat:@"%ld",(long)userCode] getUserCodeFrom:MineMainGetUserCodeFromParam];
        [weakSelf.navigationController pushViewController:mainMain animated:YES];
    };
    return replyCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelComment *modelComment = _commentArray[indexPath.row];
    NSString *str;
    if (modelComment.parentId == 1) {
        str = [NSString stringWithFormat:@"回复 %@:%@",modelComment.userToName,modelComment.content];
    }else{
        str = modelComment.content;
    }
    CGFloat commentSizeHeight = [UIFont getSpaceLabelHeight:modelComment.content withFont:[UIFont systemFontOfSize:13] withWidth:(self.view.width - 63) withLineSpacing:2.6];
    return ceil(commentSizeHeight) + 30 + 35 + 18 + 15;
}

//点击操作进行评论
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedModelComment = _commentArray[indexPath.row];
    //判断是否是自己
    _placeHolderLabel.text = [NSString stringWithFormat:@"回复%@:",_selectedModelComment.userFromName];
    [_textView becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentArray.count;
}

/**
 *  返回按钮
 */
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)operationBtnClickWithPostId:(NSInteger) postId withOperationType:(OperationType)operationType withUserCode:(NSInteger) userCode{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *operationStr = @"";
    if (operationType == OperationTypeDelete || operationType == OperationCommentDelete) {
        operationStr = @"删除";
    }else{
        operationStr = @"举报";
    }
    
    NSString *messageStr = @"";
    if (operationType == OperationTypeDelete || operationType == OperationCommentDelete) {
        messageStr = @"嗨，确定要删除内容么?";
    }else{
        messageStr = @"嗨，确定要举报TA么?";
    }
    [controller addAction:[UIAlertAction actionWithTitle:operationStr style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //弹出框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:operationStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (operationType == OperationTypeDelete || operationType == OperationCommentDelete) {
                [self deletePostWithId:postId withOperationType:operationType];
            }else{
                [self reportPostWithId:postId withOperationType:operationType withUserCode:userCode];
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}


//滚动的时候让键盘落下
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textView resignFirstResponder];
}
/**
 *  进行删除操作
 *
 *  @param postId 删除的postId
 */
- (void)deletePostWithId:(NSInteger)postId withOperationType:(OperationType)operation{
    if (operation == OperationCommentDelete) {
        [[XMHttpCommunity http] deleteCommentWithId:postId withCallBack:^(NSInteger code, id response, NSError *error) {
            if (code == 200) {
                //首先自己进行
                int index = 0;
                for(; index < _commentArray.count ; index++){
                    ModelComment *modelComment = _commentArray[index];
                    if (modelComment.commentId == postId) {
                        break;
                    }
                }

                [_commentArray removeObjectAtIndex:index];
                [_replyTableView reloadData];
                self.modelPost.commentNum --;
                [((PostListCell *)_replyTableView.tableHeaderView) setModelPost:self.modelPost];
                //发送通知
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[NSNumber numberWithInteger:_modelPost.postId] forKey:@"postId"];
                [dict setObject:@(2) forKey:@"operation"];
                [dict setObject:@(1) forKey:@"delete"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postStatusChange" object:dict];
                
            }else{
                [[MLToast toastInView:self.view content:@"删除失败了>_<"] show];
            }
        }];
    }
    else{
        [[XMHttpCommunity http] deletePostWithId:postId withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[NSNumber numberWithInteger:postId] forKey:@"postId"];
                [dict setObject:@(0) forKey:@"operation"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postStatusChange" object:dict];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [[MLToast toastInView:self.view content:@"删除失败了>_<"] show];
            }
        }];
    }
}
- (void)reportPostWithId:(NSInteger)postId withOperationType:(OperationType)operation withUserCode:(NSInteger) userCode{
    if (operation == OperationCommentReport) {
        [[XMHttpCommunity http] createReportWithPostId:-1 withCommentId:postId withUserCode:userCode withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                [[MLToast toastInView:self.view content:@"评论举报成功了"] show];
            }else{
                [[MLToast toastInView:self.view content:@"评论举报失败了"] show];
            }
        }];
    }else{
        [[XMHttpCommunity http] createReportWithPostId:postId withCommentId:-1 withUserCode:userCode withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
            if (code == 200) {
                [[MLToast toastInView:self.view content:@"举报成功了"] show];
            }else{
                [[MLToast toastInView:self.view content:@"举报失败了"] show];
            }
        }];
        
    }
}



#pragma mark 进行点赞操作
- (void)doPraiseWithId:(NSInteger)postId withUserCode:(NSInteger) userCode withPraise:(NSInteger)praise{
    [[XMHttpCommunity http] praisePostWithId:postId withUserCode:userCode withCallBack:^(NSInteger code, id response, NSURLSessionDataTask *task, NSError *error) {
        if (code == 200) {
            
            self.modelPost.isPraise = !self.modelPost.isPraise;
            if (praise == 0) {
                self.modelPost.praiseNum ++;
            }else{
                self.modelPost.praiseNum --;
            }
            [((PostListCell *)_replyTableView.tableHeaderView) setModelPost:self.modelPost];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithInteger:postId] forKey:@"postId"];
            [dict setObject:@(1) forKey:@"operation"];
            [dict setObject:[NSNumber numberWithInteger:praise] forKey:@"praise"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postStatusChange" object:dict];
        }else{
            [[MLToast toastInView:self.view content:@"点赞失败了>_<"] show];
            
        }
    }];
    
}
#pragma mark 进入个人主页
- (void)gotoHomePage:(NSInteger)userCode{
    ControllerMineMain *mainMain = [ControllerMineMain controllerWithUserCode:[NSString stringWithFormat:@"%ld",(long)userCode] getUserCodeFrom:MineMainGetUserCodeFromParam];
    [self.navigationController pushViewController:mainMain animated:YES];
}
#pragma mark 进入相同的列表
- (void)gotoTagListWithTag:(ModelTag *)modelTag{
    ControllerSamePostList *samePostList = [ControllerSamePostList controllerSamePostList];
    samePostList.titleName = modelTag.content;
    samePostList.tagId = modelTag.tagId;
    [self.navigationController pushViewController:samePostList animated:YES];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
}

@end
