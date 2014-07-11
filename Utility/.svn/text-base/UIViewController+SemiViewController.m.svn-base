//
//  UIViewController+SemiViewController.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import "UIViewController+SemiViewController.h"
#import "TTMSemiViewController.h"

@implementation UIViewController (SemiViewController)
@dynamic leftSemiViewController;
@dynamic rightSemiViewController;


- (void)setLeftSemiViewController:(TTMSemiViewController *)semiLeftVC
{
    [self setSemiViewController:semiLeftVC withDirection:SemiViewControllerDirectionLeft];
}

- (void)setRightSemiViewController:(TTMSemiViewController *)semiRightVC
{
    [self setSemiViewController:semiRightVC withDirection:SemiViewControllerDirectionRight];
}

- (void)setSemiViewController:(TTMSemiViewController *)semiVC withDirection:(SemiViewControllerDirection)direction
{
    semiVC.direction = direction;
    CGRect selfFrame = self.view.bounds;
    switch (direction) {
        case SemiViewControllerDirectionRight:
            selfFrame.origin.x += selfFrame.size.width;
            break;
        case SemiViewControllerDirectionLeft:
            selfFrame.origin.x -= selfFrame.size.width;
            break;
    }
    semiVC.view.frame = selfFrame;
    
    /* overlayView if necessory */
    /*
     UIView *overLayView = [[UIView alloc] initWithFrame:self.view.bounds];
     overLayView.backgroundColor = [UIColor blackColor];
     overLayView.alpha = 0.8;
     [self.view addSubview:overLayView];
     */
    
    [self.view addSubview:semiVC.view];
    [self addChildViewController:semiVC];
    [semiVC willMoveToParentViewController:self];
}

@end
