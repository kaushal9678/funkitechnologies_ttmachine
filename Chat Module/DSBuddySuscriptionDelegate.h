//
//  DSBuddySuscriptionDelegate.h
//  Domains
//
//  Created by Dinesh Mehta on 22/11/13.
//  Copyright (c) 2013 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DSBuddySuscriptionDelegate <NSObject>

@optional
-(void)rejectBuddyRequest;
-(void)acceptBuddyRequest;
@end
