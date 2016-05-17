//
//  ChatDemoHelper.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 15/12/8.
//  Copyright © 2015年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ControllerDrawerRight.h"

#if DEMO_CALL == 1

#import "CallViewController.h"

@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>

#else

@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

#endif
//
//@property (nonatomic, weak) ContactListViewController *contactViewVC;
//
@property (nonatomic, weak) ControllerDrawerRight *conversationListVC;
//
//@property (nonatomic, weak) MainViewController *mainVC;
//
//@property (nonatomic, weak) ChatViewController *chatVC;

#if DEMO_CALL == 1

@property (strong, nonatomic) EMCallSession *callSession;
@property (strong, nonatomic) CallViewController *callController;

#endif

+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

#if DEMO_CALL == 1

- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall;

#endif

@end
