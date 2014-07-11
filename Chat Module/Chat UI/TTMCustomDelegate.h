//
//  TTMCustomDelegate.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/14/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTMCustomDelegate <NSObject>
- (void)newMessageReceived:(NSDictionary *)messageContent;
@end
