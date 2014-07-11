//
//  TTMMUCManager.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 23/04/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPRoom.h"

typedef void(^MUCGroup)(NSMutableArray *groupArray);
@interface TTMMUCManager : NSObject<XMPPStreamDelegate,XMPPMUCDelegate>

@property (nonatomic, copy) MUCGroup groupCreated;
-(void)createGroups:(MUCGroup )groups;
-(void)askForCreatedGroup:(MUCGroup)groups;
- (XMPPRoom *)currentRoom;
- (void)invitSelectedUserIntoGroup : (NSString *)phNumber;
+(TTMMUCManager *)sharedInstance;
@end
