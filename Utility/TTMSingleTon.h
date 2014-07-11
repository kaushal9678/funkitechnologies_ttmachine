//
//  TTMSingleTon.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 13/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMSingleTon : NSObject

+(TTMSingleTon*)sharedMySingleton;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *password;

@end
