//
//  XMUrlHttp.h
//  IMeetU
//
//  Created by zhanghao on 16/3/12.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMUrlHttp : NSObject

/**
 *  判断一个手机号是否已经注册过
 */
+ (NSString*)xmIsRegisteredPhone;
/**
 *  注册、登录、修改密码
 */
+ (NSString*)xmRegister;
+ (NSString*)xmLogin;
+ (NSString*)xmResetPassword;
+ (NSString*)xmLogout;
/**
 *  获取、更新个人主页信息、更新头像
 */
+ (NSString*)xmMineInfo;
+ (NSString*)xmUpdateMineInfo;
+ (NSString*)xmUpdateProfile;
/**
 *  添加、删除照片
 */
+ (NSString*)xmPhotoAdd;
+ (NSString*)xmPhotoDelete;
/**
 *  获取OSS令牌
 */
+ (NSString*)xmOSSToken;

/**
 *  获取个性、兴趣
 */
+ (NSString*)xmAllCharactersInterestChat;
/**
 *  获取发biubiu话题列表
 */
+ (NSString*)xmAllCharactersInterestChatTopic;
/**
 *  发送biubiu
 */
+ (NSString*)xmBiuSend;
/**
 *  更新biubiu主页信息
 */
+ (NSString*)xmUpdateBiuMainInfo;
/**
 *  更新biubiu主页信息(未登录)
 */
+ (NSString *)xmUpdateBiuMainInfoUnlogin;
/**
 *  查看biubiu详情
 */
+ (NSString *)xmReceiveBiuDetails;
/**
 *  抢biu
 */
+ (NSString *)xmReceiveBiuGrabBiu;
/**
 *  不再接收TA
 */
+ (NSString *)xmReceiveBiuUnreceiveTA;
/**
 *  将匹配用户设为已读状态
 */
+ (NSString *)xmUpdateBiuMatchUserStatus;
/**
 *  更新推送channel
 */
+ (NSString*)xmUpdateChannel;
/**
 *  更新位置
 */
+ (NSString*)xmUpdateLocation;
/**
 *  匹配设置
 */
+ (NSString*)xmMatchSetting;
+ (NSString*)xmMatchSettingUpdate;
/**
 *  创建购买biu币订单
 */
+ (NSString*)xmPayCreateBiuOrder;
/**
 *  校验购买U米结果
 */
+ (NSString*)xmPayVerifyUmiOrderRes;
/**
 *  获取联系人列表
 */
+ (NSString*)xmContactList;
/**
 *  解除关系
 */
+ (NSString*)xmUnfriendYou;
/**
 *  举报用户
 */
+ (NSString*)xmReportUser;

+ (NSString*)xmChangeUserStateRead;

+ (NSString*)xmEnablePay;

/**
 * 跟新订单状态
 */
+ (NSString*)xmUpdateBill;

/**
 *  获取活动
 */
+ (NSString *)xmGetActivity;

/**
 *  获取匹配用户
 */
+ (NSString *)xmLoadMatchUsers;
/**
 *  获取U米
 */
+ (NSString *)xmGetUMi;

+ (NSString *)xmLoadGrabBiuList;

+ (NSString *)xmAcceptUserGrabBiu;

+ (NSString *)xmShutdownBiu;

/**
 *  获取社区首页的列表
 */
+ (NSString *)xmGetCommunityList;
/**
 *  获取帖子详情
 */
+ (NSString *)xmGetPostDetail;
/**
 *  删除帖子
 */
+ (NSString *)xmDeletePost;
/**
 *  点赞
 */
+ (NSString *)xmDoPraise;
/**
 *  根据标签ID获取列表
 */
+ (NSString *)xmGetPostListWithTagId;
/**
 *  举报
 */
+ (NSString *)xmCreateReport;
/**
 * 所有帖子标签
 */
+ (NSString *)xmPostTagsAll;
/**
 * 查询帖子标签
 */
+ (NSString*)xmPostTagsSearch;
/**
 * 创建标签
 */
+ (NSString *)xmPostTagsCreate;
/**
 * 发布图文帖子
 */
+ (NSString *)xmPostTxtImgRelease;
/**
 *  创建评论
 */
+ (NSString *)xmCreateComment;

/**
 *  删除评论
 */
+ (NSString *)xmDeleteComment;

+ (NSString *)xmGrabCommBiu;

+ (NSString *)xmGetMyPostList;
/**
 *  社区通知
 */
+ (NSString *)xmCommunityNitifies;
/**
 *  清空社区通知
 */
+ (NSString *)xmCommunityNitifiesClean;
/**
 *  获取程序全局状态
 */
+ (NSString *)xmGetAppGlobalStatus;

+ (NSString *)xmBiuMeListGet;

+ (NSString *)xmBiuMeListClean;

+ (NSString *)xmBiuMeListAccept;
@end
