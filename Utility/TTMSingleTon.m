//
//  TTMSingleTon.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 13/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMSingleTon.h"

@implementation TTMSingleTon
@synthesize user_id = _user_id;
@synthesize password = _password;

static TTMSingleTon * _sharedMySingleton = nil;

+(TTMSingleTon*)sharedMySingleton
{
    @synchronized([TTMSingleTon class])
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[self alloc] init];
        }
        return _sharedMySingleton;
    }
    return nil;
}

@end
