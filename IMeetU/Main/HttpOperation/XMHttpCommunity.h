//
//  XMHttpCommunity.h
//  IMeetU
//
//  Created by Spring on 16/5/30.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "XMHttp.h"

#import "ModelTag.h"
#import "ModelTagsAll.h"
#import "ModelTagsSearch.h"

typedef void(^XMHttpCallBackPostTagsAll)(NSInteger code, ModelTagsAll *model, NSError *err);
typedef void(^XMHttpCallBackPostTagsSearch)(NSInteger code, ModelTagsSearch *model, NSError *err);
typedef void(^XMHttpCallBackPostTagsCreate)(NSInteger code, ModelTag *model, NSError *err);
typedef void(^XMHttpCallBackPostTxtImgCreate)(NSInteger code, NSString *postId, NSError *err);

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

/**
 *  获取所有帖子列表/上来加载更多
 *  @param 标签创建时间
 *  @param 标签下帖子数量
 */
- (void)allPostTagWithTime:(long long)time postNum:(long long)postNum callback:(XMHttpCallBackPostTagsAll)callback;

/**
 *  搜索标签
 *  @param 关键词
 *  @param 标识（网络请求顺序）
 */
- (void)searchPostTagWithStr:(NSString*)str num:(int)num callback:(XMHttpCallBackPostTagsSearch)callback;
/**
 *  创建标签
 *  @param 标签内容
 */
- (void)createPostTagWithContent:(NSString*)content callback:(XMHttpCallBackPostTagsCreate)callback;
/**
 *  发布帖子
 *  @param 标签数组（标签id）
 *  @param 图片数组（[{url:"", w:"", h""},....]）
 *  @param 帖子文字内容
 */
- (void)releasePostTxtImgWithTags:(NSArray*)tags imgs:(NSArray*)imgs content:(NSString*)content callback:(XMHttpCallBackPostTxtImgCreate)callback;
@end
