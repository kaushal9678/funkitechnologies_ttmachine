//
//  UIButton+Block.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#define kUIButtonBlockTouchUpInside @"TouchInside"

#import <UIKit/UIKit.h>

@interface UIButton (Block)
@property (nonatomic, strong) NSMutableDictionary *actions;

- (void) setAction:(NSString*)action withBlock:(void(^)())block;
@end
