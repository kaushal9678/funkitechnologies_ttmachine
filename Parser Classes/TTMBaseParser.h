//
//  TTMBaseParser.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/6/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMEnumClass.h"
#import "TTMNative.h"
#import <Foundation/Foundation.h>

typedef void(^ServerResponse)(id response, NSError *error);

@interface TTMBaseParser : NSObject  { NSMutableData *response_Data;
}

@property (nonatomic, retain) NSMutableData *response_Data;
@property (nonatomic, strong) ServerResponse callBackResponse;

-(void)serviceWithArgument:(NSMutableDictionary *)argument serviceType:(TTMServiceType)serviceType callBackResponse:(ServerResponse)callBack;

@end
