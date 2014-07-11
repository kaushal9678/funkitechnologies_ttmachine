//
//  TTMDelayTimeView.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMTimeDelayInfo.h"

@interface TTMDelayTimeView : UIView

@property (nonatomic, strong) TTMTimeDelayInfo *timeDelay;
@property (nonatomic, assign) BOOL isDurationSelected;
@property (nonatomic, assign) BOOL isSpecificSelected;
@end
