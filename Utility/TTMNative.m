//
//  TTMNative.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMUserDefault.h"
#import "TTMNative.h"

@implementation TTMNative


void setValueWithKey(NSString *key, id object) {
    
    [[TTMUserDefault standardUserDefaults] setObject:object forKey:key];
    [[TTMUserDefault standardUserDefaults] synchronize];
}

id getValueForKey(NSString *key) {
    
    return [[TTMUserDefault standardUserDefaults] objectForKey:key];
}
@end
