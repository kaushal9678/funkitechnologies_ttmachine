//
//  TTMSemiViewController.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationCompletion)(id sender, NSError *error);
typedef enum {
    SemiViewControllerDirectionLeft,
    SemiViewControllerDirectionRight,
}SemiViewControllerDirection;

@interface TTMSemiViewController : UIViewController


@property (nonatomic, copy) AnimationCompletion complitionBlock;
@property (nonatomic, assign) SemiViewControllerDirection direction;
@property (nonatomic, assign) CGFloat sideAnimationDuration;
@property (nonatomic, assign) CGFloat sideOffset;

@property (nonatomic, strong) UIView *contentView;


- (void)dismissSemi:(id)sender;
- (void)blockMethodAssinableOnly:(AnimationCompletion )block;

@end
