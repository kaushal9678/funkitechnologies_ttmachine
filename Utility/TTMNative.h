//
//  TTMNative.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "Macro.h"
#import <Foundation/Foundation.h>

@interface TTMNative : NSObject

id getValueForKey(NSString *key);
void setValueWithKey(NSString *key, id object);

@end
