//
//  TTMButton.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 05/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TTMButton :  UIButton {
    UIColor * tintColor;
    CAGradientLayer * gradientLayer;
    CALayer * highlightLayer;
}
/**
 This is used to set color.
 */
@property (nonatomic, retain) UIColor * tintColor;



@end
