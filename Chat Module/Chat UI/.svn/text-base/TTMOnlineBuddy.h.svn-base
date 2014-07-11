//
//  TTMOnlineBuddy.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/29/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPRoster;
@protocol ChatDelegate;
@protocol  BuddyListDelegate;

typedef void(^OnlineBuddy)(NSMutableArray *list);

@interface TTMOnlineBuddy : NSObject {
    NSMutableArray *onlineBuddies;
}
@property (nonatomic, copy) OnlineBuddy onlineBuddy;
@property (nonatomic, strong) XMPPRoster *xmppRoster;

-(void)getOnlineFriend:(OnlineBuddy)callBack;
@end
