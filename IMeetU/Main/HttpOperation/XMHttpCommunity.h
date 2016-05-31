//
//  XMHttpCommunity.h
//  IMeetU
//
//  Created by Spring on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttp.h"

@interface XMHttpCommunity : XMHttp
/**
 *  请求社区列表
 *
 *  @param postListType 类型 0 推荐 1 最新 2 biubiu
 *  @param timestamp  时间
 *  @param callback     回调
 */
- (void)loadCommunityListWithType:(NSInteger) postListType withTimeStamp:(long long)timestamp withCallBack:(XMHttpBlockStandard)callback;

- (void)loadPostDetailWithPostId:(NSInteger)postId withTimeStamp:(long long)timeStamp withCallBack:(XMHttpBlockStandard)callback;

- (void)deletePostWithId:(NSInteger) postId withCallBack:(XMHttpBlockStandard)callback;

- (void)praisePostWithId:(NSInteger) postId withUserCode:(NSInteger)userCode withCallBack:(XMHttpBlockStandard)
    callback;

- (void)getPostListWithId:(NSInteger) postId withTimeStamp:(long long)timeStamp withCallBack:(XMHttpBlockStandard)callback;

- (void)createReportWithPostId:(NSInteger) postId withCommentId:(NSInteger) commentId withUserCode: (NSInteger) userCode withCallBack:(XMHttpBlockStandard)callback;
@end
