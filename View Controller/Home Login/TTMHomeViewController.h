//
//  TTMHomeViewController.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 28/02/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "Macro.h"
#import "TTMMenuViewController.h"
#import "TTMBaseParser.h"
#import "TTMButton.h"
#import "TTMTextField.h"
#import <UIKit/UIKit.h>
#import "RCLocationManager.h"

@interface TTMHomeViewController : TTMCommonViewController
@property (nonatomic, strong) RCLocationManager *locationManager;

@end
