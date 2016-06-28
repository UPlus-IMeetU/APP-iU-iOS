//
//  UserDefult.h
//  IMeetU
//
//  Created by zhanghao on 16/5/19.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>


//==============BiuBiu
#define BIU_IN_MATCH @"BiuInMatch" //biu正在匹配中
#define BIU_SEND_TIME @"BiuSendTime"
#define BIU_IN_MATCH_GRAB_PROFILE @"BiuInMatchProfile" //最近一个抢biu的人的头像


#define MsgNotification @"UserDefultConfigMsgNotification"
#define MsgNotificationIsSound @"UserDefultConfigMsgNotificationIsSound"
#define MsgNotificationIsVibration @"UserDefultConfigMsgNotificationIsVibration"

//==============UserDefultAppGlobalStatus
#define AppGlobalStatusCountOfNiticeComm @"UserDefaultAppGlobalStatusCountOfNiticeComm"
//个人主页biu我的人的数量
#define AppGlobalStatusCountOfBiuMe @"UserDefaultAppGlobalStatusCountOfBiuMe"


//社区biu我的人
#define GlobalStatusComBiuCount @"comBiuCount"
//点赞或者是评论
#define GlobalStatusNoticeBiuCount @"noticeCount"



@interface UserDefult : NSObject

@end
