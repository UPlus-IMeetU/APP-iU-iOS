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
//社区新消息数量
#define AppGlobalStatusCountOfNiticeComm @"UserDefaultAppGlobalStatusCountOfNiticeComm"
//个人主页biu我的人的数量
#define AppGlobalStatusCountOfBiuMe @"UserDefaultAppGlobalStatusCountOfBiuMe"

@interface UserDefult : NSObject

@end
