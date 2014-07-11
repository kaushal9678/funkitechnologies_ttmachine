//
//  TTMArrow.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/29/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMEnumClass.h"
#import "UIBezierPath+dqd_arrowhead.h"

@interface TTMArrow : UIView
//Create object for the UIBezierPath for tracking the path
@property (nonatomic, strong) UIBezierPath *textPath;
//Create refence for holding the initiale frame
@property (nonatomic, assign) CGRect initialeFrame;

@property (nonatomic, assign) TTMSenderType senderType;

@property (nonatomic, assign) TTMArrowFramingType frameType;
//UIView with initialization of the initial frame and actual frame
@end
