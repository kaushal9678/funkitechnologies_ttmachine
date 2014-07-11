//
//  TTMTextViewInternal.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 01/04/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMTextViewInternal : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic) BOOL displayPlaceHolder;

@end
