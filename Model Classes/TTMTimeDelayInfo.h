//
//  TTMTimeDelayInfo.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMTimeDelayInfo : NSObject 

@property (nonatomic, strong) NSString *hours;
@property (nonatomic, strong) NSString *minutes;
@property (nonatomic, assign) BOOL isdurationEnabled;
@property (nonatomic, assign) BOOL isSpecificTimeEnabled;

@end
