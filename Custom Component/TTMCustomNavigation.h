//
//  TTMCustomNavigation.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 11/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonAction)(id);
@interface TTMCustomNavigation : UIView

@property (nonatomic, strong)ButtonAction action;

-(void)addLeftButton:(UIImage *)image callBackAction:(ButtonAction)callBack;
-(void)addRightButton:(UIImage *)image callBackAction:(ButtonAction)callBack;
-(void)addMiddleButton:(UIImage *)image callBackAction:(ButtonAction)callBack;
@end
