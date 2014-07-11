//
//  TTMMatchedContact.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/14/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMMatchedContact : NSObject
@property (nonatomic, strong) NSString *name;;
@property (nonatomic, strong) NSString *email_Id;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *frTimeStamp;
@property (nonatomic, strong) NSString *frTimeZone;
@property ( readwrite,nonatomic) BOOL isInvited;
@end
