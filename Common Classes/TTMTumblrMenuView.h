//
//  TTMTumblrMenuView.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 10/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TTMTumblrMenuViewSelectedBlock)(void);


@interface TTMTumblrMenuView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, readonly)UIImageView *backgroundImgView;
- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(TTMTumblrMenuViewSelectedBlock)block;
- (void)show;
@end