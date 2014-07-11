//
//  TTMOnlineBuddy.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/29/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMAppDelegate.h"
#import "TTMOnlineBuddy.h"
#import "XMPP.h"
#import "XMPPRoster.h"
#import "TTMUserInfo.h"

@implementation TTMOnlineBuddy
@synthesize xmppRoster = _xmppRoster;
@synthesize onlineBuddy = _onlineBuddy;
/*
 @Get App delgate instance
 */
- (TTMAppDelegate *)appDelegate {
	return (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)getOnlineFriend:(OnlineBuddy)callBack {
    self.onlineBuddy = callBack;
    TTMAppDelegate *del = [self appDelegate];
    del.chatDelegate = (id)self;
    onlineBuddies = [[NSMutableArray alloc ] init];
    if ([[self appDelegate] connect]) {
        NSLog(@"show buddy list");
    }
}

#pragma mark -
#pragma mark Chat delegate

- (void)newBuddyOnline:(TTMUserInfo *)buddyName {
	
	if (![onlineBuddies containsObject:buddyName]) {
        
		[onlineBuddies addObject:buddyName];
		self.onlineBuddy(onlineBuddies);
	}
	
}

- (void)buddyWentOffline:(TTMUserInfo *)buddyName {
	
	[onlineBuddies removeObject:buddyName];
	self.onlineBuddy(onlineBuddies);
}

- (void)didDisconnect {
	
	[onlineBuddies removeAllObjects];
	self.onlineBuddy(onlineBuddies);
}
/*
 @Get XMPPStream instance
 */
- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}
/*
 @Get XMPPRoster instance
 */
- (XMPPRoster *)xmppRoster {
	return [[self appDelegate] xmppRoster];
}

@end
