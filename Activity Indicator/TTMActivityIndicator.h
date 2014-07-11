//
//  TTMActivityIndicator.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 13/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "DDIndicator.h"
#import <UIKit/UIKit.h>

@interface TTMActivityIndicator : UIView

@property (nonatomic, strong) DDIndicator *ind;

+(TTMActivityIndicator*)sharedMySingleton;

-(void)addIndicator:(UIView *)view;
-(void)removeIndicator:(UIView *)view;@end
